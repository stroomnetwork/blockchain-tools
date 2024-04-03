// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";

contract BTCDepositAddressDeriverTest is Test {
    BTCDepositAddressDeriver deriver;

    function setUp() public {
        deriver = new BTCDepositAddressDeriver();
    }

    function testParseBTCTaprootAddress1() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3"
        );
        assertEq(
            x,
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A
        );
        assertEq(
            y,
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0
        );
    }

    function testParseBTCTaprootAddress2() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz"
        );
        assertEq(
            x,
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC
        );
        assertEq(
            y,
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C
        );
    }
}
