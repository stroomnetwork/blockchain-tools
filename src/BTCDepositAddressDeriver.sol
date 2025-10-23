// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Deriver} from "./Deriver.sol";
import {Bech32m} from "./Bech32m.sol";
import {BitcoinNetworkEncoder} from "./BitcoinNetworkEncoder.sol";

error SeedWasNotSetYet();
error UnsupportedBtcAddress(string btcAddress);
error CannotParseBtcAddress(
    string btcAddress,
    string hrp,
    Bech32m.DecodeError err
);

// Types of Bitcoin Network

contract BTCDepositAddressDeriver {

    event SeedChanged(string btcAddr, string hrp);

    bool public wasSeedSet;

    // Validators' joint pubkey in format of taproot addresses
    string public btcAddr;

    // Bitcoin address's network prefix
    string public networkHrp;

    // Validators' pubkey both coordinates deconstructed from taproot addresses
    uint256 public p1x;
    uint256 public p1y;

    constructor() {
        wasSeedSet = false;
    }

    // Set Validators' joint pubkey and network prefix, must be called after contract deployment
    function setSeed(
        string calldata _btcAddr,
        BitcoinNetworkEncoder.Network _network
    ) public virtual {
        string memory _hrp = BitcoinNetworkEncoder.getNetworkPrefix(_network);

        networkHrp = _hrp;

        (p1x, p1y) = parseBTCTaprootAddress(_hrp, _btcAddr);

        btcAddr = _btcAddr;

        wasSeedSet = true;
        emit SeedChanged(_btcAddr, _hrp);
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

        if (x == 0 || x >= Deriver.PP) {
            revert UnsupportedBtcAddress(_bitcoinAddress);
        }

        uint256 y = Deriver.liftX(x);

        return (x, y);
    }

    // Get users' Bitcoin deposit address from user's Stroom NFT token ID
    function getBTCDepositAddress(
        uint256 index
    ) public virtual view returns (string memory) {

        if (!wasSeedSet) {
            revert SeedWasNotSetYet();
        }

        return
            Deriver.deriveReceivingAddressFromIndex(
                p1x,
                p1y,
                index,
                bytes(networkHrp)
            );
    }
}
