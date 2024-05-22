// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";

contract SetSeed is Script {
    function run() external {
        // get contract address
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "BTCDepositAddressDeriver",
            block.chainid
        );
        console.log("contractAddress", contractAddress);

        // get first validators' joint pubkey
        string memory btcAddr1 = vm.envString("BTC_ADDR1");
        console.log("BTC_ADDR1:", btcAddr1);

        // get second validators' joint pubkey
        string memory btcAddr2 = vm.envString("BTC_ADDR2");
        console.log("BTC_ADDR2:", btcAddr2);

        // get network
        uint network = vm.envUint("Network");
        console.log("Network:", network);

        BTCDepositAddressDeriver deriver = BTCDepositAddressDeriver(
            contractAddress
        );

        // set validators' pubkeys and network prefix
        vm.startBroadcast();
        deriver.setSeed(btcAddr1, btcAddr2, BTCDepositAddressDeriver.BitcoinNetwork(network));
        vm.stopBroadcast();
    }
}
