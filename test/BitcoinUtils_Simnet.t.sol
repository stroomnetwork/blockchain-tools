// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Testnet_Test is Test {
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Simnet;
    BitcoinUtils private utils = new BitcoinUtils();


    function testValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "ScuV2eqXfQCPcpxqqVSFtMVwkfqcwnQKB1"));
        assertTrue(utils.validateBitcoinAddress(network, "SYi7rot5GKoyuRNUnjrfKYRBL7F4e9L8bN"));
    }

    function testInvalidAddress() public {
        assertFalse(utils.validateBitcoinAddress(network, ""));
        assertFalse(utils.validateBitcoinAddress(network, "7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(utils.validateBitcoinAddress(network, "j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "sb1p5z8wl5tu7m0d79vzqqsl9gu0x4fkjug857fusx4fl4kfgwh5j25sxv5dv3"));
        assertTrue(utils.validateBitcoinAddress(network, "sb1pfusykjdt46ktwq03d20uqqf94uh9487344wr3q5v9szzsxnjdfkszvtlt8"));
    }

    function testBech32ValidMainnetAddressIsNotValidForTestnet() public {
        assertFalse(utils.validateBitcoinAddress(network, "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertFalse(utils.validateBitcoinAddress(network, "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }
}
