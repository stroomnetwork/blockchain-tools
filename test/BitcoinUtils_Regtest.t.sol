// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Regtest_Test is Test {
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Regtest;
    BitcoinUtils private utils = new BitcoinUtils();

    function testValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "2NByiBUaEXrhmqAsg7BbLpcQSAQs1EDwt5w"));
        assertTrue(utils.validateBitcoinAddress(network, "mrCDrCybB6J1vRfbwM5hemdJz73FwDBC8r"));
    }

    function testInvalidAddress() public {
        assertFalse(utils.validateBitcoinAddress(network, ""));
        assertFalse(utils.validateBitcoinAddress(network, "7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(utils.validateBitcoinAddress(network, "j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "bcrt1qnd2xm45v0uy5nx3qzt28qrhq42w4udrms8sz52"));
    }

    function testBech32ValidMainnetAddressIsNotValidForRegtest() public {
        assertFalse(utils.validateBitcoinAddress(network, "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertFalse(utils.validateBitcoinAddress(network, "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }
}
