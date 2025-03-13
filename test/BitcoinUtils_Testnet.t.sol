// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Testnet_Test is Test {
    using BitcoinUtils for BitcoinNetworkEncoder.Network; 
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Testnet;

    function testValidAddress() public view {
        assertTrue(network.validateBitcoinAddress("2NByiBUaEXrhmqAsg7BbLpcQSAQs1EDwt5w"));
        assertTrue(network.validateBitcoinAddress("mrCDrCybB6J1vRfbwM5hemdJz73FwDBC8r"));
        assertTrue(network.validateBitcoinAddress("2NFPLS6TQVVvic6Nh85PGfcYesbGdm1fjpo"));
    }

    function testInvalidAddress() public view {
        assertFalse(network.validateBitcoinAddress(""));
        assertFalse(network.validateBitcoinAddress("7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(network.validateBitcoinAddress("j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public view {
        assertTrue(network.validateBitcoinAddress("tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx"));
        assertTrue(network.validateBitcoinAddress("tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7"));
    }

    function testBech32ValidMainnetAddressIsNotValidForTestnet() public view {
        assertFalse(network.validateBitcoinAddress("bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertFalse(network.validateBitcoinAddress("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }
}
