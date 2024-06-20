// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {Tools} from "../src/Tools.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {AddressReaderWriter} from "../src/AddressReaderWriter.sol";
import {console} from "forge-std/console.sol";

contract SetSeed is Script, AddressReaderWriter {
    function run() external {
        // get contract address
        // if environmental variable is set then use its value
        // otherwise try get value from the latest deployment
        address contractAddress;
        string memory contractAddressStr = vm.envOr(
            "CONTRACT_ADDR",
            string("")
        );
        if (!Tools.areStringsEqual(contractAddressStr, "")) {
            contractAddress = vm.envAddress("CONTRACT_ADDR");
        } else {
            contractAddress = readContractAddress(
                "BTCDepositAddressDeriver"
            );
        }

        console.log("contractAddress", contractAddress);

        // get first validators' joint pubkey
        string memory btcAddr1 = vm.envString("BTC_ADDR1");
        console.log("BTC_ADDR1:", btcAddr1);

        // get second validators' joint pubkey
        string memory btcAddr2 = vm.envString("BTC_ADDR2");
        console.log("BTC_ADDR2:", btcAddr2);

        // get network
        uint network = vm.envUint("BTC_NETWORK");
        console.log("BTC_NETWORK:", network);

        BTCDepositAddressDeriver deriver = BTCDepositAddressDeriver(
            contractAddress
        );
        console.log("deriver", address(deriver));

        // set validators' pubkeys and network prefix
        console.log("SetSeed step 1");
        vm.startBroadcast();
        console.log("SetSeed step 2");
        BTCDepositAddressDeriver.BitcoinNetwork btcNetwork = BTCDepositAddressDeriver.BitcoinNetwork(network);
        console.log("SetSeed step 3");
        deriver.setSeed(
            btcAddr1,
            btcAddr2,
            btcNetwork 
        );
        console.log("SetSeed step 4");
        vm.stopBroadcast();
    }
}
