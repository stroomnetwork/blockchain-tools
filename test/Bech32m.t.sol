// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

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

    function testCharset() public pure{
        assertEq(Bech32m.CHARSET, "qpzry9x8gf2tvdw0s3jn54khce6mua7l");
    }

    function testBech32mConstant() public pure {
        assertEq(Bech32m.BECH32M_CONST, 0x2bc830a3);
    }

    function testPolymod() public pure {
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

    function testHrpExpand() public pure {
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

    function testCreateChecksum() public pure {
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

    function testBech32Encode() public pure {
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

    function testConvert8To5() public pure {
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

    function testEncodeSegwitAddress() public pure {
        // This test was generated automatically by gen_ref_data_encode.py

        // encode("bt", 0, b'01010101010101010101') == "bt1qxqcnqvfsxycrzvp3xqcnqvfsxycrzvp3ytzryq"
        bytes memory hrp0 = hex"6274";
        uint8 witver0 = 0;
        bytes memory witprog0 = hex"3031303130313031303130313031303130313031";
        bytes
            memory expectedAddr0 = hex"627431717871636e71766673787963727a7670337871636e71766673787963727a76703379747a727971";
        bytes memory actualAddr0 = Bech32m.encodeSegwitAddress(
            hrp0,
            witver0,
            witprog0
        );
        assertEq(expectedAddr0, actualAddr0);

        // encode("tb", 0, b'02020202020202020202020202020202') == "tb1qxqerqv3sxgcryvpjxqerqv3sxgcryvpjxqerqv3sxgcryvpjxqeqesyjw8"
        bytes memory hrp1 = hex"7462";
        uint8 witver1 = 0;
        bytes
            memory witprog1 = hex"3032303230323032303230323032303230323032303230323032303230323032";
        bytes
            memory expectedAddr1 = hex"746231717871657271763373786763727976706a7871657271763373786763727976706a7871657271763373786763727976706a787165716573796a7738";
        bytes memory actualAddr1 = Bech32m.encodeSegwitAddress(
            hrp1,
            witver1,
            witprog1
        );
        assertEq(expectedAddr1, actualAddr1);

        // encode("bt", 1, b'03030303030303030303030303030303') == "bt1pxqenqvesxvcrxvpnxqenqvesxvcrxvpnxqenqvesxvcrxvpnxqessp3jae"
        bytes memory hrp2 = hex"6274";
        uint8 witver2 = 1;
        bytes
            memory witprog2 = hex"3033303330333033303330333033303330333033303330333033303330333033";
        bytes
            memory expectedAddr2 = hex"627431707871656e71766573787663727876706e7871656e71766573787663727876706e7871656e71766573787663727876706e787165737370336a6165";
        bytes memory actualAddr2 = Bech32m.encodeSegwitAddress(
            hrp2,
            witver2,
            witprog2
        );
        assertEq(expectedAddr2, actualAddr2);

        // encode("tb", 1, b'04040404040404040404040404040404') == "tb1pxq6rqdpsxscrgvp5xq6rqdpsxscrgvp5xq6rqdpsxscrgvp5xq6qw2ty9q"
        bytes memory hrp3 = hex"7462";
        uint8 witver3 = 1;
        bytes
            memory witprog3 = hex"3034303430343034303430343034303430343034303430343034303430343034";
        bytes
            memory expectedAddr3 = hex"7462317078713672716470737873637267767035787136727164707378736372677670357871367271647073787363726776703578713671773274793971";
        bytes memory actualAddr3 = Bech32m.encodeSegwitAddress(
            hrp3,
            witver3,
            witprog3
        );
        assertEq(expectedAddr3, actualAddr3);
    }

    function testConvert5To8() public pure {
        // This test was generated automatically by gen_ref_data_convertbits_5_to_8.py

        // convertbits([], 5, 8, False) == []
        bytes memory data5Bit0 = hex"";
        bytes memory data8BitExpected0 = hex"";
        (bytes memory data8BitActual0, Bech32m.DecodeError err0) = Bech32m
            .convert5to8(data5Bit0);
        assertEq(data8BitExpected0, data8BitActual0);
        assertTrue(err0 == Bech32m.DecodeError.NoError);

        // convertbits([30], 5, 8, False) == None
        bytes memory data5Bit1 = hex"1e";
        bytes memory data8BitExpected1 = hex"";
        (bytes memory data8BitActual1, Bech32m.DecodeError err1) = Bech32m
            .convert5to8(data5Bit1);
        assertEq(data8BitExpected1, data8BitActual1);
        assertTrue(err1 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4], 5, 8, False) == [241]
        bytes memory data5Bit2 = hex"1e04";
        bytes memory data8BitExpected2 = hex"f1";
        (bytes memory data8BitActual2, Bech32m.DecodeError err2) = Bech32m
            .convert5to8(data5Bit2);
        assertEq(data8BitExpected2, data8BitActual2);
        assertTrue(err2 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3], 5, 8, False) == None
        bytes memory data5Bit3 = hex"1e0403";
        bytes memory data8BitExpected3 = hex"";
        (bytes memory data8BitActual3, Bech32m.DecodeError err3) = Bech32m
            .convert5to8(data5Bit3);
        assertEq(data8BitExpected3, data8BitActual3);
        assertTrue(err3 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26], 5, 8, False) == None
        bytes memory data5Bit4 = hex"1e04031a";
        bytes memory data8BitExpected4 = hex"";
        (bytes memory data8BitActual4, Bech32m.DecodeError err4) = Bech32m
            .convert5to8(data5Bit4);
        assertEq(data8BitExpected4, data8BitActual4);
        assertTrue(err4 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21], 5, 8, False) == None
        bytes memory data5Bit5 = hex"1e04031a15";
        bytes memory data8BitExpected5 = hex"";
        (bytes memory data8BitActual5, Bech32m.DecodeError err5) = Bech32m
            .convert5to8(data5Bit5);
        assertEq(data8BitExpected5, data8BitActual5);
        assertTrue(err5 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17], 5, 8, False) == None
        bytes memory data5Bit6 = hex"1e04031a1511";
        bytes memory data8BitExpected6 = hex"";
        (bytes memory data8BitActual6, Bech32m.DecodeError err6) = Bech32m
            .convert5to8(data5Bit6);
        assertEq(data8BitExpected6, data8BitActual6);
        assertTrue(err6 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12], 5, 8, False) == None
        bytes memory data5Bit7 = hex"1e04031a15110c";
        bytes memory data8BitExpected7 = hex"";
        (bytes memory data8BitActual7, Bech32m.DecodeError err7) = Bech32m
            .convert5to8(data5Bit7);
        assertEq(data8BitExpected7, data8BitActual7);
        assertTrue(err7 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29], 5, 8, False) == [241, 7, 170, 197, 157]
        bytes memory data5Bit8 = hex"1e04031a15110c1d";
        bytes memory data8BitExpected8 = hex"f107aac59d";
        (bytes memory data8BitActual8, Bech32m.DecodeError err8) = Bech32m
            .convert5to8(data5Bit8);
        assertEq(data8BitExpected8, data8BitActual8);
        assertTrue(err8 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31], 5, 8, False) == None
        bytes memory data5Bit9 = hex"1e04031a15110c1d1f";
        bytes memory data8BitExpected9 = hex"";
        (bytes memory data8BitActual9, Bech32m.DecodeError err9) = Bech32m
            .convert5to8(data5Bit9);
        assertEq(data8BitExpected9, data8BitActual9);
        assertTrue(err9 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28], 5, 8, False) == [241, 7, 170, 197, 157, 255]
        bytes memory data5Bit10 = hex"1e04031a15110c1d1f1c";
        bytes memory data8BitExpected10 = hex"f107aac59dff";
        (bytes memory data8BitActual10, Bech32m.DecodeError err10) = Bech32m
            .convert5to8(data5Bit10);
        assertEq(data8BitExpected10, data8BitActual10);
        assertTrue(err10 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14], 5, 8, False) == None
        bytes memory data5Bit11 = hex"1e04031a15110c1d1f1c0e";
        bytes memory data8BitExpected11 = hex"";
        (bytes memory data8BitActual11, Bech32m.DecodeError err11) = Bech32m
            .convert5to8(data5Bit11);
        assertEq(data8BitExpected11, data8BitActual11);
        assertTrue(err11 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20], 5, 8, False) == None
        bytes memory data5Bit12 = hex"1e04031a15110c1d1f1c0e14";
        bytes memory data8BitExpected12 = hex"";
        (bytes memory data8BitActual12, Bech32m.DecodeError err12) = Bech32m
            .convert5to8(data5Bit12);
        assertEq(data8BitExpected12, data8BitActual12);
        assertTrue(err12 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19], 5, 8, False) == None
        bytes memory data5Bit13 = hex"1e04031a15110c1d1f1c0e1413";
        bytes memory data8BitExpected13 = hex"";
        (bytes memory data8BitActual13, Bech32m.DecodeError err13) = Bech32m
            .convert5to8(data5Bit13);
        assertEq(data8BitExpected13, data8BitActual13);
        assertTrue(err13 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26], 5, 8, False) == None
        bytes memory data5Bit14 = hex"1e04031a15110c1d1f1c0e14131a";
        bytes memory data8BitExpected14 = hex"";
        (bytes memory data8BitActual14, Bech32m.DecodeError err14) = Bech32m
            .convert5to8(data5Bit14);
        assertEq(data8BitExpected14, data8BitActual14);
        assertTrue(err14 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31], 5, 8, False) == None
        bytes memory data5Bit15 = hex"1e04031a15110c1d1f1c0e14131a1f";
        bytes memory data8BitExpected15 = hex"";
        (bytes memory data8BitActual15, Bech32m.DecodeError err15) = Bech32m
            .convert5to8(data5Bit15);
        assertEq(data8BitExpected15, data8BitActual15);
        assertTrue(err15 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254]
        bytes memory data5Bit16 = hex"1e04031a15110c1d1f1c0e14131a1f1e";
        bytes memory data8BitExpected16 = hex"f107aac59dff1d49ebfe";
        (bytes memory data8BitActual16, Bech32m.DecodeError err16) = Bech32m
            .convert5to8(data5Bit16);
        assertEq(data8BitExpected16, data8BitActual16);
        assertTrue(err16 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27], 5, 8, False) == None
        bytes memory data5Bit17 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b";
        bytes memory data8BitExpected17 = hex"";
        (bytes memory data8BitActual17, Bech32m.DecodeError err17) = Bech32m
            .convert5to8(data5Bit17);
        assertEq(data8BitExpected17, data8BitActual17);
        assertTrue(err17 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13], 5, 8, False) == None
        bytes memory data5Bit18 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d";
        bytes memory data8BitExpected18 = hex"";
        (bytes memory data8BitActual18, Bech32m.DecodeError err18) = Bech32m
            .convert5to8(data5Bit18);
        assertEq(data8BitExpected18, data8BitActual18);
        assertTrue(err18 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31], 5, 8, False) == None
        bytes memory data5Bit19 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f";
        bytes memory data8BitExpected19 = hex"";
        (bytes memory data8BitActual19, Bech32m.DecodeError err19) = Bech32m
            .convert5to8(data5Bit19);
        assertEq(data8BitExpected19, data8BitActual19);
        assertTrue(err19 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127]
        bytes memory data5Bit20 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f10";
        bytes memory data8BitExpected20 = hex"f107aac59dff1d49ebfedb7f";
        (bytes memory data8BitActual20, Bech32m.DecodeError err20) = Bech32m
            .convert5to8(data5Bit20);
        assertEq(data8BitExpected20, data8BitActual20);
        assertTrue(err20 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7], 5, 8, False) == None
        bytes
            memory data5Bit21 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007";
        bytes memory data8BitExpected21 = hex"";
        (bytes memory data8BitActual21, Bech32m.DecodeError err21) = Bech32m
            .convert5to8(data5Bit21);
        assertEq(data8BitExpected21, data8BitActual21);
        assertTrue(err21 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1], 5, 8, False) == None
        bytes
            memory data5Bit22 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f100701";
        bytes memory data8BitExpected22 = hex"";
        (bytes memory data8BitActual22, Bech32m.DecodeError err22) = Bech32m
            .convert5to8(data5Bit22);
        assertEq(data8BitExpected22, data8BitActual22);
        assertTrue(err22 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27], 5, 8, False) == None
        bytes
            memory data5Bit23 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b";
        bytes memory data8BitExpected23 = hex"";
        (bytes memory data8BitActual23, Bech32m.DecodeError err23) = Bech32m
            .convert5to8(data5Bit23);
        assertEq(data8BitExpected23, data8BitActual23);
        assertTrue(err23 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126]
        bytes
            memory data5Bit24 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e";
        bytes memory data8BitExpected24 = hex"f107aac59dff1d49ebfedb7f03877e";
        (bytes memory data8BitActual24, Bech32m.DecodeError err24) = Bech32m
            .convert5to8(data5Bit24);
        assertEq(data8BitExpected24, data8BitActual24);
        assertTrue(err24 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21], 5, 8, False) == None
        bytes
            memory data5Bit25 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e15";
        bytes memory data8BitExpected25 = hex"";
        (bytes memory data8BitActual25, Bech32m.DecodeError err25) = Bech32m
            .convert5to8(data5Bit25);
        assertEq(data8BitExpected25, data8BitActual25);
        assertTrue(err25 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170]
        bytes
            memory data5Bit26 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e1508";
        bytes memory data8BitExpected26 = hex"f107aac59dff1d49ebfedb7f03877eaa";
        (bytes memory data8BitActual26, Bech32m.DecodeError err26) = Bech32m
            .convert5to8(data5Bit26);
        assertEq(data8BitExpected26, data8BitActual26);
        assertTrue(err26 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1], 5, 8, False) == None
        bytes
            memory data5Bit27 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801";
        bytes memory data8BitExpected27 = hex"";
        (bytes memory data8BitActual27, Bech32m.DecodeError err27) = Bech32m
            .convert5to8(data5Bit27);
        assertEq(data8BitExpected27, data8BitActual27);
        assertTrue(err27 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9], 5, 8, False) == None
        bytes
            memory data5Bit28 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e15080109";
        bytes memory data8BitExpected28 = hex"";
        (bytes memory data8BitActual28, Bech32m.DecodeError err28) = Bech32m
            .convert5to8(data5Bit28);
        assertEq(data8BitExpected28, data8BitActual28);
        assertTrue(err28 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15], 5, 8, False) == None
        bytes
            memory data5Bit29 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f";
        bytes memory data8BitExpected29 = hex"";
        (bytes memory data8BitActual29, Bech32m.DecodeError err29) = Bech32m
            .convert5to8(data5Bit29);
        assertEq(data8BitExpected29, data8BitActual29);
        assertTrue(err29 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30], 5, 8, False) == None
        bytes
            memory data5Bit30 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e";
        bytes memory data8BitExpected30 = hex"";
        (bytes memory data8BitActual30, Bech32m.DecodeError err30) = Bech32m
            .convert5to8(data5Bit30);
        assertEq(data8BitExpected30, data8BitActual30);
        assertTrue(err30 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13], 5, 8, False) == None
        bytes
            memory data5Bit31 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d";
        bytes memory data8BitExpected31 = hex"";
        (bytes memory data8BitActual31, Bech32m.DecodeError err31) = Bech32m
            .convert5to8(data5Bit31);
        assertEq(data8BitExpected31, data8BitActual31);
        assertTrue(err31 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167]
        bytes
            memory data5Bit32 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d07";
        bytes
            memory data8BitExpected32 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7";
        (bytes memory data8BitActual32, Bech32m.DecodeError err32) = Bech32m
            .convert5to8(data5Bit32);
        assertEq(data8BitExpected32, data8BitActual32);
        assertTrue(err32 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26], 5, 8, False) == None
        bytes
            memory data5Bit33 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a";
        bytes memory data8BitExpected33 = hex"";
        (bytes memory data8BitActual33, Bech32m.DecodeError err33) = Bech32m
            .convert5to8(data5Bit33);
        assertEq(data8BitExpected33, data8BitActual33);
        assertTrue(err33 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15], 5, 8, False) == None
        bytes
            memory data5Bit34 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f";
        bytes memory data8BitExpected34 = hex"";
        (bytes memory data8BitActual34, Bech32m.DecodeError err34) = Bech32m
            .convert5to8(data5Bit34);
        assertEq(data8BitExpected34, data8BitActual34);
        assertTrue(err34 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7], 5, 8, False) == None
        bytes
            memory data5Bit35 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f07";
        bytes memory data8BitExpected35 = hex"";
        (bytes memory data8BitActual35, Bech32m.DecodeError err35) = Bech32m
            .convert5to8(data5Bit35);
        assertEq(data8BitExpected35, data8BitActual35);
        assertTrue(err35 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31], 5, 8, False) == None
        bytes
            memory data5Bit36 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f";
        bytes memory data8BitExpected36 = hex"";
        (bytes memory data8BitActual36, Bech32m.DecodeError err36) = Bech32m
            .convert5to8(data5Bit36);
        assertEq(data8BitExpected36, data8BitActual36);
        assertTrue(err36 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242]
        bytes
            memory data5Bit37 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f04";
        bytes
            memory data8BitExpected37 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff2";
        (bytes memory data8BitActual37, Bech32m.DecodeError err37) = Bech32m
            .convert5to8(data5Bit37);
        assertEq(data8BitExpected37, data8BitActual37);
        assertTrue(err37 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27], 5, 8, False) == None
        bytes
            memory data5Bit38 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b";
        bytes memory data8BitExpected38 = hex"";
        (bytes memory data8BitActual38, Bech32m.DecodeError err38) = Bech32m
            .convert5to8(data5Bit38);
        assertEq(data8BitExpected38, data8BitActual38);
        assertTrue(err38 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22], 5, 8, False) == None
        bytes
            memory data5Bit39 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b16";
        bytes memory data8BitExpected39 = hex"";
        (bytes memory data8BitActual39, Bech32m.DecodeError err39) = Bech32m
            .convert5to8(data5Bit39);
        assertEq(data8BitExpected39, data8BitActual39);
        assertTrue(err39 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223]
        bytes
            memory data5Bit40 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f";
        bytes
            memory data8BitExpected40 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edf";
        (bytes memory data8BitActual40, Bech32m.DecodeError err40) = Bech32m
            .convert5to8(data5Bit40);
        assertEq(data8BitExpected40, data8BitActual40);
        assertTrue(err40 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24], 5, 8, False) == None
        bytes
            memory data5Bit41 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f18";
        bytes memory data8BitExpected41 = hex"";
        (bytes memory data8BitActual41, Bech32m.DecodeError err41) = Bech32m
            .convert5to8(data5Bit41);
        assertEq(data8BitExpected41, data8BitActual41);
        assertTrue(err41 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29], 5, 8, False) == None
        bytes
            memory data5Bit42 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d";
        bytes memory data8BitExpected42 = hex"";
        (bytes memory data8BitActual42, Bech32m.DecodeError err42) = Bech32m
            .convert5to8(data5Bit42);
        assertEq(data8BitExpected42, data8BitActual42);
        assertTrue(err42 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10], 5, 8, False) == None
        bytes
            memory data5Bit43 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a";
        bytes memory data8BitExpected43 = hex"";
        (bytes memory data8BitActual43, Bech32m.DecodeError err43) = Bech32m
            .convert5to8(data5Bit43);
        assertEq(data8BitExpected43, data8BitActual43);
        assertTrue(err43 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84]
        bytes
            memory data5Bit44 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a00";
        bytes
            memory data8BitExpected44 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc754";
        (bytes memory data8BitActual44, Bech32m.DecodeError err44) = Bech32m
            .convert5to8(data5Bit44);
        assertEq(data8BitExpected44, data8BitActual44);
        assertTrue(err44 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13], 5, 8, False) == None
        bytes
            memory data5Bit45 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d";
        bytes memory data8BitExpected45 = hex"";
        (bytes memory data8BitActual45, Bech32m.DecodeError err45) = Bech32m
            .convert5to8(data5Bit45);
        assertEq(data8BitExpected45, data8BitActual45);
        assertTrue(err45 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28], 5, 8, False) == None
        bytes
            memory data5Bit46 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c";
        bytes memory data8BitExpected46 = hex"";
        (bytes memory data8BitActual46, Bech32m.DecodeError err46) = Bech32m
            .convert5to8(data5Bit46);
        assertEq(data8BitExpected46, data8BitActual46);
        assertTrue(err46 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17], 5, 8, False) == None
        bytes
            memory data5Bit47 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c11";
        bytes memory data8BitExpected47 = hex"";
        (bytes memory data8BitActual47, Bech32m.DecodeError err47) = Bech32m
            .convert5to8(data5Bit47);
        assertEq(data8BitExpected47, data8BitActual47);
        assertTrue(err47 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34]
        bytes
            memory data5Bit48 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c1102";
        bytes
            memory data8BitExpected48 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222";
        (bytes memory data8BitActual48, Bech32m.DecodeError err48) = Bech32m
            .convert5to8(data5Bit48);
        assertEq(data8BitExpected48, data8BitActual48);
        assertTrue(err48 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4], 5, 8, False) == None
        bytes
            memory data5Bit49 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204";
        bytes memory data8BitExpected49 = hex"";
        (bytes memory data8BitActual49, Bech32m.DecodeError err49) = Bech32m
            .convert5to8(data5Bit49);
        assertEq(data8BitExpected49, data8BitActual49);
        assertTrue(err49 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21], 5, 8, False) == None
        bytes
            memory data5Bit50 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c11020415";
        bytes memory data8BitExpected50 = hex"";
        (bytes memory data8BitActual50, Bech32m.DecodeError err50) = Bech32m
            .convert5to8(data5Bit50);
        assertEq(data8BitExpected50, data8BitActual50);
        assertTrue(err50 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22], 5, 8, False) == None
        bytes
            memory data5Bit51 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c1102041516";
        bytes memory data8BitExpected51 = hex"";
        (bytes memory data8BitActual51, Bech32m.DecodeError err51) = Bech32m
            .convert5to8(data5Bit51);
        assertEq(data8BitExpected51, data8BitActual51);
        assertTrue(err51 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19], 5, 8, False) == None
        bytes
            memory data5Bit52 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613";
        bytes memory data8BitExpected52 = hex"";
        (bytes memory data8BitActual52, Bech32m.DecodeError err52) = Bech32m
            .convert5to8(data5Bit52);
        assertEq(data8BitExpected52, data8BitActual52);
        assertTrue(err52 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60]
        bytes
            memory data5Bit53 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c11020415161318";
        bytes
            memory data8BitExpected53 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c";
        (bytes memory data8BitActual53, Bech32m.DecodeError err53) = Bech32m
            .convert5to8(data5Bit53);
        assertEq(data8BitExpected53, data8BitActual53);
        assertTrue(err53 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11], 5, 8, False) == None
        bytes
            memory data5Bit54 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b";
        bytes memory data8BitExpected54 = hex"";
        (bytes memory data8BitActual54, Bech32m.DecodeError err54) = Bech32m
            .convert5to8(data5Bit54);
        assertEq(data8BitExpected54, data8BitActual54);
        assertTrue(err54 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15], 5, 8, False) == None
        bytes
            memory data5Bit55 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f";
        bytes memory data8BitExpected55 = hex"";
        (bytes memory data8BitActual55, Bech32m.DecodeError err55) = Bech32m
            .convert5to8(data5Bit55);
        assertEq(data8BitExpected55, data8BitActual55);
        assertTrue(err55 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252]
        bytes
            memory data5Bit56 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c";
        bytes
            memory data8BitExpected56 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc";
        (bytes memory data8BitActual56, Bech32m.DecodeError err56) = Bech32m
            .convert5to8(data5Bit56);
        assertEq(data8BitExpected56, data8BitActual56);
        assertTrue(err56 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5], 5, 8, False) == None
        bytes
            memory data5Bit57 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c05";
        bytes memory data8BitExpected57 = hex"";
        (bytes memory data8BitActual57, Bech32m.DecodeError err57) = Bech32m
            .convert5to8(data5Bit57);
        assertEq(data8BitExpected57, data8BitActual57);
        assertTrue(err57 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23], 5, 8, False) == None
        bytes
            memory data5Bit58 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c0517";
        bytes memory data8BitExpected58 = hex"";
        (bytes memory data8BitActual58, Bech32m.DecodeError err58) = Bech32m
            .convert5to8(data5Bit58);
        assertEq(data8BitExpected58, data8BitActual58);
        assertTrue(err58 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0], 5, 8, False) == None
        bytes
            memory data5Bit59 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700";
        bytes memory data8BitExpected59 = hex"";
        (bytes memory data8BitActual59, Bech32m.DecodeError err59) = Bech32m
            .convert5to8(data5Bit59);
        assertEq(data8BitExpected59, data8BitActual59);
        assertTrue(err59 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6], 5, 8, False) == None
        bytes
            memory data5Bit60 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c05170006";
        bytes memory data8BitExpected60 = hex"";
        (bytes memory data8BitActual60, Bech32m.DecodeError err60) = Bech32m
            .convert5to8(data5Bit60);
        assertEq(data8BitExpected60, data8BitActual60);
        assertTrue(err60 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101]
        bytes
            memory data5Bit61 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a";
        bytes
            memory data8BitExpected61 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc065";
        (bytes memory data8BitActual61, Bech32m.DecodeError err61) = Bech32m
            .convert5to8(data5Bit61);
        assertEq(data8BitExpected61, data8BitActual61);
        assertTrue(err61 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17], 5, 8, False) == None
        bytes
            memory data5Bit62 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a11";
        bytes memory data8BitExpected62 = hex"";
        (bytes memory data8BitActual62, Bech32m.DecodeError err62) = Bech32m
            .convert5to8(data5Bit62);
        assertEq(data8BitExpected62, data8BitActual62);
        assertTrue(err62 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12], 5, 8, False) == None
        bytes
            memory data5Bit63 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c";
        bytes memory data8BitExpected63 = hex"";
        (bytes memory data8BitActual63, Bech32m.DecodeError err63) = Bech32m
            .convert5to8(data5Bit63);
        assertEq(data8BitExpected63, data8BitActual63);
        assertTrue(err63 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146]
        bytes
            memory data5Bit64 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c12";
        bytes
            memory data8BitExpected64 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592";
        (bytes memory data8BitActual64, Bech32m.DecodeError err64) = Bech32m
            .convert5to8(data5Bit64);
        assertEq(data8BitExpected64, data8BitActual64);
        assertTrue(err64 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9], 5, 8, False) == None
        bytes
            memory data5Bit65 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209";
        bytes memory data8BitExpected65 = hex"";
        (bytes memory data8BitActual65, Bech32m.DecodeError err65) = Bech32m
            .convert5to8(data5Bit65);
        assertEq(data8BitExpected65, data8BitActual65);
        assertTrue(err65 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5], 5, 8, False) == None
        bytes
            memory data5Bit66 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c120905";
        bytes memory data8BitExpected66 = hex"";
        (bytes memory data8BitActual66, Bech32m.DecodeError err66) = Bech32m
            .convert5to8(data5Bit66);
        assertEq(data8BitExpected66, data8BitActual66);
        assertTrue(err66 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30], 5, 8, False) == None
        bytes
            memory data5Bit67 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e";
        bytes memory data8BitExpected67 = hex"";
        (bytes memory data8BitActual67, Bech32m.DecodeError err67) = Bech32m
            .convert5to8(data5Bit67);
        assertEq(data8BitExpected67, data8BitActual67);
        assertTrue(err67 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2], 5, 8, False) == None
        bytes
            memory data5Bit68 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e02";
        bytes memory data8BitExpected68 = hex"";
        (bytes memory data8BitActual68, Bech32m.DecodeError err68) = Bech32m
            .convert5to8(data5Bit68);
        assertEq(data8BitExpected68, data8BitActual68);
        assertTrue(err68 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34]
        bytes
            memory data5Bit69 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204";
        bytes
            memory data8BitExpected69 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c22";
        (bytes memory data8BitActual69, Bech32m.DecodeError err69) = Bech32m
            .convert5to8(data5Bit69);
        assertEq(data8BitExpected69, data8BitActual69);
        assertTrue(err69 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3], 5, 8, False) == None
        bytes
            memory data5Bit70 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e020403";
        bytes memory data8BitExpected70 = hex"";
        (bytes memory data8BitActual70, Bech32m.DecodeError err70) = Bech32m
            .convert5to8(data5Bit70);
        assertEq(data8BitExpected70, data8BitActual70);
        assertTrue(err70 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10], 5, 8, False) == None
        bytes
            memory data5Bit71 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a";
        bytes memory data8BitExpected71 = hex"";
        (bytes memory data8BitActual71, Bech32m.DecodeError err71) = Bech32m
            .convert5to8(data5Bit71);
        assertEq(data8BitExpected71, data8BitActual71);
        assertTrue(err71 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65]
        bytes
            memory data5Bit72 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01";
        bytes
            memory data8BitExpected72 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41";
        (bytes memory data8BitActual72, Bech32m.DecodeError err72) = Bech32m
            .convert5to8(data5Bit72);
        assertEq(data8BitExpected72, data8BitActual72);
        assertTrue(err72 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21], 5, 8, False) == None
        bytes
            memory data5Bit73 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a0115";
        bytes memory data8BitExpected73 = hex"";
        (bytes memory data8BitActual73, Bech32m.DecodeError err73) = Bech32m
            .convert5to8(data5Bit73);
        assertEq(data8BitExpected73, data8BitActual73);
        assertTrue(err73 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15], 5, 8, False) == None
        bytes
            memory data5Bit74 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f";
        bytes memory data8BitExpected74 = hex"";
        (bytes memory data8BitActual74, Bech32m.DecodeError err74) = Bech32m
            .convert5to8(data5Bit74);
        assertEq(data8BitExpected74, data8BitActual74);
        assertTrue(err74 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15], 5, 8, False) == None
        bytes
            memory data5Bit75 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f";
        bytes memory data8BitExpected75 = hex"";
        (bytes memory data8BitActual75, Bech32m.DecodeError err75) = Bech32m
            .convert5to8(data5Bit75);
        assertEq(data8BitExpected75, data8BitActual75);
        assertTrue(err75 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19], 5, 8, False) == None
        bytes
            memory data5Bit76 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f13";
        bytes memory data8BitExpected76 = hex"";
        (bytes memory data8BitActual76, Bech32m.DecodeError err76) = Bech32m
            .convert5to8(data5Bit76);
        assertEq(data8BitExpected76, data8BitActual76);
        assertTrue(err76 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52]
        bytes
            memory data5Bit77 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f1308";
        bytes
            memory data8BitExpected77 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf34";
        (bytes memory data8BitActual77, Bech32m.DecodeError err77) = Bech32m
            .convert5to8(data5Bit77);
        assertEq(data8BitExpected77, data8BitActual77);
        assertTrue(err77 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7], 5, 8, False) == None
        bytes
            memory data5Bit78 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807";
        bytes memory data8BitExpected78 = hex"";
        (bytes memory data8BitActual78, Bech32m.DecodeError err78) = Bech32m
            .convert5to8(data5Bit78);
        assertEq(data8BitExpected78, data8BitActual78);
        assertTrue(err78 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1], 5, 8, False) == None
        bytes
            memory data5Bit79 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f13080701";
        bytes memory data8BitExpected79 = hex"";
        (bytes memory data8BitActual79, Bech32m.DecodeError err79) = Bech32m
            .convert5to8(data5Bit79);
        assertEq(data8BitExpected79, data8BitActual79);
        assertTrue(err79 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52, 28, 44]
        bytes
            memory data5Bit80 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c";
        bytes
            memory data8BitExpected80 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf341c2c";
        (bytes memory data8BitActual80, Bech32m.DecodeError err80) = Bech32m
            .convert5to8(data5Bit80);
        assertEq(data8BitExpected80, data8BitActual80);
        assertTrue(err80 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27], 5, 8, False) == None
        bytes
            memory data5Bit81 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b";
        bytes memory data8BitExpected81 = hex"";
        (bytes memory data8BitActual81, Bech32m.DecodeError err81) = Bech32m
            .convert5to8(data5Bit81);
        assertEq(data8BitExpected81, data8BitActual81);
        assertTrue(err81 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19], 5, 8, False) == None
        bytes
            memory data5Bit82 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b13";
        bytes memory data8BitExpected82 = hex"";
        (bytes memory data8BitActual82, Bech32m.DecodeError err82) = Bech32m
            .convert5to8(data5Bit82);
        assertEq(data8BitExpected82, data8BitActual82);
        assertTrue(err82 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12], 5, 8, False) == None
        bytes
            memory data5Bit83 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c";
        bytes memory data8BitExpected83 = hex"";
        (bytes memory data8BitActual83, Bech32m.DecodeError err83) = Bech32m
            .convert5to8(data5Bit83);
        assertEq(data8BitExpected83, data8BitActual83);
        assertTrue(err83 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20], 5, 8, False) == None
        bytes
            memory data5Bit84 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14";
        bytes memory data8BitExpected84 = hex"";
        (bytes memory data8BitActual84, Bech32m.DecodeError err84) = Bech32m
            .convert5to8(data5Bit84);
        assertEq(data8BitExpected84, data8BitActual84);
        assertTrue(err84 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17], 5, 8, False) == None
        bytes
            memory data5Bit85 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c1411";
        bytes memory data8BitExpected85 = hex"";
        (bytes memory data8BitActual85, Bech32m.DecodeError err85) = Bech32m
            .convert5to8(data5Bit85);
        assertEq(data8BitExpected85, data8BitActual85);
        assertTrue(err85 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15], 5, 8, False) == None
        bytes
            memory data5Bit86 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f";
        bytes memory data8BitExpected86 = hex"";
        (bytes memory data8BitActual86, Bech32m.DecodeError err86) = Bech32m
            .convert5to8(data5Bit86);
        assertEq(data8BitExpected86, data8BitActual86);
        assertTrue(err86 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52, 28, 44, 220, 217, 72, 189]
        bytes
            memory data5Bit87 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f08";
        bytes
            memory data8BitExpected87 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf341c2cdcd948bd";
        (bytes memory data8BitActual87, Bech32m.DecodeError err87) = Bech32m
            .convert5to8(data5Bit87);
        assertEq(data8BitExpected87, data8BitActual87);
        assertTrue(err87 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52, 28, 44, 220, 217, 72, 189, 29]
        bytes
            memory data5Bit88 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d";
        bytes
            memory data8BitExpected88 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf341c2cdcd948bd1d";
        (bytes memory data8BitActual88, Bech32m.DecodeError err88) = Bech32m
            .convert5to8(data5Bit88);
        assertEq(data8BitExpected88, data8BitActual88);
        assertTrue(err88 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12], 5, 8, False) == None
        bytes
            memory data5Bit89 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c";
        bytes memory data8BitExpected89 = hex"";
        (bytes memory data8BitActual89, Bech32m.DecodeError err89) = Bech32m
            .convert5to8(data5Bit89);
        assertEq(data8BitExpected89, data8BitActual89);
        assertTrue(err89 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52, 28, 44, 220, 217, 72, 189, 29, 102]
        bytes
            memory data5Bit90 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c18";
        bytes
            memory data8BitExpected90 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf341c2cdcd948bd1d66";
        (bytes memory data8BitActual90, Bech32m.DecodeError err90) = Bech32m
            .convert5to8(data5Bit90);
        assertEq(data8BitExpected90, data8BitActual90);
        assertTrue(err90 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1], 5, 8, False) == None
        bytes
            memory data5Bit91 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c1801";
        bytes memory data8BitExpected91 = hex"";
        (bytes memory data8BitActual91, Bech32m.DecodeError err91) = Bech32m
            .convert5to8(data5Bit91);
        assertEq(data8BitExpected91, data8BitActual91);
        assertTrue(err91 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23], 5, 8, False) == None
        bytes
            memory data5Bit92 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117";
        bytes memory data8BitExpected92 = hex"";
        (bytes memory data8BitActual92, Bech32m.DecodeError err92) = Bech32m
            .convert5to8(data5Bit92);
        assertEq(data8BitExpected92, data8BitActual92);
        assertTrue(err92 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19], 5, 8, False) == None
        bytes
            memory data5Bit93 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c18011713";
        bytes memory data8BitExpected93 = hex"";
        (bytes memory data8BitActual93, Bech32m.DecodeError err93) = Bech32m
            .convert5to8(data5Bit93);
        assertEq(data8BitExpected93, data8BitActual93);
        assertTrue(err93 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14], 5, 8, False) == None
        bytes
            memory data5Bit94 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e";
        bytes memory data8BitExpected94 = hex"";
        (bytes memory data8BitActual94, Bech32m.DecodeError err94) = Bech32m
            .convert5to8(data5Bit94);
        assertEq(data8BitExpected94, data8BitActual94);
        assertTrue(err94 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26], 5, 8, False) == None
        bytes
            memory data5Bit95 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a";
        bytes memory data8BitExpected95 = hex"";
        (bytes memory data8BitActual95, Bech32m.DecodeError err95) = Bech32m
            .convert5to8(data5Bit95);
        assertEq(data8BitExpected95, data8BitActual95);
        assertTrue(err95 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52, 28, 44, 220, 217, 72, 189, 29, 102, 3, 121, 187, 83]
        bytes
            memory data5Bit96 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a13";
        bytes
            memory data8BitExpected96 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf341c2cdcd948bd1d660379bb53";
        (bytes memory data8BitActual96, Bech32m.DecodeError err96) = Bech32m
            .convert5to8(data5Bit96);
        assertEq(data8BitExpected96, data8BitActual96);
        assertTrue(err96 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19, 28], 5, 8, False) == None
        bytes
            memory data5Bit97 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a131c";
        bytes memory data8BitExpected97 = hex"";
        (bytes memory data8BitActual97, Bech32m.DecodeError err97) = Bech32m
            .convert5to8(data5Bit97);
        assertEq(data8BitExpected97, data8BitActual97);
        assertTrue(err97 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19, 28, 3], 5, 8, False) == None
        bytes
            memory data5Bit98 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a131c03";
        bytes memory data8BitExpected98 = hex"";
        (bytes memory data8BitActual98, Bech32m.DecodeError err98) = Bech32m
            .convert5to8(data5Bit98);
        assertEq(data8BitExpected98, data8BitActual98);
        assertTrue(err98 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19, 28, 3, 27], 5, 8, False) == None
        bytes
            memory data5Bit99 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a131c031b";
        bytes memory data8BitExpected99 = hex"";
        (bytes memory data8BitActual99, Bech32m.DecodeError err99) = Bech32m
            .convert5to8(data5Bit99);
        assertEq(data8BitExpected99, data8BitActual99);
        assertTrue(err99 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19, 28, 3, 27, 3], 5, 8, False) == None
        bytes
            memory data5Bit100 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a131c031b03";
        bytes memory data8BitExpected100 = hex"";
        (bytes memory data8BitActual100, Bech32m.DecodeError err100) = Bech32m
            .convert5to8(data5Bit100);
        assertEq(data8BitExpected100, data8BitActual100);
        assertTrue(err100 != Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19, 28, 3, 27, 3, 18], 5, 8, False) == [241, 7, 170, 197, 157, 255, 29, 73, 235, 254, 219, 127, 3, 135, 126, 170, 2, 151, 249, 167, 211, 207, 242, 110, 223, 199, 84, 6, 242, 34, 37, 109, 60, 45, 252, 45, 192, 101, 69, 146, 73, 124, 34, 13, 65, 171, 223, 52, 28, 44, 220, 217, 72, 189, 29, 102, 3, 121, 187, 83, 224, 246, 57]
        bytes
            memory data5Bit101 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a131c031b0312";
        bytes
            memory data8BitExpected101 = hex"f107aac59dff1d49ebfedb7f03877eaa0297f9a7d3cff26edfc75406f222256d3c2dfc2dc0654592497c220d41abdf341c2cdcd948bd1d660379bb53e0f639";
        (bytes memory data8BitActual101, Bech32m.DecodeError err101) = Bech32m
            .convert5to8(data5Bit101);
        assertEq(data8BitExpected101, data8BitActual101);
        assertTrue(err101 == Bech32m.DecodeError.NoError);

        // convertbits([30, 4, 3, 26, 21, 17, 12, 29, 31, 28, 14, 20, 19, 26, 31, 30, 27, 13, 31, 16, 7, 1, 27, 30, 21, 8, 1, 9, 15, 30, 13, 7, 26, 15, 7, 31, 4, 27, 22, 31, 24, 29, 10, 0, 13, 28, 17, 2, 4, 21, 22, 19, 24, 11, 15, 28, 5, 23, 0, 6, 10, 17, 12, 18, 9, 5, 30, 2, 4, 3, 10, 1, 21, 15, 15, 19, 8, 7, 1, 12, 27, 19, 12, 20, 17, 15, 8, 29, 12, 24, 1, 23, 19, 14, 26, 19, 28, 3, 27, 3, 18, 26], 5, 8, False) == None
        bytes
            memory data5Bit102 = hex"1e04031a15110c1d1f1c0e14131a1f1e1b0d1f1007011b1e150801090f1e0d071a0f071f041b161f181d0a000d1c110204151613180b0f1c051700060a110c1209051e0204030a01150f0f130807010c1b130c14110f081d0c180117130e1a131c031b03121a";
        bytes memory data8BitExpected102 = hex"";
        (bytes memory data8BitActual102, Bech32m.DecodeError err102) = Bech32m
            .convert5to8(data5Bit102);
        assertEq(data8BitExpected102, data8BitActual102);
        assertTrue(err102 != Bech32m.DecodeError.NoError);
    }

    function testIsValidCharacterRange() public pure {
        bytes memory s1 = bytes("abcdef");
        assertTrue(Bech32m.isValidCharacterRange(s1));

        bytes memory s2 = bytes("ABCDEF");
        assertTrue(Bech32m.isValidCharacterRange(s2));

        bytes memory s3 = hex"00a1";
        assertFalse(Bech32m.isValidCharacterRange(s3));

        bytes memory s4 = hex"ff";
        assertFalse(Bech32m.isValidCharacterRange(s4));
    }

    function testIsMixedCase() public pure {
        assertTrue(Bech32m.isMixedCase(bytes("aBcDeF")));
        assertFalse(Bech32m.isMixedCase(bytes("aaaa")));
        assertFalse(Bech32m.isMixedCase(bytes("AAAAA")));
        assertFalse(Bech32m.isMixedCase(bytes("")));
    }

    function testToLower() public pure {
        assertEq(Bech32m.toLower(bytes("aaaBB")), bytes("aaabb"));
        assertEq(Bech32m.toLower(bytes("+a1+B- ")), bytes("+a1+b- "));
        assertEq(Bech32m.toLower(bytes("")), bytes(""));
        assertEq(
            Bech32m.toLower(bytes("ABCDEFGHIJKLMNOPQRSTUVWXYZ")),
            bytes("abcdefghijklmnopqrstuvwxyz")
        );
    }

    function testDecodeCharactersBech32() public pure {
        // This test was generated automatically by gen_reverse_charset_test_data.py

        bytes
            memory data0 = hex"71707a7279397838676632747664773073336a6e35346b686365366d7561376c";
        bytes
            memory rezExpected0 = hex"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
        Bech32m.DecodeError errExpected0 = Bech32m.DecodeError.NoError;
        (bytes memory rezActual0, Bech32m.DecodeError errActual0) = Bech32m
            .decodeCharactersBech32(data0, 0, 32);
        assertEq(rezExpected0, rezActual0);
        assertTrue(errExpected0 == errActual0);

        bytes
            memory data1 = hex"32747664773073336a6e35346b686365366d7561376c71707a72793978386766";
        bytes
            memory rezExpected1 = hex"0a0b0c0d0e0f101112131415161718191a1b1c1d1e1f00010203040506070809";
        Bech32m.DecodeError errExpected1 = Bech32m.DecodeError.NoError;
        (bytes memory rezActual1, Bech32m.DecodeError errActual1) = Bech32m
            .decodeCharactersBech32(data1, 0, 32);
        assertEq(rezExpected1, rezActual1);
        assertTrue(errExpected1 == errActual1);

        bytes
            memory data2 = hex"32747664773073336a6e35346b686365366d7561376c71707a72793978386766";
        bytes memory rezExpected2 = hex"0a0b0c0d0e0f10111213";
        Bech32m.DecodeError errExpected2 = Bech32m.DecodeError.NoError;
        (bytes memory rezActual2, Bech32m.DecodeError errActual2) = Bech32m
            .decodeCharactersBech32(data2, 0, 10);
        assertEq(rezExpected2, rezActual2);
        assertTrue(errExpected2 == errActual2);

        bytes
            memory data3 = hex"32747664773073336a6e35346b686365366d7561376c71707a72793978386766";
        bytes memory rezExpected3 = hex"191a1b1c1d1e1f00010203040506070809";
        Bech32m.DecodeError errExpected3 = Bech32m.DecodeError.NoError;
        (bytes memory rezActual3, Bech32m.DecodeError errActual3) = Bech32m
            .decodeCharactersBech32(data3, 15, 32);
        assertEq(rezExpected3, rezActual3);
        assertTrue(errExpected3 == errActual3);

        bytes
            memory data4 = hex"32747664773073336a6e35346b686365366d7561376c71707a72793978386766";
        bytes memory rezExpected4 = hex"0f101112131415161718191a1b1c1d1e";
        Bech32m.DecodeError errExpected4 = Bech32m.DecodeError.NoError;
        (bytes memory rezActual4, Bech32m.DecodeError errActual4) = Bech32m
            .decodeCharactersBech32(data4, 5, 21);
        assertEq(rezExpected4, rezActual4);
        assertTrue(errExpected4 == errActual4);

        bytes memory data5 = hex"316162";
        bytes memory rezExpected5 = hex"";
        Bech32m.DecodeError errExpected5 = Bech32m
            .DecodeError
            .NotBech32Character;
        (bytes memory rezActual5, Bech32m.DecodeError errActual5) = Bech32m
            .decodeCharactersBech32(data5, 0, 3);
        assertEq(rezExpected5, rezActual5);
        assertTrue(errExpected5 == errActual5);

        bytes memory data6 = hex"c3bf";
        bytes memory rezExpected6 = hex"";
        Bech32m.DecodeError errExpected6 = Bech32m
            .DecodeError
            .NotBech32Character;
        (bytes memory rezActual6, Bech32m.DecodeError errActual6) = Bech32m
            .decodeCharactersBech32(data6, 0, 1);
        assertEq(rezExpected6, rezActual6);
        assertTrue(errExpected6 == errActual6);
    }

    function testBech32Decode() public pure {
        // This test was generated automatically by gen_ref_data_bech32_decode.py

        // bech32_encode('''tb''', [0, 1, 2], Encoding.BECH32) == '''tb1qpz0a0mjz'''
        bytes memory encodedData0 = hex"74623171707a3061306d6a7a";
        (
            bytes memory hrpActual0,
            bytes memory dataActual0,
            Bech32m.BechEncoding specActual0,
            Bech32m.DecodeError err0
        ) = Bech32m.bech32Decode(encodedData0);
        assertEq(hrpActual0, hex"7462"); // tb
        assertEq(dataActual0, hex"000102");
        assertTrue(specActual0 == Bech32m.BechEncoding.BECH32);
        assertTrue(err0 == Bech32m.DecodeError.NoError);

        // bech32_encode('''bc''', [], Encoding.BECH32M) == '''bc1a8xfp7'''
        bytes memory encodedData1 = hex"626331613878667037";
        (
            bytes memory hrpActual1,
            bytes memory dataActual1,
            Bech32m.BechEncoding specActual1,
            Bech32m.DecodeError err1
        ) = Bech32m.bech32Decode(encodedData1);
        assertEq(hrpActual1, hex"6263"); // bc
        assertEq(dataActual1, hex"");
        assertTrue(specActual1 == Bech32m.BechEncoding.BECH32M);
        assertTrue(err1 == Bech32m.DecodeError.NoError);

        // bech32_encode('''tb''', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31], Encoding.BECH32M) == '''tb1qpzry9x8gf2tvdw0s3jn54khce6mua7l29t8na'''
        bytes
            memory encodedData2 = hex"74623171707a7279397838676632747664773073336a6e35346b686365366d7561376c323974386e61";
        (
            bytes memory hrpActual2,
            bytes memory dataActual2,
            Bech32m.BechEncoding specActual2,
            Bech32m.DecodeError err2
        ) = Bech32m.bech32Decode(encodedData2);
        assertEq(hrpActual2, hex"7462"); // tb
        assertEq(
            dataActual2,
            hex"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f"
        );
        assertTrue(specActual2 == Bech32m.BechEncoding.BECH32M);
        assertTrue(err2 == Bech32m.DecodeError.NoError);
    }

    function testAreBytesEqual() public pure {
        assertTrue(Bech32m.areBytesEqual(bytes("abc"), bytes("abc")));
        assertFalse(Bech32m.areBytesEqual(bytes("abc"), bytes("ab")));
        assertFalse(Bech32m.areBytesEqual(bytes("abc"), bytes("bbb")));
    }

    function testBech32DecodeSpecBech32() public pure {
        // This test was generated automatically by gen_ref_data_spec_valid_bech32.py

        // A12UEL5L
        bytes memory bech0 = hex"41313255454c354c";
        bytes memory hrpExpected0 = hex"61";
        bytes memory data5bitExpected0 = hex"";
        Bech32m.BechEncoding encodingExpected0 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected0 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual0,
            bytes memory data5bitActual0,
            Bech32m.BechEncoding encodingActual0,
            Bech32m.DecodeError errActual0
        ) = Bech32m.bech32Decode(bech0);
        assertEq(hrpExpected0, hrpActual0);
        assertEq(data5bitExpected0, data5bitActual0);
        assertTrue(encodingExpected0 == encodingActual0);
        assertTrue(errExpected0 == errActual0);

        // a12uel5l
        bytes memory bech1 = hex"61313275656c356c";
        bytes memory hrpExpected1 = hex"61";
        bytes memory data5bitExpected1 = hex"";
        Bech32m.BechEncoding encodingExpected1 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected1 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual1,
            bytes memory data5bitActual1,
            Bech32m.BechEncoding encodingActual1,
            Bech32m.DecodeError errActual1
        ) = Bech32m.bech32Decode(bech1);
        assertEq(hrpExpected1, hrpActual1);
        assertEq(data5bitExpected1, data5bitActual1);
        assertTrue(encodingExpected1 == encodingActual1);
        assertTrue(errExpected1 == errActual1);

        // an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs
        bytes
            memory bech2 = hex"616e38336368617261637465726c6f6e6768756d616e7265616461626c657061727474686174636f6e7461696e737468656e756d62657231616e647468656578636c756465646368617261637465727362696f31747435746773";
        bytes
            memory hrpExpected2 = hex"616e38336368617261637465726c6f6e6768756d616e7265616461626c657061727474686174636f6e7461696e737468656e756d62657231616e647468656578636c756465646368617261637465727362696f";
        bytes memory data5bitExpected2 = hex"";
        Bech32m.BechEncoding encodingExpected2 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected2 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual2,
            bytes memory data5bitActual2,
            Bech32m.BechEncoding encodingActual2,
            Bech32m.DecodeError errActual2
        ) = Bech32m.bech32Decode(bech2);
        assertEq(hrpExpected2, hrpActual2);
        assertEq(data5bitExpected2, data5bitActual2);
        assertTrue(encodingExpected2 == encodingActual2);
        assertTrue(errExpected2 == errActual2);

        // abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw
        bytes
            memory bech3 = hex"6162636465663171707a7279397838676632747664773073336a6e35346b686365366d7561376c6d7171717877";
        bytes memory hrpExpected3 = hex"616263646566";
        bytes
            memory data5bitExpected3 = hex"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
        Bech32m.BechEncoding encodingExpected3 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected3 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual3,
            bytes memory data5bitActual3,
            Bech32m.BechEncoding encodingActual3,
            Bech32m.DecodeError errActual3
        ) = Bech32m.bech32Decode(bech3);
        assertEq(hrpExpected3, hrpActual3);
        assertEq(data5bitExpected3, data5bitActual3);
        assertTrue(encodingExpected3 == encodingActual3);
        assertTrue(errExpected3 == errActual3);

        // 11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j
        bytes
            memory bech4 = hex"31317171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717171717163383234376a";
        bytes memory hrpExpected4 = hex"31";
        bytes
            memory data5bitExpected4 = hex"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
        Bech32m.BechEncoding encodingExpected4 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected4 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual4,
            bytes memory data5bitActual4,
            Bech32m.BechEncoding encodingActual4,
            Bech32m.DecodeError errActual4
        ) = Bech32m.bech32Decode(bech4);
        assertEq(hrpExpected4, hrpActual4);
        assertEq(data5bitExpected4, data5bitActual4);
        assertTrue(encodingExpected4 == encodingActual4);
        assertTrue(errExpected4 == errActual4);

        // split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w
        bytes
            memory bech5 = hex"73706c697431636865636b7570737461676568616e647368616b65757073747265616d657272616e7465727265646361706572726564327939653377";
        bytes memory hrpExpected5 = hex"73706c6974";
        bytes
            memory data5bitExpected5 = hex"18171918161c01100b1d0819171d130d10171d16191c01100b03191d1b1903031d130b190303190d181d01190303190d";
        Bech32m.BechEncoding encodingExpected5 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected5 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual5,
            bytes memory data5bitActual5,
            Bech32m.BechEncoding encodingActual5,
            Bech32m.DecodeError errActual5
        ) = Bech32m.bech32Decode(bech5);
        assertEq(hrpExpected5, hrpActual5);
        assertEq(data5bitExpected5, data5bitActual5);
        assertTrue(encodingExpected5 == encodingActual5);
        assertTrue(errExpected5 == errActual5);

        // ?1ezyfcl
        bytes memory bech6 = hex"3f31657a7966636c";
        bytes memory hrpExpected6 = hex"3f";
        bytes memory data5bitExpected6 = hex"";
        Bech32m.BechEncoding encodingExpected6 = Bech32m.BechEncoding.BECH32;
        Bech32m.DecodeError errExpected6 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual6,
            bytes memory data5bitActual6,
            Bech32m.BechEncoding encodingActual6,
            Bech32m.DecodeError errActual6
        ) = Bech32m.bech32Decode(bech6);
        assertEq(hrpExpected6, hrpActual6);
        assertEq(data5bitExpected6, data5bitActual6);
        assertTrue(encodingExpected6 == encodingActual6);
        assertTrue(errExpected6 == errActual6);
    }

    function testBech32DecodeSpecBech32m() public pure {
        // A1LQFN3A
        bytes memory bech0 = hex"41314c51464e3341";
        bytes memory hrpExpected0 = hex"61";
        bytes memory data5bitExpected0 = hex"";
        Bech32m.BechEncoding encodingExpected0 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected0 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual0,
            bytes memory data5bitActual0,
            Bech32m.BechEncoding encodingActual0,
            Bech32m.DecodeError errActual0
        ) = Bech32m.bech32Decode(bech0);
        assertEq(hrpExpected0, hrpActual0);
        assertEq(data5bitExpected0, data5bitActual0);
        assertTrue(encodingExpected0 == encodingActual0);
        assertTrue(errExpected0 == errActual0);

        // a1lqfn3a
        bytes memory bech1 = hex"61316c71666e3361";
        bytes memory hrpExpected1 = hex"61";
        bytes memory data5bitExpected1 = hex"";
        Bech32m.BechEncoding encodingExpected1 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected1 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual1,
            bytes memory data5bitActual1,
            Bech32m.BechEncoding encodingActual1,
            Bech32m.DecodeError errActual1
        ) = Bech32m.bech32Decode(bech1);
        assertEq(hrpExpected1, hrpActual1);
        assertEq(data5bitExpected1, data5bitActual1);
        assertTrue(encodingExpected1 == encodingActual1);
        assertTrue(errExpected1 == errActual1);

        // an83characterlonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11sg7hg6
        bytes
            memory bech2 = hex"616e38336368617261637465726c6f6e6768756d616e7265616461626c657061727474686174636f6e7461696e737468657468656578636c756465646368617261637465727362696f616e646e756d6265723131736737686736";
        bytes
            memory hrpExpected2 = hex"616e38336368617261637465726c6f6e6768756d616e7265616461626c657061727474686174636f6e7461696e737468657468656578636c756465646368617261637465727362696f616e646e756d62657231";
        bytes memory data5bitExpected2 = hex"";
        Bech32m.BechEncoding encodingExpected2 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected2 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual2,
            bytes memory data5bitActual2,
            Bech32m.BechEncoding encodingActual2,
            Bech32m.DecodeError errActual2
        ) = Bech32m.bech32Decode(bech2);
        assertEq(hrpExpected2, hrpActual2);
        assertEq(data5bitExpected2, data5bitActual2);
        assertTrue(encodingExpected2 == encodingActual2);
        assertTrue(errExpected2 == errActual2);

        // abcdef1l7aum6echk45nj3s0wdvt2fg8x9yrzpqzd3ryx
        bytes
            memory bech3 = hex"616263646566316c3761756d366563686b34356e6a3373307764767432666738783979727a70717a6433727978";
        bytes memory hrpExpected3 = hex"616263646566";
        bytes
            memory data5bitExpected3 = hex"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100";
        Bech32m.BechEncoding encodingExpected3 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected3 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual3,
            bytes memory data5bitActual3,
            Bech32m.BechEncoding encodingActual3,
            Bech32m.DecodeError errActual3
        ) = Bech32m.bech32Decode(bech3);
        assertEq(hrpExpected3, hrpActual3);
        assertEq(data5bitExpected3, data5bitActual3);
        assertTrue(encodingExpected3 == encodingActual3);
        assertTrue(errExpected3 == errActual3);

        // 11llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllludsr8
        bytes
            memory bech4 = hex"31316c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c6c7564737238";
        bytes memory hrpExpected4 = hex"31";
        bytes
            memory data5bitExpected4 = hex"1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f1f";
        Bech32m.BechEncoding encodingExpected4 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected4 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual4,
            bytes memory data5bitActual4,
            Bech32m.BechEncoding encodingActual4,
            Bech32m.DecodeError errActual4
        ) = Bech32m.bech32Decode(bech4);
        assertEq(hrpExpected4, hrpActual4);
        assertEq(data5bitExpected4, data5bitActual4);
        assertTrue(encodingExpected4 == encodingActual4);
        assertTrue(errExpected4 == errActual4);

        // split1checkupstagehandshakeupstreamerranterredcaperredlc445v
        bytes
            memory bech5 = hex"73706c697431636865636b7570737461676568616e647368616b65757073747265616d657272616e74657272656463617065727265646c6334343576";
        bytes memory hrpExpected5 = hex"73706c6974";
        bytes
            memory data5bitExpected5 = hex"18171918161c01100b1d0819171d130d10171d16191c01100b03191d1b1903031d130b190303190d181d01190303190d";
        Bech32m.BechEncoding encodingExpected5 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected5 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual5,
            bytes memory data5bitActual5,
            Bech32m.BechEncoding encodingActual5,
            Bech32m.DecodeError errActual5
        ) = Bech32m.bech32Decode(bech5);
        assertEq(hrpExpected5, hrpActual5);
        assertEq(data5bitExpected5, data5bitActual5);
        assertTrue(encodingExpected5 == encodingActual5);
        assertTrue(errExpected5 == errActual5);

        // ?1v759aa
        bytes memory bech6 = hex"3f31763735396161";
        bytes memory hrpExpected6 = hex"3f";
        bytes memory data5bitExpected6 = hex"";
        Bech32m.BechEncoding encodingExpected6 = Bech32m.BechEncoding.BECH32M;
        Bech32m.DecodeError errExpected6 = Bech32m.DecodeError.NoError;
        (
            bytes memory hrpActual6,
            bytes memory data5bitActual6,
            Bech32m.BechEncoding encodingActual6,
            Bech32m.DecodeError errActual6
        ) = Bech32m.bech32Decode(bech6);
        assertEq(hrpExpected6, hrpActual6);
        assertEq(data5bitExpected6, data5bitActual6);
        assertTrue(encodingExpected6 == encodingActual6);
        assertTrue(errExpected6 == errActual6);
    }

    function testBech32DecodeSpecInvalidBech32() public pure {
        // tests from reference python implementation INVALID_BECH32
        // mostly generated automatically by gen_ref_data_spec_invalid_bech32.py
        // error codes and comments are added manually from comments in test.py and manual analysis
        // fixed some unicode bugs

        // ' 1nwldj5'
        // HRP character out of range
        bytes memory bech0 = hex"20316e776c646a35";
        bytes memory hrpExpected0 = hex"";
        bytes memory data5bitExpected0 = hex"";
        Bech32m.BechEncoding encodingExpected0 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected0 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual0,
            bytes memory data5bitActual0,
            Bech32m.BechEncoding encodingActual0,
            Bech32m.DecodeError errActual0
        ) = Bech32m.bech32Decode(bech0);
        assertEq(
            hrpExpected0,
            hrpActual0,
            unicode"hrp is incorrect after parsing invalid bech32: ' 1nwldj5'"
        );
        assertEq(
            data5bitExpected0,
            data5bitActual0,
            unicode"data5bit is incorrect after parsing invalid bech32: ' 1nwldj5'"
        );
        assertTrue(
            encodingExpected0 == encodingActual0,
            unicode"encoding is incorrect after parsing invalid bech32: ' 1nwldj5'"
        );
        assertTrue(
            errExpected0 == errActual0,
            unicode"error code is incorrect after parsing invalid bech32: ' 1nwldj5'"
        );

        // '\x7f1axkwrx'
        // HRP character out of range
        bytes memory bech1 = hex"7f3161786b777278";
        bytes memory hrpExpected1 = hex"";
        bytes memory data5bitExpected1 = hex"";
        Bech32m.BechEncoding encodingExpected1 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected1 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual1,
            bytes memory data5bitActual1,
            Bech32m.BechEncoding encodingActual1,
            Bech32m.DecodeError errActual1
        ) = Bech32m.bech32Decode(bech1);
        assertEq(
            hrpExpected1,
            hrpActual1,
            unicode"hrp is incorrect after parsing invalid bech32: '\x7f1axkwrx'"
        );
        assertEq(
            data5bitExpected1,
            data5bitActual1,
            unicode"data5bit is incorrect after parsing invalid bech32: '\x7f1axkwrx'"
        );
        assertTrue(
            encodingExpected1 == encodingActual1,
            unicode"encoding is incorrect after parsing invalid bech32: '\x7f1axkwrx'"
        );
        assertTrue(
            errExpected1 == errActual1,
            unicode"error code is incorrect after parsing invalid bech32: '\x7f1axkwrx'"
        );

        // '\x801eym55h'
        // HRP character out of range
        bytes memory bech2 = hex"c2803165796d353568";
        bytes memory hrpExpected2 = hex"";
        bytes memory data5bitExpected2 = hex"";
        Bech32m.BechEncoding encodingExpected2 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected2 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual2,
            bytes memory data5bitActual2,
            Bech32m.BechEncoding encodingActual2,
            Bech32m.DecodeError errActual2
        ) = Bech32m.bech32Decode(bech2);
        assertEq(
            hrpExpected2,
            hrpActual2,
            unicode"hrp is incorrect after parsing invalid bech32: '\\x801eym55h'"
        );
        assertEq(
            data5bitExpected2,
            data5bitActual2,
            unicode"data5bit is incorrect after parsing invalid bech32: '\\x801eym55h'"
        );
        assertTrue(
            encodingExpected2 == encodingActual2,
            unicode"encoding is incorrect after parsing invalid bech32: '\\x801eym55h'"
        );
        assertTrue(
            errExpected2 == errActual2,
            unicode"error code is incorrect after parsing invalid bech32: '\\x801eym55h'"
        );

        // 'an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx'
        // overall max length exceeded
        bytes
            memory bech3 = hex"616e3834636861726163746572736c6f6e6768756d616e7265616461626c657061727474686174636f6e7461696e737468656e756d62657231616e647468656578636c756465646368617261637465727362696f31353639707678";
        bytes memory hrpExpected3 = hex"";
        bytes memory data5bitExpected3 = hex"";
        Bech32m.BechEncoding encodingExpected3 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected3 = Bech32m.DecodeError.InputIsTooLong;
        (
            bytes memory hrpActual3,
            bytes memory data5bitActual3,
            Bech32m.BechEncoding encodingActual3,
            Bech32m.DecodeError errActual3
        ) = Bech32m.bech32Decode(bech3);
        assertEq(
            hrpExpected3,
            hrpActual3,
            unicode"hrp is incorrect after parsing invalid bech32: 'an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx'"
        );
        assertEq(
            data5bitExpected3,
            data5bitActual3,
            unicode"data5bit is incorrect after parsing invalid bech32: 'an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx'"
        );
        assertTrue(
            encodingExpected3 == encodingActual3,
            unicode"encoding is incorrect after parsing invalid bech32: 'an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx'"
        );
        assertTrue(
            errExpected3 == errActual3,
            unicode"error code is incorrect after parsing invalid bech32: 'an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx'"
        );

        // 'pzry9x0s0muk'
        // No separator character
        bytes memory bech4 = hex"707a727939783073306d756b";
        bytes memory hrpExpected4 = hex"";
        bytes memory data5bitExpected4 = hex"";
        Bech32m.BechEncoding encodingExpected4 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected4 = Bech32m.DecodeError.NoDelimiter;
        (
            bytes memory hrpActual4,
            bytes memory data5bitActual4,
            Bech32m.BechEncoding encodingActual4,
            Bech32m.DecodeError errActual4
        ) = Bech32m.bech32Decode(bech4);
        assertEq(
            hrpExpected4,
            hrpActual4,
            unicode"hrp is incorrect after parsing invalid bech32: 'pzry9x0s0muk'"
        );
        assertEq(
            data5bitExpected4,
            data5bitActual4,
            unicode"data5bit is incorrect after parsing invalid bech32: 'pzry9x0s0muk'"
        );
        assertTrue(
            encodingExpected4 == encodingActual4,
            unicode"encoding is incorrect after parsing invalid bech32: 'pzry9x0s0muk'"
        );
        assertTrue(
            errExpected4 == errActual4,
            unicode"error code is incorrect after parsing invalid bech32: 'pzry9x0s0muk'"
        );

        // '1pzry9x0s0muk'
        // Empty HRP
        bytes memory bech5 = hex"31707a727939783073306d756b";
        bytes memory hrpExpected5 = hex"";
        bytes memory data5bitExpected5 = hex"";
        Bech32m.BechEncoding encodingExpected5 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected5 = Bech32m.DecodeError.HRPIsEmpty;
        (
            bytes memory hrpActual5,
            bytes memory data5bitActual5,
            Bech32m.BechEncoding encodingActual5,
            Bech32m.DecodeError errActual5
        ) = Bech32m.bech32Decode(bech5);
        assertEq(
            hrpExpected5,
            hrpActual5,
            unicode"hrp is incorrect after parsing invalid bech32: '1pzry9x0s0muk'"
        );
        assertEq(
            data5bitExpected5,
            data5bitActual5,
            unicode"data5bit is incorrect after parsing invalid bech32: '1pzry9x0s0muk'"
        );
        assertTrue(
            encodingExpected5 == encodingActual5,
            unicode"encoding is incorrect after parsing invalid bech32: '1pzry9x0s0muk'"
        );
        assertTrue(
            errExpected5 == errActual5,
            unicode"error code is incorrect after parsing invalid bech32: '1pzry9x0s0muk'"
        );

        // 'x1b4n0q5v'
        // Invalid data character
        bytes memory bech6 = hex"783162346e30713576";
        bytes memory hrpExpected6 = hex"";
        bytes memory data5bitExpected6 = hex"";
        Bech32m.BechEncoding encodingExpected6 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected6 = Bech32m
            .DecodeError
            .NotBech32Character;
        (
            bytes memory hrpActual6,
            bytes memory data5bitActual6,
            Bech32m.BechEncoding encodingActual6,
            Bech32m.DecodeError errActual6
        ) = Bech32m.bech32Decode(bech6);
        assertEq(
            hrpExpected6,
            hrpActual6,
            unicode"hrp is incorrect after parsing invalid bech32: 'x1b4n0q5v'"
        );
        assertEq(
            data5bitExpected6,
            data5bitActual6,
            unicode"data5bit is incorrect after parsing invalid bech32: 'x1b4n0q5v'"
        );
        assertTrue(
            encodingExpected6 == encodingActual6,
            unicode"encoding is incorrect after parsing invalid bech32: 'x1b4n0q5v'"
        );
        assertTrue(
            errExpected6 == errActual6,
            unicode"error code is incorrect after parsing invalid bech32: 'x1b4n0q5v'"
        );

        // 'li1dgmt3'
        // Too short checksum
        bytes memory bech7 = hex"6c693164676d7433";
        bytes memory hrpExpected7 = hex"";
        bytes memory data5bitExpected7 = hex"";
        Bech32m.BechEncoding encodingExpected7 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected7 = Bech32m.DecodeError.TooShortChecksum;
        (
            bytes memory hrpActual7,
            bytes memory data5bitActual7,
            Bech32m.BechEncoding encodingActual7,
            Bech32m.DecodeError errActual7
        ) = Bech32m.bech32Decode(bech7);
        assertEq(
            hrpExpected7,
            hrpActual7,
            unicode"hrp is incorrect after parsing invalid bech32: 'li1dgmt3'"
        );
        assertEq(
            data5bitExpected7,
            data5bitActual7,
            unicode"data5bit is incorrect after parsing invalid bech32: 'li1dgmt3'"
        );
        assertTrue(
            encodingExpected7 == encodingActual7,
            unicode"encoding is incorrect after parsing invalid bech32: 'li1dgmt3'"
        );
        assertTrue(
            errExpected7 == errActual7,
            unicode"error code is incorrect after parsing invalid bech32: 'li1dgmt3'"
        );

        // 'de1lg7wtÿ'
        // Invalid character in checksum
        bytes memory bech8 = hex"6465316c67377774c3bf";
        bytes memory hrpExpected8 = hex"";
        bytes memory data5bitExpected8 = hex"";
        Bech32m.BechEncoding encodingExpected8 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected8 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual8,
            bytes memory data5bitActual8,
            Bech32m.BechEncoding encodingActual8,
            Bech32m.DecodeError errActual8
        ) = Bech32m.bech32Decode(bech8);
        assertEq(
            hrpExpected8,
            hrpActual8,
            unicode"hrp is incorrect after parsing invalid bech32: 'de1lg7wtÿ'"
        );
        assertEq(
            data5bitExpected8,
            data5bitActual8,
            unicode"data5bit is incorrect after parsing invalid bech32: 'de1lg7wtÿ'"
        );
        assertTrue(
            encodingExpected8 == encodingActual8,
            unicode"encoding is incorrect after parsing invalid bech32: 'de1lg7wtÿ'"
        );
        assertTrue(
            errExpected8 == errActual8,
            unicode"error code is incorrect after parsing invalid bech32: 'de1lg7wtÿ'"
        );

        // 'A1G7SGD8'
        // checksum calculated with uppercase form of HRP
        bytes memory bech9 = hex"4131473753474438";
        bytes memory hrpExpected9 = hex"";
        bytes memory data5bitExpected9 = hex"";
        Bech32m.BechEncoding encodingExpected9 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected9 = Bech32m
            .DecodeError
            .IncorrectChecksum;
        (
            bytes memory hrpActual9,
            bytes memory data5bitActual9,
            Bech32m.BechEncoding encodingActual9,
            Bech32m.DecodeError errActual9
        ) = Bech32m.bech32Decode(bech9);
        assertEq(
            hrpExpected9,
            hrpActual9,
            unicode"hrp is incorrect after parsing invalid bech32: 'A1G7SGD8'"
        );
        assertEq(
            data5bitExpected9,
            data5bitActual9,
            unicode"data5bit is incorrect after parsing invalid bech32: 'A1G7SGD8'"
        );
        assertTrue(
            encodingExpected9 == encodingActual9,
            unicode"encoding is incorrect after parsing invalid bech32: 'A1G7SGD8'"
        );
        assertTrue(
            errExpected9 == errActual9,
            unicode"error code is incorrect after parsing invalid bech32: 'A1G7SGD8'"
        );

        // '10a06t8'
        // empty HRP
        bytes memory bech10 = hex"31306130367438";
        bytes memory hrpExpected10 = hex"";
        bytes memory data5bitExpected10 = hex"";
        Bech32m.BechEncoding encodingExpected10 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected10 = Bech32m.DecodeError.HRPIsEmpty;
        (
            bytes memory hrpActual10,
            bytes memory data5bitActual10,
            Bech32m.BechEncoding encodingActual10,
            Bech32m.DecodeError errActual10
        ) = Bech32m.bech32Decode(bech10);
        assertEq(
            hrpExpected10,
            hrpActual10,
            unicode"hrp is incorrect after parsing invalid bech32: '10a06t8'"
        );
        assertEq(
            data5bitExpected10,
            data5bitActual10,
            unicode"data5bit is incorrect after parsing invalid bech32: '10a06t8'"
        );
        assertTrue(
            encodingExpected10 == encodingActual10,
            unicode"encoding is incorrect after parsing invalid bech32: '10a06t8'"
        );
        assertTrue(
            errExpected10 == errActual10,
            unicode"error code is incorrect after parsing invalid bech32: '10a06t8'"
        );

        // '1qzzfhee'
        // empty HRP
        bytes memory bech11 = hex"31717a7a66686565";
        bytes memory hrpExpected11 = hex"";
        bytes memory data5bitExpected11 = hex"";
        Bech32m.BechEncoding encodingExpected11 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected11 = Bech32m.DecodeError.HRPIsEmpty;
        (
            bytes memory hrpActual11,
            bytes memory data5bitActual11,
            Bech32m.BechEncoding encodingActual11,
            Bech32m.DecodeError errActual11
        ) = Bech32m.bech32Decode(bech11);
        assertEq(
            hrpExpected11,
            hrpActual11,
            unicode"hrp is incorrect after parsing invalid bech32: '1qzzfhee'"
        );
        assertEq(
            data5bitExpected11,
            data5bitActual11,
            unicode"data5bit is incorrect after parsing invalid bech32: '1qzzfhee'"
        );
        assertTrue(
            encodingExpected11 == encodingActual11,
            unicode"encoding is incorrect after parsing invalid bech32: '1qzzfhee'"
        );
        assertTrue(
            errExpected11 == errActual11,
            unicode"error code is incorrect after parsing invalid bech32: '1qzzfhee'"
        );
    }

    function testBech32DecodeSpecInvalidBech32m() public pure {
        // tests from reference python implementation INVALID_BECH32M
        // mostly generated automatically by gen_ref_data_spec_invalid_bech32m.py
        // error codes and comments are added manually from comments in test.py and manual analysis
        // fixed some unicode bugs

        // ' 1xj0phk'
        bytes memory bech0 = hex"2031786a3070686b";
        bytes memory hrpExpected0 = hex"";
        bytes memory data5bitExpected0 = hex"";
        Bech32m.BechEncoding encodingExpected0 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected0 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual0,
            bytes memory data5bitActual0,
            Bech32m.BechEncoding encodingActual0,
            Bech32m.DecodeError errActual0
        ) = Bech32m.bech32Decode(bech0);
        assertEq(
            hrpExpected0,
            hrpActual0,
            unicode"hrp is incorrect after parsing invalid bech32m: ' 1xj0phk'"
        );
        assertEq(
            data5bitExpected0,
            data5bitActual0,
            unicode"data5bit is incorrect after parsing invalid bech32m: ' 1xj0phk'"
        );
        assertTrue(
            encodingExpected0 == encodingActual0,
            unicode"encoding is incorrect after parsing invalid bech32m: ' 1xj0phk'"
        );
        assertTrue(
            errExpected0 == errActual0,
            unicode"error code is incorrect after parsing invalid bech32m: ' 1xj0phk'"
        );

        // '\x7f1g6xzxy'
        bytes memory bech1 = hex"7f316736787a7879";
        bytes memory hrpExpected1 = hex"";
        bytes memory data5bitExpected1 = hex"";
        Bech32m.BechEncoding encodingExpected1 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected1 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual1,
            bytes memory data5bitActual1,
            Bech32m.BechEncoding encodingActual1,
            Bech32m.DecodeError errActual1
        ) = Bech32m.bech32Decode(bech1);
        assertEq(
            hrpExpected1,
            hrpActual1,
            unicode"hrp is incorrect after parsing invalid bech32m: '\x7f1g6xzxy'"
        );
        assertEq(
            data5bitExpected1,
            data5bitActual1,
            unicode"data5bit is incorrect after parsing invalid bech32m: '\x7f1g6xzxy'"
        );
        assertTrue(
            encodingExpected1 == encodingActual1,
            unicode"encoding is incorrect after parsing invalid bech32m: '\x7f1g6xzxy'"
        );
        assertTrue(
            errExpected1 == errActual1,
            unicode"error code is incorrect after parsing invalid bech32m: '\x7f1g6xzxy'"
        );

        // '\x801vctc34'
        bytes memory bech2 = hex"c28031766374633334";
        bytes memory hrpExpected2 = hex"";
        bytes memory data5bitExpected2 = hex"";
        Bech32m.BechEncoding encodingExpected2 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected2 = Bech32m
            .DecodeError
            .CharacterOutOfRange;
        (
            bytes memory hrpActual2,
            bytes memory data5bitActual2,
            Bech32m.BechEncoding encodingActual2,
            Bech32m.DecodeError errActual2
        ) = Bech32m.bech32Decode(bech2);
        assertEq(
            hrpExpected2,
            hrpActual2,
            unicode"hrp is incorrect after parsing invalid bech32m: '\\x801vctc34'"
        );
        assertEq(
            data5bitExpected2,
            data5bitActual2,
            unicode"data5bit is incorrect after parsing invalid bech32m: '\\x801vctc34'"
        );
        assertTrue(
            encodingExpected2 == encodingActual2,
            unicode"encoding is incorrect after parsing invalid bech32m: '\\x801vctc34'"
        );
        assertTrue(
            errExpected2 == errActual2,
            unicode"error code is incorrect after parsing invalid bech32m: '\\x801vctc34'"
        );

        // 'an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4'
        bytes
            memory bech3 = hex"616e3834636861726163746572736c6f6e6768756d616e7265616461626c657061727474686174636f6e7461696e737468657468656578636c756465646368617261637465727362696f616e646e756d6265723131643670747334";
        bytes memory hrpExpected3 = hex"";
        bytes memory data5bitExpected3 = hex"";
        Bech32m.BechEncoding encodingExpected3 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected3 = Bech32m.DecodeError.InputIsTooLong;
        (
            bytes memory hrpActual3,
            bytes memory data5bitActual3,
            Bech32m.BechEncoding encodingActual3,
            Bech32m.DecodeError errActual3
        ) = Bech32m.bech32Decode(bech3);
        assertEq(
            hrpExpected3,
            hrpActual3,
            unicode"hrp is incorrect after parsing invalid bech32m: 'an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4'"
        );
        assertEq(
            data5bitExpected3,
            data5bitActual3,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4'"
        );
        assertTrue(
            encodingExpected3 == encodingActual3,
            unicode"encoding is incorrect after parsing invalid bech32m: 'an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4'"
        );
        assertTrue(
            errExpected3 == errActual3,
            unicode"error code is incorrect after parsing invalid bech32m: 'an84characterslonghumanreadablepartthatcontainsthetheexcludedcharactersbioandnumber11d6pts4'"
        );

        // 'qyrz8wqd2c9m'
        bytes memory bech4 = hex"7179727a387771643263396d";
        bytes memory hrpExpected4 = hex"";
        bytes memory data5bitExpected4 = hex"";
        Bech32m.BechEncoding encodingExpected4 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected4 = Bech32m.DecodeError.NoDelimiter;
        (
            bytes memory hrpActual4,
            bytes memory data5bitActual4,
            Bech32m.BechEncoding encodingActual4,
            Bech32m.DecodeError errActual4
        ) = Bech32m.bech32Decode(bech4);
        assertEq(
            hrpExpected4,
            hrpActual4,
            unicode"hrp is incorrect after parsing invalid bech32m: 'qyrz8wqd2c9m'"
        );
        assertEq(
            data5bitExpected4,
            data5bitActual4,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'qyrz8wqd2c9m'"
        );
        assertTrue(
            encodingExpected4 == encodingActual4,
            unicode"encoding is incorrect after parsing invalid bech32m: 'qyrz8wqd2c9m'"
        );
        assertTrue(
            errExpected4 == errActual4,
            unicode"error code is incorrect after parsing invalid bech32m: 'qyrz8wqd2c9m'"
        );

        // '1qyrz8wqd2c9m'
        bytes memory bech5 = hex"317179727a387771643263396d";
        bytes memory hrpExpected5 = hex"";
        bytes memory data5bitExpected5 = hex"";
        Bech32m.BechEncoding encodingExpected5 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected5 = Bech32m.DecodeError.HRPIsEmpty;
        (
            bytes memory hrpActual5,
            bytes memory data5bitActual5,
            Bech32m.BechEncoding encodingActual5,
            Bech32m.DecodeError errActual5
        ) = Bech32m.bech32Decode(bech5);
        assertEq(
            hrpExpected5,
            hrpActual5,
            unicode"hrp is incorrect after parsing invalid bech32m: '1qyrz8wqd2c9m'"
        );
        assertEq(
            data5bitExpected5,
            data5bitActual5,
            unicode"data5bit is incorrect after parsing invalid bech32m: '1qyrz8wqd2c9m'"
        );
        assertTrue(
            encodingExpected5 == encodingActual5,
            unicode"encoding is incorrect after parsing invalid bech32m: '1qyrz8wqd2c9m'"
        );
        assertTrue(
            errExpected5 == errActual5,
            unicode"error code is incorrect after parsing invalid bech32m: '1qyrz8wqd2c9m'"
        );

        // 'y1b0jsk6g'
        bytes memory bech6 = hex"793162306a736b3667";
        bytes memory hrpExpected6 = hex"";
        bytes memory data5bitExpected6 = hex"";
        Bech32m.BechEncoding encodingExpected6 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected6 = Bech32m
            .DecodeError
            .NotBech32Character;
        (
            bytes memory hrpActual6,
            bytes memory data5bitActual6,
            Bech32m.BechEncoding encodingActual6,
            Bech32m.DecodeError errActual6
        ) = Bech32m.bech32Decode(bech6);
        assertEq(
            hrpExpected6,
            hrpActual6,
            unicode"hrp is incorrect after parsing invalid bech32m: 'y1b0jsk6g'"
        );
        assertEq(
            data5bitExpected6,
            data5bitActual6,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'y1b0jsk6g'"
        );
        assertTrue(
            encodingExpected6 == encodingActual6,
            unicode"encoding is incorrect after parsing invalid bech32m: 'y1b0jsk6g'"
        );
        assertTrue(
            errExpected6 == errActual6,
            unicode"error code is incorrect after parsing invalid bech32m: 'y1b0jsk6g'"
        );

        // 'lt1igcx5c0'
        bytes memory bech7 = hex"6c743169676378356330";
        bytes memory hrpExpected7 = hex"";
        bytes memory data5bitExpected7 = hex"";
        Bech32m.BechEncoding encodingExpected7 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected7 = Bech32m
            .DecodeError
            .NotBech32Character;
        (
            bytes memory hrpActual7,
            bytes memory data5bitActual7,
            Bech32m.BechEncoding encodingActual7,
            Bech32m.DecodeError errActual7
        ) = Bech32m.bech32Decode(bech7);
        assertEq(
            hrpExpected7,
            hrpActual7,
            unicode"hrp is incorrect after parsing invalid bech32m: 'lt1igcx5c0'"
        );
        assertEq(
            data5bitExpected7,
            data5bitActual7,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'lt1igcx5c0'"
        );
        assertTrue(
            encodingExpected7 == encodingActual7,
            unicode"encoding is incorrect after parsing invalid bech32m: 'lt1igcx5c0'"
        );
        assertTrue(
            errExpected7 == errActual7,
            unicode"error code is incorrect after parsing invalid bech32m: 'lt1igcx5c0'"
        );

        // 'in1muywd'
        bytes memory bech8 = hex"696e316d75797764";
        bytes memory hrpExpected8 = hex"";
        bytes memory data5bitExpected8 = hex"";
        Bech32m.BechEncoding encodingExpected8 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected8 = Bech32m.DecodeError.TooShortChecksum;
        (
            bytes memory hrpActual8,
            bytes memory data5bitActual8,
            Bech32m.BechEncoding encodingActual8,
            Bech32m.DecodeError errActual8
        ) = Bech32m.bech32Decode(bech8);
        assertEq(
            hrpExpected8,
            hrpActual8,
            unicode"hrp is incorrect after parsing invalid bech32m: 'in1muywd'"
        );
        assertEq(
            data5bitExpected8,
            data5bitActual8,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'in1muywd'"
        );
        assertTrue(
            encodingExpected8 == encodingActual8,
            unicode"encoding is incorrect after parsing invalid bech32m: 'in1muywd'"
        );
        assertTrue(
            errExpected8 == errActual8,
            unicode"error code is incorrect after parsing invalid bech32m: 'in1muywd'"
        );

        // 'mm1crxm3i'
        bytes memory bech9 = hex"6d6d316372786d3369";
        bytes memory hrpExpected9 = hex"";
        bytes memory data5bitExpected9 = hex"";
        Bech32m.BechEncoding encodingExpected9 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected9 = Bech32m
            .DecodeError
            .NotBech32Character;
        (
            bytes memory hrpActual9,
            bytes memory data5bitActual9,
            Bech32m.BechEncoding encodingActual9,
            Bech32m.DecodeError errActual9
        ) = Bech32m.bech32Decode(bech9);
        assertEq(
            hrpExpected9,
            hrpActual9,
            unicode"hrp is incorrect after parsing invalid bech32m: 'mm1crxm3i'"
        );
        assertEq(
            data5bitExpected9,
            data5bitActual9,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'mm1crxm3i'"
        );
        assertTrue(
            encodingExpected9 == encodingActual9,
            unicode"encoding is incorrect after parsing invalid bech32m: 'mm1crxm3i'"
        );
        assertTrue(
            errExpected9 == errActual9,
            unicode"error code is incorrect after parsing invalid bech32m: 'mm1crxm3i'"
        );

        // 'au1s5cgom'
        bytes memory bech10 = hex"617531733563676f6d";
        bytes memory hrpExpected10 = hex"";
        bytes memory data5bitExpected10 = hex"";
        Bech32m.BechEncoding encodingExpected10 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected10 = Bech32m
            .DecodeError
            .NotBech32Character;
        (
            bytes memory hrpActual10,
            bytes memory data5bitActual10,
            Bech32m.BechEncoding encodingActual10,
            Bech32m.DecodeError errActual10
        ) = Bech32m.bech32Decode(bech10);
        assertEq(
            hrpExpected10,
            hrpActual10,
            unicode"hrp is incorrect after parsing invalid bech32m: 'au1s5cgom'"
        );
        assertEq(
            data5bitExpected10,
            data5bitActual10,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'au1s5cgom'"
        );
        assertTrue(
            encodingExpected10 == encodingActual10,
            unicode"encoding is incorrect after parsing invalid bech32m: 'au1s5cgom'"
        );
        assertTrue(
            errExpected10 == errActual10,
            unicode"error code is incorrect after parsing invalid bech32m: 'au1s5cgom'"
        );

        // 'M1VUXWEZ'
        bytes memory bech11 = hex"4d3156555857455a";
        bytes memory hrpExpected11 = hex"";
        bytes memory data5bitExpected11 = hex"";
        Bech32m.BechEncoding encodingExpected11 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected11 = Bech32m
            .DecodeError
            .IncorrectChecksum;
        (
            bytes memory hrpActual11,
            bytes memory data5bitActual11,
            Bech32m.BechEncoding encodingActual11,
            Bech32m.DecodeError errActual11
        ) = Bech32m.bech32Decode(bech11);
        assertEq(
            hrpExpected11,
            hrpActual11,
            unicode"hrp is incorrect after parsing invalid bech32m: 'M1VUXWEZ'"
        );
        assertEq(
            data5bitExpected11,
            data5bitActual11,
            unicode"data5bit is incorrect after parsing invalid bech32m: 'M1VUXWEZ'"
        );
        assertTrue(
            encodingExpected11 == encodingActual11,
            unicode"encoding is incorrect after parsing invalid bech32m: 'M1VUXWEZ'"
        );
        assertTrue(
            errExpected11 == errActual11,
            unicode"error code is incorrect after parsing invalid bech32m: 'M1VUXWEZ'"
        );

        // '16plkw9'
        bytes memory bech12 = hex"3136706c6b7739";
        bytes memory hrpExpected12 = hex"";
        bytes memory data5bitExpected12 = hex"";
        Bech32m.BechEncoding encodingExpected12 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected12 = Bech32m.DecodeError.HRPIsEmpty;
        (
            bytes memory hrpActual12,
            bytes memory data5bitActual12,
            Bech32m.BechEncoding encodingActual12,
            Bech32m.DecodeError errActual12
        ) = Bech32m.bech32Decode(bech12);
        assertEq(
            hrpExpected12,
            hrpActual12,
            unicode"hrp is incorrect after parsing invalid bech32m: '16plkw9'"
        );
        assertEq(
            data5bitExpected12,
            data5bitActual12,
            unicode"data5bit is incorrect after parsing invalid bech32m: '16plkw9'"
        );
        assertTrue(
            encodingExpected12 == encodingActual12,
            unicode"encoding is incorrect after parsing invalid bech32m: '16plkw9'"
        );
        assertTrue(
            errExpected12 == errActual12,
            unicode"error code is incorrect after parsing invalid bech32m: '16plkw9'"
        );

        // '1p2gdwpf'
        bytes memory bech13 = hex"3170326764777066";
        bytes memory hrpExpected13 = hex"";
        bytes memory data5bitExpected13 = hex"";
        Bech32m.BechEncoding encodingExpected13 = Bech32m.BechEncoding.UNKNOWN;
        Bech32m.DecodeError errExpected13 = Bech32m.DecodeError.HRPIsEmpty;
        (
            bytes memory hrpActual13,
            bytes memory data5bitActual13,
            Bech32m.BechEncoding encodingActual13,
            Bech32m.DecodeError errActual13
        ) = Bech32m.bech32Decode(bech13);
        assertEq(
            hrpExpected13,
            hrpActual13,
            unicode"hrp is incorrect after parsing invalid bech32m: '1p2gdwpf'"
        );
        assertEq(
            data5bitExpected13,
            data5bitActual13,
            unicode"data5bit is incorrect after parsing invalid bech32m: '1p2gdwpf'"
        );
        assertTrue(
            encodingExpected13 == encodingActual13,
            unicode"encoding is incorrect after parsing invalid bech32m: '1p2gdwpf'"
        );
        assertTrue(
            errExpected13 == errActual13,
            unicode"error code is incorrect after parsing invalid bech32m: '1p2gdwpf'"
        );
    }

    function testValidAddressDecodeEncode() public pure {
        // tests from reference python implementation VALID_ADDRESS
        // this tests was generated automatically by gen_ref_data_spec_valid_address.py

        // BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4
        bytes memory hrp0 = bytes("bc");
        bytes memory address0 = bytes(
            "BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4"
        );
        bytes memory addressLowerExpected0 = bytes(
            "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"
        );
        uint8 expectedWitver0 = 0;
        bytes
            memory expectedWitprog0 = hex"751e76e8199196d454941c45d1b3a323f1433bd6";
        (
            uint8 actualWitver0,
            bytes memory actualWitprog0,
            Bech32m.DecodeError err0
        ) = Bech32m.decodeSegwitAddress(hrp0, address0);
        assertEq(
            expectedWitver0,
            actualWitver0,
            "incorrect witver after decoding address: 'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4'"
        );
        assertEq(
            expectedWitprog0,
            actualWitprog0,
            "incorrect witprog after decoding address: 'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4'"
        );
        assertTrue(
            err0 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4'"
        );
        bytes memory addrEncodedActual0 = Bech32m.encodeSegwitAddress(
            hrp0,
            actualWitver0,
            actualWitprog0
        );
        assertEq(
            addressLowerExpected0,
            addrEncodedActual0,
            "incorrect address after decoding and then encoding address: 'BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4'"
        );

        // tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7
        bytes memory hrp1 = bytes("tb");
        bytes memory address1 = bytes(
            "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7"
        );
        bytes memory addressLowerExpected1 = bytes(
            "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7"
        );
        uint8 expectedWitver1 = 0;
        bytes
            memory expectedWitprog1 = hex"1863143c14c5166804bd19203356da136c985678cd4d27a1b8c6329604903262";
        (
            uint8 actualWitver1,
            bytes memory actualWitprog1,
            Bech32m.DecodeError err1
        ) = Bech32m.decodeSegwitAddress(hrp1, address1);
        assertEq(
            expectedWitver1,
            actualWitver1,
            "incorrect witver after decoding address: 'tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7'"
        );
        assertEq(
            expectedWitprog1,
            actualWitprog1,
            "incorrect witprog after decoding address: 'tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7'"
        );
        assertTrue(
            err1 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7'"
        );
        bytes memory addrEncodedActual1 = Bech32m.encodeSegwitAddress(
            hrp1,
            actualWitver1,
            actualWitprog1
        );
        assertEq(
            addressLowerExpected1,
            addrEncodedActual1,
            "incorrect address after decoding and then encoding address: 'tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7'"
        );

        // bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y
        bytes memory hrp2 = bytes("bc");
        bytes memory address2 = bytes(
            "bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y"
        );
        bytes memory addressLowerExpected2 = bytes(
            "bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y"
        );
        uint8 expectedWitver2 = 1;
        bytes
            memory expectedWitprog2 = hex"751e76e8199196d454941c45d1b3a323f1433bd6751e76e8199196d454941c45d1b3a323f1433bd6";
        (
            uint8 actualWitver2,
            bytes memory actualWitprog2,
            Bech32m.DecodeError err2
        ) = Bech32m.decodeSegwitAddress(hrp2, address2);
        assertEq(
            expectedWitver2,
            actualWitver2,
            "incorrect witver after decoding address: 'bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y'"
        );
        assertEq(
            expectedWitprog2,
            actualWitprog2,
            "incorrect witprog after decoding address: 'bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y'"
        );
        assertTrue(
            err2 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y'"
        );
        bytes memory addrEncodedActual2 = Bech32m.encodeSegwitAddress(
            hrp2,
            actualWitver2,
            actualWitprog2
        );
        assertEq(
            addressLowerExpected2,
            addrEncodedActual2,
            "incorrect address after decoding and then encoding address: 'bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7kt5nd6y'"
        );

        // BC1SW50QGDZ25J
        bytes memory hrp3 = bytes("bc");
        bytes memory address3 = bytes("BC1SW50QGDZ25J");
        bytes memory addressLowerExpected3 = bytes("bc1sw50qgdz25j");
        uint8 expectedWitver3 = 16;
        bytes memory expectedWitprog3 = hex"751e";
        (
            uint8 actualWitver3,
            bytes memory actualWitprog3,
            Bech32m.DecodeError err3
        ) = Bech32m.decodeSegwitAddress(hrp3, address3);
        assertEq(
            expectedWitver3,
            actualWitver3,
            "incorrect witver after decoding address: 'BC1SW50QGDZ25J'"
        );
        assertEq(
            expectedWitprog3,
            actualWitprog3,
            "incorrect witprog after decoding address: 'BC1SW50QGDZ25J'"
        );
        assertTrue(
            err3 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'BC1SW50QGDZ25J'"
        );
        bytes memory addrEncodedActual3 = Bech32m.encodeSegwitAddress(
            hrp3,
            actualWitver3,
            actualWitprog3
        );
        assertEq(
            addressLowerExpected3,
            addrEncodedActual3,
            "incorrect address after decoding and then encoding address: 'BC1SW50QGDZ25J'"
        );

        // bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs
        bytes memory hrp4 = bytes("bc");
        bytes memory address4 = bytes("bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs");
        bytes memory addressLowerExpected4 = bytes(
            "bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs"
        );
        uint8 expectedWitver4 = 2;
        bytes memory expectedWitprog4 = hex"751e76e8199196d454941c45d1b3a323";
        (
            uint8 actualWitver4,
            bytes memory actualWitprog4,
            Bech32m.DecodeError err4
        ) = Bech32m.decodeSegwitAddress(hrp4, address4);
        assertEq(
            expectedWitver4,
            actualWitver4,
            "incorrect witver after decoding address: 'bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs'"
        );
        assertEq(
            expectedWitprog4,
            actualWitprog4,
            "incorrect witprog after decoding address: 'bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs'"
        );
        assertTrue(
            err4 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs'"
        );
        bytes memory addrEncodedActual4 = Bech32m.encodeSegwitAddress(
            hrp4,
            actualWitver4,
            actualWitprog4
        );
        assertEq(
            addressLowerExpected4,
            addrEncodedActual4,
            "incorrect address after decoding and then encoding address: 'bc1zw508d6qejxtdg4y5r3zarvaryvaxxpcs'"
        );

        // tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy
        bytes memory hrp5 = bytes("tb");
        bytes memory address5 = bytes(
            "tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy"
        );
        bytes memory addressLowerExpected5 = bytes(
            "tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy"
        );
        uint8 expectedWitver5 = 0;
        bytes
            memory expectedWitprog5 = hex"000000c4a5cad46221b2a187905e5266362b99d5e91c6ce24d165dab93e86433";
        (
            uint8 actualWitver5,
            bytes memory actualWitprog5,
            Bech32m.DecodeError err5
        ) = Bech32m.decodeSegwitAddress(hrp5, address5);
        assertEq(
            expectedWitver5,
            actualWitver5,
            "incorrect witver after decoding address: 'tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy'"
        );
        assertEq(
            expectedWitprog5,
            actualWitprog5,
            "incorrect witprog after decoding address: 'tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy'"
        );
        assertTrue(
            err5 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy'"
        );
        bytes memory addrEncodedActual5 = Bech32m.encodeSegwitAddress(
            hrp5,
            actualWitver5,
            actualWitprog5
        );
        assertEq(
            addressLowerExpected5,
            addrEncodedActual5,
            "incorrect address after decoding and then encoding address: 'tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy'"
        );

        // tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c
        bytes memory hrp6 = bytes("tb");
        bytes memory address6 = bytes(
            "tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c"
        );
        bytes memory addressLowerExpected6 = bytes(
            "tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c"
        );
        uint8 expectedWitver6 = 1;
        bytes
            memory expectedWitprog6 = hex"000000c4a5cad46221b2a187905e5266362b99d5e91c6ce24d165dab93e86433";
        (
            uint8 actualWitver6,
            bytes memory actualWitprog6,
            Bech32m.DecodeError err6
        ) = Bech32m.decodeSegwitAddress(hrp6, address6);
        assertEq(
            expectedWitver6,
            actualWitver6,
            "incorrect witver after decoding address: 'tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c'"
        );
        assertEq(
            expectedWitprog6,
            actualWitprog6,
            "incorrect witprog after decoding address: 'tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c'"
        );
        assertTrue(
            err6 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c'"
        );
        bytes memory addrEncodedActual6 = Bech32m.encodeSegwitAddress(
            hrp6,
            actualWitver6,
            actualWitprog6
        );
        assertEq(
            addressLowerExpected6,
            addrEncodedActual6,
            "incorrect address after decoding and then encoding address: 'tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c'"
        );

        // bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0
        bytes memory hrp7 = bytes("bc");
        bytes memory address7 = bytes(
            "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"
        );
        bytes memory addressLowerExpected7 = bytes(
            "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"
        );
        uint8 expectedWitver7 = 1;
        bytes
            memory expectedWitprog7 = hex"79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798";
        (
            uint8 actualWitver7,
            bytes memory actualWitprog7,
            Bech32m.DecodeError err7
        ) = Bech32m.decodeSegwitAddress(hrp7, address7);
        assertEq(
            expectedWitver7,
            actualWitver7,
            "incorrect witver after decoding address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0'"
        );
        assertEq(
            expectedWitprog7,
            actualWitprog7,
            "incorrect witprog after decoding address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0'"
        );
        assertTrue(
            err7 == Bech32m.DecodeError.NoError,
            "unexpected error decoding address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0'"
        );
        bytes memory addrEncodedActual7 = Bech32m.encodeSegwitAddress(
            hrp7,
            actualWitver7,
            actualWitprog7
        );
        assertEq(
            addressLowerExpected7,
            addrEncodedActual7,
            "incorrect address after decoding and then encoding address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0'"
        );
    }

    function testInvalidAddress() public pure {
        // tests from reference python implementation INVALID_ADDRESS for invalid segwit addresses
        // mostly generated automatically by gen_ref_data_spec_invalid_address.py
        // error codes and comments are added manually from comments in test.py and manual analysis

        // addr: tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut
        // hrp:  bc
        // Invalid HRP
        (
            uint8 actualWitver0,
            bytes memory actualWitprog0,
            Bech32m.DecodeError err0
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut"
                )
            );
        assertEq(
            0,
            actualWitver0,
            "returned witver should be 0 after decoding incorrect address: 'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog0,
            "returned witprog should be empty after decoding incorrect address: 'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut' with hrp: 'bc'"
        );
        assertTrue(
            err0 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut' with hrp: 'bc'"
        );

        // addr: tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver1,
            bytes memory actualWitprog1,
            Bech32m.DecodeError err1
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut"
                )
            );
        assertEq(
            0,
            actualWitver1,
            "returned witver should be 0 after decoding incorrect address: 'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog1,
            "returned witprog should be empty after decoding incorrect address: 'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut' with hrp: 'tb'"
        );
        assertTrue(
            err1 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut' with hrp: 'tb'"
        );

        // addr: bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd
        // hrp:  bc
        // Invalid checksum algorithm (bech32 instead of bech32m)
        (
            uint8 actualWitver2,
            bytes memory actualWitprog2,
            Bech32m.DecodeError err2
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd"
                )
            );
        assertEq(
            0,
            actualWitver2,
            "returned witver should be 0 after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog2,
            "returned witprog should be empty after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd' with hrp: 'bc'"
        );
        assertTrue(
            err2 == Bech32m.DecodeError.IncorrectEncodingForSegwitVn,
            "incorrect error code after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd' with hrp: 'bc'"
        );

        // addr: bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver3,
            bytes memory actualWitprog3,
            Bech32m.DecodeError err3
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd"
                )
            );
        assertEq(
            0,
            actualWitver3,
            "returned witver should be 0 after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog3,
            "returned witprog should be empty after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd' with hrp: 'tb'"
        );
        assertTrue(
            err3 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd' with hrp: 'tb'"
        );

        // addr: tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf
        // hrp:  bc
        // Invalid HRP
        (
            uint8 actualWitver4,
            bytes memory actualWitprog4,
            Bech32m.DecodeError err4
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf"
                )
            );
        assertEq(
            0,
            actualWitver4,
            "returned witver should be 0 after decoding incorrect address: 'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog4,
            "returned witprog should be empty after decoding incorrect address: 'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf' with hrp: 'bc'"
        );
        assertTrue(
            err4 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf' with hrp: 'bc'"
        );

        // addr: tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf
        // hrp:  tb
        // Invalid checksum algorithm (bech32 instead of bech32m)
        (
            uint8 actualWitver5,
            bytes memory actualWitprog5,
            Bech32m.DecodeError err5
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf"
                )
            );
        assertEq(
            0,
            actualWitver5,
            "returned witver should be 0 after decoding incorrect address: 'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog5,
            "returned witprog should be empty after decoding incorrect address: 'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf' with hrp: 'tb'"
        );
        assertTrue(
            err5 == Bech32m.DecodeError.IncorrectEncodingForSegwitVn,
            "incorrect error code after decoding incorrect address: 'tb1z0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqglt7rf' with hrp: 'tb'"
        );

        // addr: BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL
        // hrp:  bc
        // Invalid checksum algorithm (bech32 instead of bech32m)
        (
            uint8 actualWitver6,
            bytes memory actualWitprog6,
            Bech32m.DecodeError err6
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL"
                )
            );
        assertEq(
            0,
            actualWitver6,
            "returned witver should be 0 after decoding incorrect address: 'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog6,
            "returned witprog should be empty after decoding incorrect address: 'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL' with hrp: 'bc'"
        );
        assertTrue(
            err6 == Bech32m.DecodeError.IncorrectEncodingForSegwitVn,
            "incorrect error code after decoding incorrect address: 'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL' with hrp: 'bc'"
        );

        // addr: BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver7,
            bytes memory actualWitprog7,
            Bech32m.DecodeError err7
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL"
                )
            );
        assertEq(
            0,
            actualWitver7,
            "returned witver should be 0 after decoding incorrect address: 'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog7,
            "returned witprog should be empty after decoding incorrect address: 'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL' with hrp: 'tb'"
        );
        assertTrue(
            err7 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL' with hrp: 'tb'"
        );

        // addr: bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh
        // hrp:  bc
        // Invalid checksum algorithm (bech32m instead of bech32)
        (
            uint8 actualWitver8,
            bytes memory actualWitprog8,
            Bech32m.DecodeError err8
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh")
            );
        assertEq(
            0,
            actualWitver8,
            "returned witver should be 0 after decoding incorrect address: 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog8,
            "returned witprog should be empty after decoding incorrect address: 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh' with hrp: 'bc'"
        );
        assertTrue(
            err8 == Bech32m.DecodeError.IncorrectEncodingForSegwitV0,
            "incorrect error code after decoding incorrect address: 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh' with hrp: 'bc'"
        );

        // addr: bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver9,
            bytes memory actualWitprog9,
            Bech32m.DecodeError err9
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh")
            );
        assertEq(
            0,
            actualWitver9,
            "returned witver should be 0 after decoding incorrect address: 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog9,
            "returned witprog should be empty after decoding incorrect address: 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh' with hrp: 'tb'"
        );
        assertTrue(
            err9 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kemeawh' with hrp: 'tb'"
        );

        // addr: tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47
        // hrp:  bc
        // Invalid HRP
        (
            uint8 actualWitver10,
            bytes memory actualWitprog10,
            Bech32m.DecodeError err10
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47"
                )
            );
        assertEq(
            0,
            actualWitver10,
            "returned witver should be 0 after decoding incorrect address: 'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog10,
            "returned witprog should be empty after decoding incorrect address: 'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47' with hrp: 'bc'"
        );
        assertTrue(
            err10 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47' with hrp: 'bc'"
        );

        // addr: tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47
        // hrp:  tb
        // Invalid checksum algorithm (bech32m instead of bech32)
        (
            uint8 actualWitver11,
            bytes memory actualWitprog11,
            Bech32m.DecodeError err11
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47"
                )
            );
        assertEq(
            0,
            actualWitver11,
            "returned witver should be 0 after decoding incorrect address: 'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog11,
            "returned witprog should be empty after decoding incorrect address: 'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47' with hrp: 'tb'"
        );
        assertTrue(
            err11 == Bech32m.DecodeError.IncorrectEncodingForSegwitV0,
            "incorrect error code after decoding incorrect address: 'tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47' with hrp: 'tb'"
        );

        // addr: bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4
        // hrp:  bc
        // Invalid character in checksum
        (
            uint8 actualWitver12,
            bytes memory actualWitprog12,
            Bech32m.DecodeError err12
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4"
                )
            );
        assertEq(
            0,
            actualWitver12,
            "returned witver should be 0 after decoding incorrect address: 'bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog12,
            "returned witprog should be empty after decoding incorrect address: 'bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4' with hrp: 'bc'"
        );
        assertTrue(
            err12 == Bech32m.DecodeError.NotBech32Character,
            "incorrect error code after decoding incorrect address: 'bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4' with hrp: 'bc'"
        );

        // addr: bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4
        // hrp:  tb
        // Invalid character in checksum
        (
            uint8 actualWitver13,
            bytes memory actualWitprog13,
            Bech32m.DecodeError err13
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4"
                )
            );
        assertEq(
            0,
            actualWitver13,
            "returned witver should be 0 after decoding incorrect address: 'bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog13,
            "returned witprog should be empty after decoding incorrect address: 'bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4' with hrp: 'tb'"
        );
        assertTrue(
            err13 == Bech32m.DecodeError.NotBech32Character,
            "incorrect error code after decoding incorrect address: 'bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4' with hrp: 'tb'"
        );

        // addr: BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R
        // hrp:  bc
        // Invalid witness version
        (
            uint8 actualWitver14,
            bytes memory actualWitprog14,
            Bech32m.DecodeError err14
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R"
                )
            );
        assertEq(
            0,
            actualWitver14,
            "returned witver should be 0 after decoding incorrect address: 'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog14,
            "returned witprog should be empty after decoding incorrect address: 'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R' with hrp: 'bc'"
        );
        assertTrue(
            err14 == Bech32m.DecodeError.SegwitVersionTooLarge,
            "incorrect error code after decoding incorrect address: 'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R' with hrp: 'bc'"
        );

        // addr: BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver15,
            bytes memory actualWitprog15,
            Bech32m.DecodeError err15
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R"
                )
            );
        assertEq(
            0,
            actualWitver15,
            "returned witver should be 0 after decoding incorrect address: 'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog15,
            "returned witprog should be empty after decoding incorrect address: 'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R' with hrp: 'tb'"
        );
        assertTrue(
            err15 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R' with hrp: 'tb'"
        );

        // addr: bc1pw5dgrnzv
        // hrp:  bc
        // Invalid program length (1 byte)
        (
            uint8 actualWitver16,
            bytes memory actualWitprog16,
            Bech32m.DecodeError err16
        ) = Bech32m.decodeSegwitAddress(bytes("bc"), bytes("bc1pw5dgrnzv"));
        assertEq(
            0,
            actualWitver16,
            "returned witver should be 0 after decoding incorrect address: 'bc1pw5dgrnzv' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog16,
            "returned witprog should be empty after decoding incorrect address: 'bc1pw5dgrnzv' with hrp: 'bc'"
        );
        assertTrue(
            err16 == Bech32m.DecodeError.WitnessProgramTooSmall,
            "incorrect error code after decoding incorrect address: 'bc1pw5dgrnzv' with hrp: 'bc'"
        );

        // addr: bc1pw5dgrnzv
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver17,
            bytes memory actualWitprog17,
            Bech32m.DecodeError err17
        ) = Bech32m.decodeSegwitAddress(bytes("tb"), bytes("bc1pw5dgrnzv"));
        assertEq(
            0,
            actualWitver17,
            "returned witver should be 0 after decoding incorrect address: 'bc1pw5dgrnzv' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog17,
            "returned witprog should be empty after decoding incorrect address: 'bc1pw5dgrnzv' with hrp: 'tb'"
        );
        assertTrue(
            err17 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'bc1pw5dgrnzv' with hrp: 'tb'"
        );

        // addr: bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav
        // hrp:  bc
        // Invalid program length (41 bytes)
        (
            uint8 actualWitver18,
            bytes memory actualWitprog18,
            Bech32m.DecodeError err18
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav"
                )
            );
        assertEq(
            0,
            actualWitver18,
            "returned witver should be 0 after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog18,
            "returned witprog should be empty after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav' with hrp: 'bc'"
        );
        assertTrue(
            err18 == Bech32m.DecodeError.WitnessProgramTooLarge,
            "incorrect error code after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav' with hrp: 'bc'"
        );

        // addr: bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver19,
            bytes memory actualWitprog19,
            Bech32m.DecodeError err19
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav"
                )
            );
        assertEq(
            0,
            actualWitver19,
            "returned witver should be 0 after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog19,
            "returned witprog should be empty after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav' with hrp: 'tb'"
        );
        assertTrue(
            err19 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav' with hrp: 'tb'"
        );

        // addr: BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P
        // hrp:  bc
        // Invalid program length for witness version 0 (per BIP141)
        (
            uint8 actualWitver20,
            bytes memory actualWitprog20,
            Bech32m.DecodeError err20
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes("BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P")
            );
        assertEq(
            0,
            actualWitver20,
            "returned witver should be 0 after decoding incorrect address: 'BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog20,
            "returned witprog should be empty after decoding incorrect address: 'BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P' with hrp: 'bc'"
        );
        assertTrue(
            err20 == Bech32m.DecodeError.IncorrectSegwitV0Program,
            "incorrect error code after decoding incorrect address: 'BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P' with hrp: 'bc'"
        );

        // addr: BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver21,
            bytes memory actualWitprog21,
            Bech32m.DecodeError err21
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes("BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P")
            );
        assertEq(
            0,
            actualWitver21,
            "returned witver should be 0 after decoding incorrect address: 'BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog21,
            "returned witprog should be empty after decoding incorrect address: 'BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P' with hrp: 'tb'"
        );
        assertTrue(
            err21 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'BC1QR508D6QEJXTDG4Y5R3ZARVARYV98GJ9P' with hrp: 'tb'"
        );

        // addr: tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq
        // hrp:  bc
        // Mixed case
        (
            uint8 actualWitver22,
            bytes memory actualWitprog22,
            Bech32m.DecodeError err22
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq"
                )
            );
        assertEq(
            0,
            actualWitver22,
            "returned witver should be 0 after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog22,
            "returned witprog should be empty after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq' with hrp: 'bc'"
        );
        assertTrue(
            err22 == Bech32m.DecodeError.MixedCase,
            "incorrect error code after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq' with hrp: 'bc'"
        );

        // addr: tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq
        // hrp:  tb
        // Mixed case
        (
            uint8 actualWitver23,
            bytes memory actualWitprog23,
            Bech32m.DecodeError err23
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq"
                )
            );
        assertEq(
            0,
            actualWitver23,
            "returned witver should be 0 after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog23,
            "returned witprog should be empty after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq' with hrp: 'tb'"
        );
        assertTrue(
            err23 == Bech32m.DecodeError.MixedCase,
            "incorrect error code after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq' with hrp: 'tb'"
        );

        // addr: bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf
        // hrp:  bc
        // More than 4 padding bits
        (
            uint8 actualWitver24,
            bytes memory actualWitprog24,
            Bech32m.DecodeError err24
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf"
                )
            );
        assertEq(
            0,
            actualWitver24,
            "returned witver should be 0 after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog24,
            "returned witprog should be empty after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf' with hrp: 'bc'"
        );
        assertTrue(
            err24 == Bech32m.DecodeError.IncorrectLength,
            "incorrect error code after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf' with hrp: 'bc'"
        );

        // addr: bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver25,
            bytes memory actualWitprog25,
            Bech32m.DecodeError err25
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf"
                )
            );
        assertEq(
            0,
            actualWitver25,
            "returned witver should be 0 after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog25,
            "returned witprog should be empty after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf' with hrp: 'tb'"
        );
        assertTrue(
            err25 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf' with hrp: 'tb'"
        );

        // addr: tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j
        // hrp:  bc
        // Invalid HRP
        (
            uint8 actualWitver26,
            bytes memory actualWitprog26,
            Bech32m.DecodeError err26
        ) = Bech32m.decodeSegwitAddress(
                bytes("bc"),
                bytes(
                    "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j"
                )
            );
        assertEq(
            0,
            actualWitver26,
            "returned witver should be 0 after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog26,
            "returned witprog should be empty after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j' with hrp: 'bc'"
        );
        assertTrue(
            err26 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j' with hrp: 'bc'"
        );

        // addr: tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j
        // hrp:  tb
        // Non-zero padding in 8-to-5 conversion
        (
            uint8 actualWitver27,
            bytes memory actualWitprog27,
            Bech32m.DecodeError err27
        ) = Bech32m.decodeSegwitAddress(
                bytes("tb"),
                bytes(
                    "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j"
                )
            );
        assertEq(
            0,
            actualWitver27,
            "returned witver should be 0 after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog27,
            "returned witprog should be empty after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j' with hrp: 'tb'"
        );
        assertTrue(
            err27 == Bech32m.DecodeError.IncorrectPadding,
            "incorrect error code after decoding incorrect address: 'tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j' with hrp: 'tb'"
        );

        // addr: bc1gmk9yu
        // hrp:  bc
        // Empty data section
        (
            uint8 actualWitver28,
            bytes memory actualWitprog28,
            Bech32m.DecodeError err28
        ) = Bech32m.decodeSegwitAddress(bytes("bc"), bytes("bc1gmk9yu"));
        assertEq(
            0,
            actualWitver28,
            "returned witver should be 0 after decoding incorrect address: 'bc1gmk9yu' with hrp: 'bc'"
        );
        assertEq(
            hex"",
            actualWitprog28,
            "returned witprog should be empty after decoding incorrect address: 'bc1gmk9yu' with hrp: 'bc'"
        );
        assertTrue(
            err28 == Bech32m.DecodeError.EmptyData,
            "incorrect error code after decoding incorrect address: 'bc1gmk9yu' with hrp: 'bc'"
        );

        // addr: bc1gmk9yu
        // hrp:  tb
        // Invalid HRP
        (
            uint8 actualWitver29,
            bytes memory actualWitprog29,
            Bech32m.DecodeError err29
        ) = Bech32m.decodeSegwitAddress(bytes("tb"), bytes("bc1gmk9yu"));
        assertEq(
            0,
            actualWitver29,
            "returned witver should be 0 after decoding incorrect address: 'bc1gmk9yu' with hrp: 'tb'"
        );
        assertEq(
            hex"",
            actualWitprog29,
            "returned witprog should be empty after decoding incorrect address: 'bc1gmk9yu' with hrp: 'tb'"
        );
        assertTrue(
            err29 == Bech32m.DecodeError.HRPMismatch,
            "incorrect error code after decoding incorrect address: 'bc1gmk9yu' with hrp: 'tb'"
        );
    }
}
