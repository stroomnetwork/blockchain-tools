// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

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
        return addPubkeys(x1, y1, x2, y2);
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

    // derive Bitcoin address from user's Ethereum address and validators' pubkeys
    function getBtcAddressFromEth(
        uint256 p1x,
        uint256 p1y,
        uint256 p2x,
        uint256 p2y,
        bytes memory hrp,
        address ethAddr
    ) internal pure returns (string memory) {
        (uint256 x, uint256 _y) = getPubkeyFromAddress(
            p1x,
            p1y,
            p2x,
            p2y,
            ethAddr
        );
        return string(Bech32m.encodeSegwitAddress(hrp, 1, abi.encodePacked(x)));
    }

    // calculate y coordinate from x coordinate
    function liftX(uint256 x) internal pure returns (uint256) {
        return EllipticCurve.deriveY(0x02, x, AA, BB, PP);
    }
}
