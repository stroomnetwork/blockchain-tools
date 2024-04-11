// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {Deriver} from "./Deriver.sol";
import {Bech32m} from "./Bech32m.sol";

error SeedWasNotSetYet();

error CannotParseBtcAddress(
    string btcAddress,
    string hrp,
    Bech32m.DecodeError err
);
error UnsupportedBtcAddress(string btcAddress);

contract BTCDepositAddressDeriver {
    event SeedChanged(string btcAddr1, string btcAddr2, string hrp);

    bool public wasSeedSet;
    string public btcAddr1;
    string public btcAddr2;
    string public networkHrp;

    uint256 public p1x;
    uint256 public p1y;
    uint256 public p2x;
    uint256 public p2y;

    constructor() {
        wasSeedSet = false;
    }

    function parseBTCTaprootAddress(
        string calldata hrp,
        string calldata addr
    ) public pure returns (uint256, uint256) {
        (uint8 witVer, bytes memory witProg, Bech32m.DecodeError err) = Bech32m
            .decodeSegwitAddress(bytes(hrp), bytes(addr));
        if (err != Bech32m.DecodeError.NoError) {
            revert CannotParseBtcAddress(addr, hrp, err);
        }
        if (witVer != 1 || witProg.length != 32) {
            revert UnsupportedBtcAddress(addr);
        }
        uint256 x = uint256(bytes32(witProg));
        if (x == 0 || x >= Deriver.PP) {
            revert UnsupportedBtcAddress(addr);
        }

        uint256 y = Deriver.liftX(x);

        return (x, y);
    }

    function setSeed(
        string calldata _btcAddr1,
        string calldata _btcAddr2,
        string calldata _hrp
    ) public {
        networkHrp = _hrp;
        (p1x, p1y) = parseBTCTaprootAddress(_hrp, _btcAddr1);
        (p2x, p2y) = parseBTCTaprootAddress(_hrp, _btcAddr2);
        btcAddr1 = _btcAddr1;
        btcAddr2 = _btcAddr2;
        wasSeedSet = true;
        emit SeedChanged(_btcAddr1, _btcAddr2, _hrp);
    }

    function getBTCDepositAddress(
        address ethAddr
    ) public view returns (string memory) {
        if (!wasSeedSet) {
            revert SeedWasNotSetYet();
        }
        return
            Deriver.getBtcAddressFromEth(
                p1x,
                p1y,
                p2x,
                p2y,
                bytes(networkHrp),
                ethAddr
            );
    }
}
