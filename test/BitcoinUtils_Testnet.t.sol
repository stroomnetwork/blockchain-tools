// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Testnet_Test is Test {
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Testnet;
    BitcoinUtils private utils = new BitcoinUtils();

    function testValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "2NByiBUaEXrhmqAsg7BbLpcQSAQs1EDwt5w"));
        assertTrue(utils.validateBitcoinAddress(network, "mrCDrCybB6J1vRfbwM5hemdJz73FwDBC8r"));
        assertTrue(utils.validateBitcoinAddress(network, "2NFPLS6TQVVvic6Nh85PGfcYesbGdm1fjpo"));
    }

    function testInvalidAddress() public {
        assertFalse(utils.validateBitcoinAddress(network, ""));
        assertFalse(utils.validateBitcoinAddress(network, "7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(utils.validateBitcoinAddress(network, "j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx"));
        assertTrue(utils.validateBitcoinAddress(network, "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7"));
    }

    function testBech32ValidMainnetAddressIsNotValidForTestnet() public {
        assertFalse(utils.validateBitcoinAddress(network, "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertFalse(utils.validateBitcoinAddress(network, "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }
}
