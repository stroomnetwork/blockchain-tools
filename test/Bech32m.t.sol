// Solidity Version: ^0.8.13
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bech32m} from "../src/Bech32m.sol";

// Tests from https://github.com/sipa/bech32/blob/master/ref/python/tests.py
// https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
contract Bech32Test is Test {
    function testCharset() public {
        assertEq(Bech32m.CHARSET, "qpzry9x8gf2tvdw0s3jn54khce6mua7l");
    }

    function testBech32mConstant() public {
        assertEq(Bech32m.BECH32M_CONST, 0x2bc830a3);
    }

    function testPolymod() public {
        // This test was generated automatically by gen_ref_data_bech32_polymod

        // bech32_polymod([0]) == 32
        uint[] memory values0 = new uint[](1);
        values0[0] = 0;
        uint256 polymodExpected0 = 32;
        uint256 polymodActual0 = Bech32m.polymod(values0);
        assertEq(polymodExpected0, polymodActual0);

        // bech32_polymod([1]) == 33
        uint[] memory values1 = new uint[](1);
        values1[0] = 1;
        uint256 polymodExpected1 = 33;
        uint256 polymodActual1 = Bech32m.polymod(values1);
        assertEq(polymodExpected1, polymodActual1);

        // bech32_polymod([0, 1]) == 1025
        uint[] memory values2 = new uint[](2);
        values2[0] = 0;
        values2[1] = 1;
        uint256 polymodExpected2 = 1025;
        uint256 polymodActual2 = Bech32m.polymod(values2);
        assertEq(polymodExpected2, polymodActual2);

        // bech32_polymod([2, 3, 4]) == 34916
        uint[] memory values3 = new uint[](3);
        values3[0] = 2;
        values3[1] = 3;
        values3[2] = 4;
        uint256 polymodExpected3 = 34916;
        uint256 polymodActual3 = Bech32m.polymod(values3);
        assertEq(polymodExpected3, polymodActual3);

        // bech32_polymod([5, 6, 7, 8]) == 1218792
        uint[] memory values4 = new uint[](4);
        values4[0] = 5;
        values4[1] = 6;
        values4[2] = 7;
        values4[3] = 8;
        uint256 polymodExpected4 = 1218792;
        uint256 polymodActual4 = Bech32m.polymod(values4);
        assertEq(polymodExpected4, polymodActual4);

        // bech32_polymod([9, 10, 11, 12, 13]) == 43330957
        uint[] memory values5 = new uint[](5);
        values5[0] = 9;
        values5[1] = 10;
        values5[2] = 11;
        values5[3] = 12;
        values5[4] = 13;
        uint256 polymodExpected5 = 43330957;
        uint256 polymodActual5 = Bech32m.polymod(values5);
        assertEq(polymodExpected5, polymodActual5);

        // bech32_polymod([14, 15, 16, 17, 18, 19]) == 663884257
        uint[] memory values6 = new uint[](6);
        values6[0] = 14;
        values6[1] = 15;
        values6[2] = 16;
        values6[3] = 17;
        values6[4] = 18;
        values6[5] = 19;
        uint256 polymodExpected6 = 663884257;
        uint256 polymodActual6 = Bech32m.polymod(values6);
        assertEq(polymodExpected6, polymodActual6);
    }

    function testHrpExpand() public {
        // This test was generated automatically by gen_ref_data_bech32_hrp_expand

        // bech32_hrp_expand("""a""") == [3, 0, 1]
        bytes memory hrp0 = hex"61";
        bytes memory hrpExpandExpected0 = hex"030001";
        bytes memory hrpExpandActual0 = Bech32m.hrpExpand(hrp0);
        assertEq(hrpExpandExpected0, hrpExpandActual0);

        // bech32_hrp_expand("""tb""") == [3, 3, 0, 20, 2]
        bytes memory hrp1 = hex"7462";
        bytes memory hrpExpandExpected1 = hex"0303001402";
        bytes memory hrpExpandActual1 = Bech32m.hrpExpand(hrp1);
        assertEq(hrpExpandExpected1, hrpExpandActual1);

        // bech32_hrp_expand("""!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~""") == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
        bytes
            memory hrp2 = hex"2122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e";
        bytes
            memory hrpExpandExpected2 = hex"01010101010101010101010101010101010101010101010101010101010101020202020202020202020202020202020202020202020202020202020202020203030303030303030303030303030303030303030303030303030303030303000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e";
        bytes memory hrpExpandActual2 = Bech32m.hrpExpand(hrp2);
        assertEq(hrpExpandExpected2, hrpExpandActual2);
    }
}
