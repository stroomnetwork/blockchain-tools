// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

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

    // https://ethereum.stackexchange.com/questions/884/how-to-convert-an-address-to-bytes-in-solidity
    function toBytes(address a) public pure returns (bytes memory) {
        return abi.encodePacked(a);
    }

    // TODO(mkl): use tagged hashes
    function getCoefficient(
        uint256 x1,
        uint256 y1,
        address a
    ) public pure returns (uint256) {
        uint256 c = uint256(sha256(abi.encode(x1, y1, a)));
        return c;
    }

    function addPubkeys(
        uint256 x1,
        uint256 y1,
        uint256 x2,
        uint256 y2
    ) public pure returns (uint256, uint256) {
        return EllipticCurve.ecAdd(x1, y1, x2, y2, AA, PP);
    }

    function mulPubkey(
        uint256 x,
        uint256 y,
        uint256 scalar
    ) public pure returns (uint256, uint256) {
        return EllipticCurve.ecMul(scalar, x, y, AA, PP);
    }

    function getCombinedPubkey(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        uint256 c1,
        uint256 c2
    ) public pure returns (uint256, uint256) {
        (uint256 x1, uint256 y1) = mulPubkey(p1x, p1y, c1);
        (uint256 x2, uint256 y2) = mulPubkey(p2x, p2y, c2);
        return addPubkeys(x1, y1, x2, y2);
    }

    function getPubkeyFromAddress(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        address addr
    ) public pure returns (uint256, uint256) {
        uint256 c1 = getCoefficient(p1x, p1y, addr);
        uint256 c2 = getCoefficient(p2x, p2y, addr);
        return getCombinedPubkey(p1x, p1y, p2x, p2y, c1, c2);
    }

    function getBtcAddressFromEth(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        bytes memory hrp,
        address ethAddr
    ) public pure returns (string memory) {
        (uint256 x, uint256 y) = getPubkeyFromAddress(
            p1x,
            p1y,
            p2x,
            p2y,
            ethAddr
        );
        return string(Bech32m.encodeSegwitAddress(hrp, 1, abi.encodePacked(x)));
    }

    function liftX(uint256 x) public pure returns (uint256) {
        uint256 y = EllipticCurve.deriveY(0x02, x, AA, BB, PP);
        return y;
    }
}
