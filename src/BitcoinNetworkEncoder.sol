// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

library BitcoinNetworkEncoder {

    bytes constant BTC_BECH32_MAINNET_BYTES = hex"626331"; // prefix = bc1
    bytes constant BTC_BECH32_TESTNET_BYTES = hex"746231"; // prefix = tb1
    bytes constant BTC_BECH32_REGTEST_BYTES = hex"6263727431"; // prefix = bcrt1
    bytes constant BTC_BECH32_SIMNET_BYTES = hex"736231"; // prefix = sb1

    string constant BTC_BECH32_MAINNET = 'bc';
    string constant BTC_BECH32_TESTNET = 'tb';
    string constant BTC_BECH32_REGTEST = 'brct';
    string constant BTC_BECH32_SIMNET = 'sb';

    //NB: don't forget to update `lnbtc_ext.go` when changing this enum!
    enum Network {
        Mainnet,
        Testnet,
        Regtest,
        Simnet
    }

    function getBtcBech32Prefix(Network _network) internal pure returns (bytes memory) {
        if (_network == Network.Mainnet) {
            return BTC_BECH32_MAINNET_BYTES;
        } else if (_network == Network.Regtest) {
            return BTC_BECH32_REGTEST_BYTES;
        } else if (_network == Network.Testnet) {
            return BTC_BECH32_TESTNET_BYTES;
        } else if (_network == Network.Simnet) {
            return BTC_BECH32_SIMNET_BYTES;
        } else {
            revert("Unknown network type");
        }
    }

    function getNetworkPrefix(Network _network) internal pure returns (string memory) {
        if (_network == Network.Mainnet) {
            return BTC_BECH32_MAINNET;
        } else if (_network == Network.Testnet) {
            return BTC_BECH32_TESTNET;
        } else if (_network == Network.Regtest) {
            return BTC_BECH32_REGTEST;
        } else if (_network == Network.Simnet) {
            return BTC_BECH32_SIMNET;
        } else {
            revert("Unknown network type");
        }
    }


}