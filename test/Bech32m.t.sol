// Solidity Version: ^0.8.13
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bech32m} from "../src/Bech32m.sol";

// Tests from https://github.com/sipa/bech32/blob/master/ref/python/tests.py
// https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
contract Bech32Test is Test {
    function bytesToUintArr(
        bytes memory b
    ) internal pure returns (uint[] memory) {
        uint[] memory result = new uint[](b.length);
        for (uint i = 0; i < b.length; i += 1) {
            result[i] = uint(uint8(b[i]));
        }
        return result;
    }

    function testCharset() public {
        assertEq(Bech32m.CHARSET, "qpzry9x8gf2tvdw0s3jn54khce6mua7l");
    }

    function testBech32mConstant() public {
        assertEq(Bech32m.BECH32M_CONST, 0x2bc830a3);
    }

    function testPolymod() public {
        // This test was generated automatically by gen_ref_data_bech32_polymod.py

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
        // This test was generated automatically by gen_ref_data_bech32_hrp_expand.py

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

    function testCreateChecksum() public {
        // This test was generated automatically by gen_ref_data_bech32_create_checksum.py

        // bech32_create_checksum("""tb""", [], Encoding.BECH32) == [24, 4, 15, 0, 30, 1]
        bytes memory hrp0 = hex"7462";
        bytes memory data0 = hex"";
        Bech32m.BechEncoding spec0 = Bech32m.BechEncoding.BECH32;
        bytes memory chkExpected0 = hex"18040f001e01";
        bytes memory chkActual0 = Bech32m.createChecksum(hrp0, data0, spec0);
        assertEq(chkExpected0, chkActual0);

        // bech32_create_checksum("""bt""", [115, 111, 109, 101, 32, 100, 97, 116, 97], Encoding.BECH32M) == [13, 9, 17, 27, 29, 26]
        bytes memory hrp1 = hex"6274";
        bytes memory data1 = hex"736f6d652064617461";
        Bech32m.BechEncoding spec1 = Bech32m.BechEncoding.BECH32M;
        bytes memory chkExpected1 = hex"0d09111b1d1a";
        bytes memory chkActual1 = Bech32m.createChecksum(hrp1, data1, spec1);
        assertEq(chkExpected1, chkActual1);

        // bech32_create_checksum("""btcdd""", [0, 100, 115, 10, 9, 0], Encoding.BECH32M) == [5, 13, 30, 5, 31, 0]
        bytes memory hrp2 = hex"6274636464";
        bytes memory data2 = hex"0064730a0900";
        Bech32m.BechEncoding spec2 = Bech32m.BechEncoding.BECH32M;
        bytes memory chkExpected2 = hex"050d1e051f00";
        bytes memory chkActual2 = Bech32m.createChecksum(hrp2, data2, spec2);
        assertEq(chkExpected2, chkActual2);
    }

    function testBech32Encode() public {
        // This test was generated automatically by gen_ref_data_bech32_encode.py

        // bech32_encode("""tb""", [], Encoding.BECH32) == """tb1cy0q7p"""
        bytes memory hrp0 = hex"7462";
        bytes memory data0 = hex"";
        Bech32m.BechEncoding spec0 = Bech32m.BechEncoding.BECH32;
        bytes memory encodedExpected0 = hex"746231637930713770";
        bytes memory encodedActual0 = Bech32m.bech32Encode(hrp0, data0, spec0);
        assertEq(encodedExpected0, encodedActual0);

        // bech32_encode("""bt""", [1, 2, 3, 4, 5], Encoding.BECH32M) == """bt1pzry9l8q0k3"""
        bytes memory hrp1 = hex"6274";
        bytes memory data1 = hex"0102030405";
        Bech32m.BechEncoding spec1 = Bech32m.BechEncoding.BECH32M;
        bytes memory encodedExpected1 = hex"627431707a7279396c3871306b33";
        bytes memory encodedActual1 = Bech32m.bech32Encode(hrp1, data1, spec1);
        assertEq(encodedExpected1, encodedActual1);

        // bech32_encode("""abcd""", [0, 1, 30, 31], Encoding.BECH32M) == """abcd1qp7l3anr3m"""
        bytes memory hrp2 = hex"61626364";
        bytes memory data2 = hex"00011e1f";
        Bech32m.BechEncoding spec2 = Bech32m.BechEncoding.BECH32M;
        bytes memory encodedExpected2 = hex"61626364317170376c33616e72336d";
        bytes memory encodedActual2 = Bech32m.bech32Encode(hrp2, data2, spec2);
        assertEq(encodedExpected2, encodedActual2);

        // bech32_encode(""""12""", [12, 31, 0], Encoding.BECH32) == """"121vlqllgkxv"""
        bytes memory hrp3 = hex"223132";
        bytes memory data3 = hex"0c1f00";
        Bech32m.BechEncoding spec3 = Bech32m.BechEncoding.BECH32;
        bytes memory encodedExpected3 = hex"22313231766c716c6c676b7876";
        bytes memory encodedActual3 = Bech32m.bech32Encode(hrp3, data3, spec3);
        assertEq(encodedExpected3, encodedActual3);
    }

    function testConvert8To5() public {
        // This test was generated automatically by gen_ref_data_convertbits_8_to_5.py

        // convertbits(b'', 8, 5) == []
        bytes memory dataIn0 = hex"";
        bytes memory dataOutExpected0 = hex"";
        bytes memory dataOutActual0 = Bech32m.conver8To5(dataIn0);
        assertEq(dataOutExpected0, dataOutActual0);

        // convertbits(b'Q', 8, 5) == [10, 4]
        bytes memory dataIn1 = hex"51";
        bytes memory dataOutExpected1 = hex"0a04";
        bytes memory dataOutActual1 = Bech32m.conver8To5(dataIn1);
        assertEq(dataOutExpected1, dataOutActual1);

        // convertbits(b'Q(', 8, 5) == [10, 4, 20, 0]
        bytes memory dataIn2 = hex"5128";
        bytes memory dataOutExpected2 = hex"0a041400";
        bytes memory dataOutActual2 = Bech32m.conver8To5(dataIn2);
        assertEq(dataOutExpected2, dataOutActual2);

        // convertbits(b'Q(u', 8, 5) == [10, 4, 20, 7, 10]
        bytes memory dataIn3 = hex"512875";
        bytes memory dataOutExpected3 = hex"0a0414070a";
        bytes memory dataOutActual3 = Bech32m.conver8To5(dataIn3);
        assertEq(dataOutExpected3, dataOutActual3);

        // convertbits(b'Q(u\x1e', 8, 5) == [10, 4, 20, 7, 10, 7, 16]
        bytes memory dataIn4 = hex"5128751e";
        bytes memory dataOutExpected4 = hex"0a0414070a0710";
        bytes memory dataOutActual4 = Bech32m.conver8To5(dataIn4);
        assertEq(dataOutExpected4, dataOutActual4);

        // convertbits(b'Q(u\x1ev', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22]
        bytes memory dataIn5 = hex"5128751e76";
        bytes memory dataOutExpected5 = hex"0a0414070a071316";
        bytes memory dataOutActual5 = Bech32m.conver8To5(dataIn5);
        assertEq(dataOutExpected5, dataOutActual5);

        // convertbits(b'Q(u\x1ev\xe8', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0]
        bytes memory dataIn6 = hex"5128751e76e8";
        bytes memory dataOutExpected6 = hex"0a0414070a0713161d00";
        bytes memory dataOutActual6 = Bech32m.conver8To5(dataIn6);
        assertEq(dataOutExpected6, dataOutActual6);

        // convertbits(b'Q(u\x1ev\xe8\x19', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 16]
        bytes memory dataIn7 = hex"5128751e76e819";
        bytes memory dataOutExpected7 = hex"0a0414070a0713161d000c10";
        bytes memory dataOutActual7 = Bech32m.conver8To5(dataIn7);
        assertEq(dataOutExpected7, dataOutActual7);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 2]
        bytes memory dataIn8 = hex"5128751e76e81991";
        bytes memory dataOutExpected8 = hex"0a0414070a0713161d000c1902";
        bytes memory dataOutActual8 = Bech32m.conver8To5(dataIn8);
        assertEq(dataOutExpected8, dataOutActual8);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 16]
        bytes memory dataIn9 = hex"5128751e76e8199196";
        bytes memory dataOutExpected9 = hex"0a0414070a0713161d000c19030510";
        bytes memory dataOutActual9 = Bech32m.conver8To5(dataIn9);
        assertEq(dataOutExpected9, dataOutActual9);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96\xd4', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 22, 20]
        bytes memory dataIn10 = hex"5128751e76e8199196d4";
        bytes memory dataOutExpected10 = hex"0a0414070a0713161d000c1903051614";
        bytes memory dataOutActual10 = Bech32m.conver8To5(dataIn10);
        assertEq(dataOutExpected10, dataOutActual10);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96\xd4T', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 22, 20, 10, 16]
        bytes memory dataIn11 = hex"5128751e76e8199196d454";
        bytes
            memory dataOutExpected11 = hex"0a0414070a0713161d000c19030516140a10";
        bytes memory dataOutActual11 = Bech32m.conver8To5(dataIn11);
        assertEq(dataOutExpected11, dataOutActual11);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96\xd4T\x94', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 22, 20, 10, 18, 10, 0]
        bytes memory dataIn12 = hex"5128751e76e8199196d45494";
        bytes
            memory dataOutExpected12 = hex"0a0414070a0713161d000c19030516140a120a00";
        bytes memory dataOutActual12 = Bech32m.conver8To5(dataIn12);
        assertEq(dataOutExpected12, dataOutActual12);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96\xd4T\x94\x1c', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 22, 20, 10, 18, 10, 1, 24]
        bytes memory dataIn13 = hex"5128751e76e8199196d454941c";
        bytes
            memory dataOutExpected13 = hex"0a0414070a0713161d000c19030516140a120a0118";
        bytes memory dataOutActual13 = Bech32m.conver8To5(dataIn13);
        assertEq(dataOutExpected13, dataOutActual13);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96\xd4T\x94\x1cE', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 22, 20, 10, 18, 10, 1, 24, 17, 8]
        bytes memory dataIn14 = hex"5128751e76e8199196d454941c45";
        bytes
            memory dataOutExpected14 = hex"0a0414070a0713161d000c19030516140a120a01181108";
        bytes memory dataOutActual14 = Bech32m.conver8To5(dataIn14);
        assertEq(dataOutExpected14, dataOutActual14);

        // convertbits(b'Q(u\x1ev\xe8\x19\x91\x96\xd4T\x94\x1cE\xd1', 8, 5) == [10, 4, 20, 7, 10, 7, 19, 22, 29, 0, 12, 25, 3, 5, 22, 20, 10, 18, 10, 1, 24, 17, 14, 17]
        bytes memory dataIn15 = hex"5128751e76e8199196d454941c45d1";
        bytes
            memory dataOutExpected15 = hex"0a0414070a0713161d000c19030516140a120a0118110e11";
        bytes memory dataOutActual15 = Bech32m.conver8To5(dataIn15);
        assertEq(dataOutExpected15, dataOutActual15);
    }
}
