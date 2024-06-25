// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Bech32m} from "./Bech32m.sol";

error UnsupportedBtcAddress(string btcAddress);
error CannotParseBtcAddress(
    string btcAddress,
    string hrp,
    Bech32m.DecodeError err
);

contract BTCDepositAddressDeriver {

    event SeedChanged(string btcAddr1, string btcAddr2, string hrp);

    bool public wasSeedSet;

    // Validators' joint pubkeys in format of taproot addresses
    string public btcAddr1;
    string public btcAddr2;

    // Bitcoin address's network prefix
    string public networkHrp;

    // Validators' pubkey both coordinates deconstructed from taproot addresses
    uint256 public p1x;
    uint256 public p1y;
    uint256 public p2x;
    uint256 public p2y;

    constructor() {
        wasSeedSet = false;
    }

    // Set Validators' joint pubkeys and network prefix, must be called after contract deployment
    function setSeed(
        string calldata _btcAddr1,
        string calldata _btcAddr2,
        uint8 _network
    ) public virtual {
        string memory _hrp = getNetworkPrefix(_network);

        networkHrp = _hrp;

        (p1x, p1y) = parseBTCTaprootAddress(_hrp, _btcAddr1);
        (p2x, p2y) = parseBTCTaprootAddress(_hrp, _btcAddr2);

        btcAddr1 = _btcAddr1;
        btcAddr2 = _btcAddr2;

        wasSeedSet = true;
        emit SeedChanged(_btcAddr1, _btcAddr2, _hrp);
    }

    // get address prefix from network type
    function getNetworkPrefix(
        uint8 _network
    ) public pure returns (string memory) {

        string memory _hrp;

        if (_network == 0) {
            _hrp = 'tb';
        } else if (_network == 1) {
            _hrp = 'bc';
        } else if (_network == 2) {
            _hrp = 'brct';
        } else {
            _hrp = 'unknown';
        }

        return _hrp;
    }

    // Derive pubkey's (x,y) coordinates from taproot address
    function parseBTCTaprootAddress(
        string memory _hrp,
        string calldata _bitcoinAddress
    ) public pure returns (uint256, uint256) {

        (uint8 witVer, bytes memory witProg, Bech32m.DecodeError err) = Bech32m
            .decodeSegwitAddress(bytes(_hrp), bytes(_bitcoinAddress));

        if (err != Bech32m.DecodeError.NoError) {
            revert CannotParseBtcAddress(_bitcoinAddress, _hrp, err);
        }
        if (witVer != 1 || witProg.length != 32) {
            revert UnsupportedBtcAddress(_bitcoinAddress);
        }

        uint256 x = uint256(bytes32(witProg));

        return (x, x);
    }
}
