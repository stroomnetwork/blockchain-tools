// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Mainnet_Test is Test {
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Mainnet;
    BitcoinUtils private utils = new BitcoinUtils();

    function testValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "1BgGZ9tcN4rm9KBzDn7KprQz87SZ26SAMH"));
        assertTrue(utils.validateBitcoinAddress(network, "15hPYnf4qXCbDBi96DsUPdZ34RyZ5Lou1a"));
    }

    function testInvalidAddress() public {
        assertFalse(utils.validateBitcoinAddress(network, ""));
        assertFalse(utils.validateBitcoinAddress(network, "7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(utils.validateBitcoinAddress(network, "j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public {
        assertTrue(utils.validateBitcoinAddress(network, "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertTrue(utils.validateBitcoinAddress(network, "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }

    function testBech32InvalidAddress() public {
        assertFalse(utils.validateBitcoinAddress(network, "BC1SW50QA3JX3S"));

        // wrong encoding
        assertFalse(utils.validateBitcoinAddress(network, "bc1zw508d6qejxtdg4y5r3zarvaryvqyzf3du"));

        // invalid checksum
        assertFalse(utils.validateBitcoinAddress(network, "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t5"));

        assertFalse(utils.validateBitcoinAddress(network, "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sL5k7"));

        assertFalse(utils.validateBitcoinAddress(network, "tb1pw508d6qejxtdg4y5r3zarquvzkan"));
    }
}
