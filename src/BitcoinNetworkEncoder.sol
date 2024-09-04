// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

library BitcoinNetworkEncoder {

    bytes constant BTC_BECH32_MAINNET_BYTES = hex"626331"; // prefix = bc1
    bytes constant BTC_BECH32_TESTNET_BYTES = hex"746231"; // prefix = tb1
    bytes constant BTC_BECH32_REGTEST_BYTES = hex"6263727431"; // prefix = bcrt1
    bytes constant BTC_BECH32_SIMNET_BYTES = hex"736231"; // prefix = sb1

    string constant BTC_BECH32_MAINNET = 'bc';
    string constant BTC_BECH32_TESTNET = 'tb';
    string constant BTC_BECH32_REGTEST = 'bcrt';
    string constant BTC_BECH32_SIMNET = 'sb';

    bytes constant BTC_P2PKH_MAINNET = hex"31"; // prefix = 1
    bytes constant BTC_P2SH_MAINNET = hex"33"; // prefix = 3
    bytes constant BTC_P2PKH_TESTNET = hex"32"; // prefix = 2
    bytes constant BTC_P2SH_TESTNET = hex"6d"; // prefix = m
    bytes constant BTC_P2PKH_REGTEST = hex"32"; // prefix = 2
    bytes constant BTC_P2SH_REGTEST = hex"6d"; // prefix = m
    bytes constant BTC_P2PKH_SIMNET = hex"53"; // prefix = S
    bytes constant BTC_P2SH_SIMNET = hex"73"; // prefix = s

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

    function getBtcBase58_P2PKH(BitcoinNetworkEncoder.Network network) internal pure returns (bytes memory) {
        if (network == BitcoinNetworkEncoder.Network.Mainnet) {
            return BTC_P2PKH_MAINNET;
        } else if (network == BitcoinNetworkEncoder.Network.Regtest) {
            return BTC_P2PKH_REGTEST;
        } else if (network == BitcoinNetworkEncoder.Network.Testnet) {
            return BTC_P2PKH_TESTNET;
        } else if (network == BitcoinNetworkEncoder.Network.Simnet) {
            return BTC_P2PKH_SIMNET;
        } else {
            revert("Unknown network type");
        }
    }

    function getBtcBase58_P2SH(BitcoinNetworkEncoder.Network network) internal pure returns (bytes memory) {
        if (network == BitcoinNetworkEncoder.Network.Mainnet) {
            return BTC_P2SH_MAINNET;
        } else if (network == BitcoinNetworkEncoder.Network.Regtest) {
            return BTC_P2SH_REGTEST;
        } else if (network == BitcoinNetworkEncoder.Network.Testnet) {
            return BTC_P2SH_TESTNET;
        } else if (network == BitcoinNetworkEncoder.Network.Simnet) {
            return BTC_P2SH_SIMNET;
        } else {
            revert("Unknown network type");
        }
    }
}
