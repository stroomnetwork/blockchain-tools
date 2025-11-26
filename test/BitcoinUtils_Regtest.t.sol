// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Regtest_Test is Test {
    using BitcoinUtils for BitcoinNetworkEncoder.Network; 
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Regtest;

    // Helper function to convert memory to calldata
    function _validate(string memory addr) private view returns (bool) {
        return this._validateCalldata(addr);
    }
    
    function _validateCalldata(string calldata addr) external view returns (bool) {
        return network.validateBitcoinAddress(addr);
    }

    function testValidAddress() public view {
        assertTrue(_validate("2NByiBUaEXrhmqAsg7BbLpcQSAQs1EDwt5w"));
        assertTrue(_validate("mrCDrCybB6J1vRfbwM5hemdJz73FwDBC8r"));
    }

    function testInvalidAddress() public view {
        assertFalse(_validate(""));
        assertFalse(_validate("7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(_validate("j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public view {
        assertTrue(_validate("bcrt1qnd2xm45v0uy5nx3qzt28qrhq42w4udrms8sz52"));
        assertTrue(_validate("bcrt1pnmrmugapastum8ztvgwcn8hvq2avmcwh2j4ssru7rtyygkpqq98q4wyd6s"));
    }

    function testBech32ValidMainnetAddressIsNotValidForRegtest() public view {
        assertFalse(_validate("bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertFalse(_validate("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }
}
