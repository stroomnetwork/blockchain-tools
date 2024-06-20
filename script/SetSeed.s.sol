// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {Tools} from "../src/Tools.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {AddressReaderWriter} from "./AddressReaderWriter.s.sol";
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
        uint _network = vm.envUint("BTC_NETWORK");
        uint8 network = uint8(_network);
        
        console.log("BTC_NETWORK:", network);

        BTCDepositAddressDeriver deriver = BTCDepositAddressDeriver(
            contractAddress
        );

        // set validators' pubkeys and network prefix
        vm.startBroadcast();
        deriver.setSeed(btcAddr1, btcAddr2, network);
        vm.stopBroadcast();
    }
}
