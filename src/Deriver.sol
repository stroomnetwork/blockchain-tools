// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {EllipticCurve} from "../lib/elliptic-curve-solidity/contracts/EllipticCurve.sol";
import {Hmac} from "./Hmac.sol";
import {Bech32m} from "./Bech32m.sol";

library Deriver {
    // BEGIN SECP256k1 CONSTANTS
    uint256 public constant GX =
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256 public constant GY =
        0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
    uint256 public constant AA = 0;
    uint256 public constant BB = 7;
    uint256 public constant PP =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
    uint256 public constant NN = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141; 
    // END SECP256k1 CONSTANTS

    // HardenedKeyStart is the index at which a hardened key starts.  Each
	// extended key has 2^31 normal child keys and 2^31 hardened child keys.
	// Thus the range for normal child keys is [0, 2^31 - 1] and the range
	// for hardened child keys is [2^31, 2^32 - 1].
    // Pubkey derivation is only supported for normal(not hardened) child keys.
	uint256 public constant HARDENED_KEY_START = 0x80000000; // 2^31

    // sha256("TapTweak")
    bytes32 public constant SHA256_TAP_TWEAK =
        hex"e80fe1639c9ca050e3af1b39c143c63e429cbceb15d940fbb5c5a1f4af57c5e9";

    // pubkey add operation
    function addPubkeys(
        uint256 x1,
        uint256 y1,
        uint256 x2,
        uint256 y2
    ) internal pure returns (uint256, uint256) {
        return EllipticCurve.ecAdd(x1, y1, x2, y2, AA, PP);
    }

    // pubkey multiplication by scalar operation
    function mulPubkey(
        uint256 x,
        uint256 y,
        uint256 scalar
    ) internal pure returns (uint256, uint256) {
        return EllipticCurve.ecMul(scalar, x, y, AA, PP);
    }

    // derive Bitcoin address from pubkey
    // only x coordinate is used for address generation
    function getBtcTaprootAddrFromPubkey(
        uint256 x,
        bytes memory hrp
    ) internal pure returns (string memory) {
        return string(Bech32m.encodeSegwitAddress(hrp, 1, abi.encodePacked(x)));
    }

    // calculate y coordinate from x coordinate
    function liftX(uint256 x) internal pure returns (uint256) {
        return EllipticCurve.deriveY(0x02, x, AA, BB, PP);
    }

    // tweaks pubkey with a no script path
    // According to BIP 341: "If the spending conditions do not require a script path,
    // the output key should commit to an unspendable script path instead of having no script path"
    // Note: resulting point may have odd y coordinate(not compatible with BIP-340), however
    // it is used for address derivation which requires only x coordinate.
    function computeTaprootKeyNoScript(
        uint256 x,
        uint256 y
    ) internal pure returns (uint256, uint256) {
        // Calculate TaggedHash("TapTweak", x)
        uint256 h = uint256(
            sha256(abi.encode(SHA256_TAP_TWEAK, SHA256_TAP_TWEAK, x))
        );

        (uint256 x1, uint256 y1) = mulPubkey(GX, GY, h);

        (uint256 x2, uint256 y2) = addPubkeys(x, y, x1, y1);

        return (x2, y2);
    }

    // Public key derivation works only for normal(not hardened) child keys.
    // index < HARDENED_KEY_START
    function deriveChildPubkeyBip32(
        uint256 px,
        uint256 py,
        bytes32 chainCode,
        uint256 index
    ) internal pure returns (uint256, uint256) {
        require(index < HARDENED_KEY_START, "Index must be less than HARDENED_KEY_START");

        bytes1 prefix = 0x02;
        if (py % 2 == 1) {
            prefix = 0x03;
        }

        bytes memory data = abi.encodePacked(
            prefix, 
            bytes32(px),
            uint32(index)
        );

        (bytes32 ilBytes32,) = Hmac.hmacSha512(abi.encodePacked(chainCode), data);
        uint256 il = uint256(ilBytes32);

        require(il < NN, "il must be less than NN");

        (uint256 ilx, uint256 ily) = mulPubkey(GX, GY, il);
        (uint256 x1, uint256 y1) = addPubkeys(px, py, ilx, ily);

        require(x1 != 0 || y1 != 0, "child pubkey is point at infinity");

        return (x1, y1);
    }

    function deriveReceivingAddressFromIndex(
        uint256 parentX,
        uint256 parentY,
        uint256 index,
        bytes memory hrp
    ) internal pure returns (string memory){
        bytes1 prefix = 0x02;
        if (parentY % 2 == 1) {
            prefix = 0x03;
        }

        bytes memory parentSerialized = abi.encodePacked(
            prefix, 
            bytes32(parentX)
        );

        bytes32 chainCode = sha256(parentSerialized);

        (uint256 childX, uint256 childY) = deriveChildPubkeyBip32(parentX, parentY, chainCode, index);

        if (childY % 2 == 1) {
            childY = PP - childY;
        }

        (uint256 childXTweaked,) = computeTaprootKeyNoScript(childX, childY);

        return getBtcTaprootAddrFromPubkey(childXTweaked, hrp);
    }
}
