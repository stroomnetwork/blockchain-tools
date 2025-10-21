// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {Sha2Ext} from "../src/sha2/Sha2Ext.sol";

contract Sha512Test is Test {
    function testSha512() public pure {
        // This test was generated automatically by gen_ref_data_sha512.py

        bytes memory data0 = hex"";
        bytes32 hash0_1_expected = hex"cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce";
        bytes32 hash0_2_expected = hex"47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e";
        (bytes32 hash0_1, bytes32 hash0_2) = Sha2Ext.sha512(data0);
        assertEq(hash0_1, hash0_1_expected);
        assertEq(hash0_2, hash0_2_expected);

        bytes memory data1 = hex"010203";
        bytes32 hash1_1_expected = hex"27864cc5219a951a7a6e52b8c8dddf6981d098da1658d96258c870b2c88dfbcb";
        bytes32 hash1_2_expected = hex"51841aea172a28bafa6a79731165584677066045c959ed0f9929688d04defc29";
        (bytes32 hash1_1, bytes32 hash1_2) = Sha2Ext.sha512(data1);
        assertEq(hash1_1, hash1_1_expected);
        assertEq(hash1_2, hash1_2_expected);

        bytes
            memory data2 = hex"abababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababababab";
        bytes32 hash2_1_expected = hex"fd805b4f843ccb741c22186ed4f6f0f12dafc2e6a330458fe84f9ecf1ad1a17c";
        bytes32 hash2_2_expected = hex"a24489d6ae63662bc29f507bd00882573473ccc660ff05f818fe6a720632abfc";
        (bytes32 hash2_1, bytes32 hash2_2) = Sha2Ext.sha512(data2);
        assertEq(hash2_1, hash2_1_expected);
        assertEq(hash2_2, hash2_2_expected);
    }
}
