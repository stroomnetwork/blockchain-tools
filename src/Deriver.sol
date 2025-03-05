// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import {EllipticCurve} from "../lib/elliptic-curve-solidity/contracts/EllipticCurve.sol";

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
    // END SECP256k1 CONSTANTS

    // sha256("TapTweak")
    bytes32 public constant SHA256_TAP_TWEAK =
        hex"e80fe1639c9ca050e3af1b39c143c63e429cbceb15d940fbb5c5a1f4af57c5e9";
    
    // TODO(mkl): use tagged hashes
    function getCoefficient(
        uint256 x1,
        uint256 y1,
        address a
    ) internal pure returns (uint256) {
        uint256 c = uint256(sha256(abi.encode(x1, y1, a)));
        return c;
    }

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

    // linear combination of two pubkeys
    // Note: resulting point may have odd y coordinate(not compatible with BIP-340), however
    // if it is used for address derivation which requires only x coordinate, it is not a problem.
    // But if you use this pubkey for other purposes, you should check y coordinate and negate the point if necessary.
    function getCombinedPubkey(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        uint256 c1,
        uint256 c2
    ) internal pure returns (uint256, uint256) {
        (uint256 x1, uint256 y1) = mulPubkey(p1x, p1y, c1);
        (uint256 x2, uint256 y2) = mulPubkey(p2x, p2y, c2);

        (uint256 x3, uint256 y3) = addPubkeys(x1, y1, x2, y2);

        // TODO(mkl): fix this later because it breaks the tests
        // Negate sum if resulting y coordinate is odd
        // It is may be necessary if we use generated key is some feather calculations
        // If we only directly generate address from pubkey, it is not necessary
        // if(y3 % 2 == 1) {
        //     y3 = PP - y3;
        // }

        return (x3, y3);
    }

    // derive pubkey from Validators' pubkeys and user's Ethereum address
    function getPubkeyFromAddress(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        address addr
    ) internal pure returns (uint256, uint256) {
        uint256 c1 = getCoefficient(p1x, p1y, addr);
        uint256 c2 = getCoefficient(p2x, p2y, addr);
        return getCombinedPubkey(p1x, p1y, p2x, p2y, c1, c2);
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

    // derive Bitcoin address from user's Ethereum address and validators' pubkeys
    // It generate taproot address with taproot commitment and no script path(preferred way according to BIP-341)
    // Better to use this function instead of getBtcAddressFromEth
    function getBtcAddressTaprootNoScriptFromEth(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        bytes memory hrp,
        address ethAddr
    ) internal pure returns (string memory) {
        (uint256 x, uint256 y) = getPubkeyFromAddress(
            p1x,
            p1y,
            p2x,
            p2y,
            ethAddr
        );

        // TODO: maybe fix this in getPubkeyFromAddress
        // Because we use pubkey for further calculations we should make it BIP-340 compatible
        if (y % 2 == 1) {
            y = PP - y;
        }

        (uint256 xTweaked,) = computeTaprootKeyNoScript(x, y);

        return getBtcTaprootAddrFromPubkey(xTweaked, hrp);
    }
}
