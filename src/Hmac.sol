// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import {Sha2Ext} from "./sha2/Sha2Ext.sol";

library Hmac {
    // SHA-512 block size in bytes
    uint256 constant BLOCK_SIZE = 128;

    function sha512AsBytes(
        bytes memory message
    ) internal pure returns (bytes memory) {
        (bytes32 hash1, bytes32 hash2) = Sha2Ext.sha512(message);
        return abi.encodePacked(hash1, hash2);
    }

    function hmacSha512(
        bytes memory key,
        bytes memory message
    ) internal pure returns (bytes32, bytes32) {
        require(key.length > 0, "Key cannot be empty");
        require(message.length > 0, "Message cannot be empty");

        bytes memory paddedKey = key;

        // If key is longer than block size, hash it
        if (key.length > BLOCK_SIZE) {
            paddedKey = sha512AsBytes(key);
        }

        // If key is shorter than block size, pad with zeros
        if (paddedKey.length < BLOCK_SIZE) {
            bytes memory temp = new bytes(BLOCK_SIZE);
            for (uint i = 0; i < paddedKey.length; i++) {
                temp[i] = paddedKey[i];
            }
            paddedKey = temp;
        }

        // Create inner and outer padded keys
        bytes memory innerKey = new bytes(BLOCK_SIZE);
        bytes memory outerKey = new bytes(BLOCK_SIZE);

        for (uint i = 0; i < BLOCK_SIZE; i++) {
            innerKey[i] = bytes1(uint8(paddedKey[i]) ^ 0x36);
            outerKey[i] = bytes1(uint8(paddedKey[i]) ^ 0x5c);
        }

        // HMAC = H(outerKey || H(innerKey || message))
        bytes memory innerHash = sha512AsBytes(abi.encodePacked(innerKey, message));
        (bytes32 rez1, bytes32 rez2) = Sha2Ext.sha512(abi.encodePacked(outerKey, innerHash));

        return (rez1, rez2);
    }
}
