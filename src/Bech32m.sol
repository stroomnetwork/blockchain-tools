// SPDX-License-Identifier: MIT
// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py

pragma solidity ^0.8.24;

error EncodingIsUnknown();

library Bech32m {

    // Decode a segwit address
    function decodeSegwitAddress(
        bytes calldata expectedHrp,
        bytes calldata addr
    ) public pure returns (uint8) {
        return 1;
    }
}
