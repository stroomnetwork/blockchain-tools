// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {Hmac} from "../src/Hmac.sol";

contract HmacSha512Test is Test {
    function testHmacSha512() public pure {
        // This test was generated automatically by gen_ref_data_hmac_sha512.py

        bytes memory key0 = hex"010203";
        bytes memory message0 = hex"040506";
        bytes32 hmac0_1_expected = hex"d397d5a94c4f9b1ad5bd483f38d382c965c89e8129c2998d7202c530bf492c60";
        bytes32 hmac0_2_expected = hex"a14ee3202d4bbab087dc9af4aacaede0f4b32dfdfc707756a12a7a750b79b5eb";
        (bytes32 hmac0_1, bytes32 hmac0_2) = Hmac.hmacSha512(key0, message0);
        assertEq(hmac0_1, hmac0_1_expected);
        assertEq(hmac0_2, hmac0_2_expected);

        bytes
            memory key1 = hex"0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101";
        bytes memory message1 = hex"04";
        bytes32 hmac1_1_expected = hex"c68f8756a0235a67f4f3a1c563025bc6c84389ffb80e4fe3a77344b14104c6d9";
        bytes32 hmac1_2_expected = hex"7816a5522ce5c018d8ef7e8133eaa98579690f49d7e38038fbf13ce51898300e";
        (bytes32 hmac1_1, bytes32 hmac1_2) = Hmac.hmacSha512(key1, message1);
        assertEq(hmac1_1, hmac1_1_expected);
        assertEq(hmac1_2, hmac1_2_expected);

        bytes
            memory key2 = hex"010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101";
        bytes memory message2 = hex"04";
        bytes32 hmac2_1_expected = hex"4440366771063083654ba2bc822768a9e16210b9443910c77a6fb5ef4978c0a9";
        bytes32 hmac2_2_expected = hex"4c4cbf7bf68e3cd18acb16e3c98bdf6be1efdcb2519ee9c4d66eb8f92eac5838";
        (bytes32 hmac2_1, bytes32 hmac2_2) = Hmac.hmacSha512(key2, message2);
        assertEq(hmac2_1, hmac2_1_expected);
        assertEq(hmac2_2, hmac2_2_expected);
    }
}
