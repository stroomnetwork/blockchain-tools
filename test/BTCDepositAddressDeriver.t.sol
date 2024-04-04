// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";

contract BTCDepositAddressDeriverTest is Test {
    BTCDepositAddressDeriver deriver;

    // Due to a bug/feature of Solidity, it is impossible to import events from other contract.abi
    // https://github.com/ethereum/solidity/issues/13928
    // It is copy-pasted here from src/BTCDepositAddressDeriver.sol
    event SeedChanged(string btcAddr1, string btcAddr2, string hrp); 

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

    function testSetSeed() public {
        assertEq(deriver.wasSeedSet(), false);
        assertEq(deriver.btcAddr1(), "");
        assertEq(deriver.btcAddr2(), "");
        assertEq(deriver.networkHrp(), "");
        assertEq(deriver.p1x(), 0);
        assertEq(deriver.p1y(), 0);
        assertEq(deriver.p2x(), 0);
        assertEq(deriver.p2y(), 0);

        vm.expectEmit(address(deriver));
        emit SeedChanged(
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz",
            "tb"
        );
        deriver.setSeed(
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz",
            "tb"
        );

        assertEq(deriver.wasSeedSet(), true);
        assertEq(
            deriver.btcAddr1(),
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3"
        );
        assertEq(
            deriver.btcAddr2(),
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz"
        );
        assertEq(deriver.networkHrp(), "tb");
        assertEq(
            deriver.p1x(),
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A
        );
        assertEq(
            deriver.p1y(),
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0
        );
        assertEq(
            deriver.p2x(),
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC
        );
        assertEq(
            deriver.p2y(),
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C
        );
    }
}
