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
}
