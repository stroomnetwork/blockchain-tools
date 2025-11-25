// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import "forge-std/Test.sol";

import "../src/BitcoinUtils.sol";
import "../src/BitcoinNetworkEncoder.sol";

// See also https://en.bitcoin.it/wiki/List_of_address_prefixes

contract BitcoinUtils_Simnet_Test is Test {
    using BitcoinUtils for BitcoinNetworkEncoder.Network; 
    BitcoinNetworkEncoder.Network private network = BitcoinNetworkEncoder.Network.Simnet;

    // Helper function to convert memory to calldata
    function _validate(string memory addr) private view returns (bool) {
        return this._validateCalldata(addr);
    }
    
    function _validateCalldata(string calldata addr) external view returns (bool) {
        return network.validateBitcoinAddress(addr);
    }

    function testValidAddress() public view {
        assertTrue(_validate("ScuV2eqXfQCPcpxqqVSFtMVwkfqcwnQKB1"));
        assertTrue(_validate("SYi7rot5GKoyuRNUnjrfKYRBL7F4e9L8bN"));
    }

    function testInvalidAddress() public view {
        assertFalse(_validate(""));
        assertFalse(_validate("7SeEnXWPaCCALbVrTnszCVGfRU8cGfx"));
        assertFalse(_validate("j9ywUkWg2fTQrouxxh5rSZhRvrjMkEUfuiKe"));
    }

    function testBech32ValidAddress() public view {
        assertTrue(_validate("sb1p5z8wl5tu7m0d79vzqqsl9gu0x4fkjug857fusx4fl4kfgwh5j25sxv5dv3"));
        assertTrue(_validate("sb1pfusykjdt46ktwq03d20uqqf94uh9487344wr3q5v9szzsxnjdfkszvtlt8"));
    }

    function testBech32ValidMainnetAddressIsNotValidForTestnet() public view {
        assertFalse(_validate("bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"));
        assertFalse(_validate("bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4"));
    }
}
