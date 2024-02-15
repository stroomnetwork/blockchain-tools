// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../lib/elliptic-curve-solidity/contracts/EllipticCurve.sol";


contract Deriver {
    uint256 public constant GX =
        0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798;
    uint256 public constant GY =
        0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8;
    uint256 public constant AA = 0;
    uint256 public constant BB = 7;
    uint256 public constant PP =
        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;

    uint256 public constant P1X =  0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A;
    uint256 public constant P1Y =  0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0;

    uint256 public constant P2X = 0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC;
    uint256 public constant P2Y = 0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C;

    uint256 public constant C1 = 0xAF0AAFE2C1B97A6F64A78BD31CC1ABECC70623D61EB8D92231E0906AD5D2F739;
    uint256 public constant C2 = 0x71A862373EF0DBB8489B1CE31E0D6F931A5C5AFA2D63FEA663FFAB45D7D467AA;

    uint256 public constant P3X = 0x786BA0CC9B0DA200D11CC085D41BBD5F1471DF8DF216CD775B924F4CAC80F341;
    uint256 public constant P3Y = 0xD351E3FE211B48C6A8C8421F25767ED5D29F7E66944EB5DCD98F47DAF769F897;
    
    /// @notice Public Key derivation from private key
    /// Warning: this is just an example. Do not expose your private key.
    /// @param privKey The private key
    /// @return (qx, qy) The Public Key
    function getPubKey(
        uint256 privKey
    ) external pure returns (uint256, uint256) {
        return EllipticCurve.ecMul(privKey, GX, GY, AA, PP);
    }

   function addPubkeys(uint256 x1, uint256 y1, uint256 x2, uint256 y2) public pure returns (uint256, uint256){
        return EllipticCurve.ecAdd(x1, y1, x2, y2, AA, PP);
   }

   function mulPubkey(uint256 x, uint256 y, uint256 scalar) public pure returns (uint256, uint256){
        return EllipticCurve.ecMul(scalar, x, y, AA, PP);
   }

   function getCombinedPubkey(uint256 c1, uint256 c2) public pure returns (uint256, uint256) {
    (uint256 x1, uint256 y1) = mulPubkey(P1X, P1Y, c1);
    (uint256 x2, uint256 y2) = mulPubkey(P2X, P2Y, c2);
        return addPubkeys(x1, y1, x2, y2);
   }

}

