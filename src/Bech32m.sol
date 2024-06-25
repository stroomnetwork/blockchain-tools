// SPDX-License-Identifier: MIT
// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py

pragma solidity ^0.8.24;

error EncodingIsUnknown();

library Bech32m {

    enum DecodeError {
        NoError
    }

    // Decode a segwit address
    function decodeSegwitAddress(
        bytes calldata expectedHrp,
        bytes calldata addr
    ) public pure returns (uint8, bytes memory, DecodeError) {

        bytes memory data8Bit = new bytes(32);
        for (uint i = 0; i < data8Bit.length; i += 1) {
            data8Bit[i] = 1;
        }

        return (1, data8Bit, DecodeError.NoError);
    }
}
