// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";

contract GetBtcAddr is Script {
    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "BTCDepositAddressDeriver",
            block.chainid
        );
        console.log("contractAddress", contractAddress);

        address ethAddr = vm.envAddress("ETH_ADDR");
        console.log("ethAddr:", ethAddr);

        BTCDepositAddressDeriver deriver = BTCDepositAddressDeriver(
            contractAddress
        );
        string memory btcAddr = deriver.getBTCDepositAddress(ethAddr);
        console.log("btcAddr:", btcAddr);
    }
}
