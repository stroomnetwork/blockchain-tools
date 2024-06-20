// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";

contract BTCDepositAddressDeriverTest is Test {
    // We declare event SeedChanged second time here because Solidity
    // does not allow importing events from other contracts.
    // https://ethereum.stackexchange.com/questions/52967/can-a-contract-emit-another-contracts-event
    event SeedChanged(string btcAddr1, string btcAddr2, string hrp);

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
            BTCDepositAddressDeriver.BitcoinNetwork.TESTNET
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

    function testGetBTCDepositAddress() public {
        deriver.setSeed(
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz",
            BTCDepositAddressDeriver.BitcoinNetwork.TESTNET
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x1EaCa1277BcDFa83E60658D8938B3D63cD3E63C1
        );
        assertEq(
            btcAddress,
            "tb1pz66m5qeqae7mlqjwwz3hhf8lfz05w53djxxxzzjy47m6hej6cg8s0zs83c"
        );
    }

    function testGetBTCDepositAddress2() public {
        deriver.setSeed(
            "tb1p5z8wl5tu7m0d79vzqqsl9gu0x4fkjug857fusx4fl4kfgwh5j25spa7245",
            "tb1pfusykjdt46ktwq03d20uqqf94uh9487344wr3q5v9szzsxnjdfks9apcjz",
            BTCDepositAddressDeriver.BitcoinNetwork(0)
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x1EaCa1277BcDFa83E60658D8938B3D63cD3E63C1
        );
        console.log("btcAddress", btcAddress);
        assertEq(
            btcAddress,
            "tb1phuqvamwdq7ynnydpc93h3sa9qhk9kntadg5vecgph38357jrlq5sqymks5"
        );
        // assertEq(
        //     btcAddress,
        //     "tb1pz66m5qeqae7mlqjwwz3hhf8lfz05w53djxxxzzjy47m6hej6cg8s0zs83c"
        // );
    }
}
