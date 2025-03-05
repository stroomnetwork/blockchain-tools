// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import { Script } from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {Tools} from "../src/Tools.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {AddressReaderWriter} from "./AddressReaderWriter.s.sol";

contract Deploy is Script, AddressReaderWriter {
    function run() external returns (BTCDepositAddressDeriver) {
        vm.startBroadcast();
        BTCDepositAddressDeriver btcDepositAddressDeriver = new BTCDepositAddressDeriver();
        vm.stopBroadcast();
        writeContractAddress("BTCDepositAddressDeriver", address(btcDepositAddressDeriver));
        return btcDepositAddressDeriver;
    }
}