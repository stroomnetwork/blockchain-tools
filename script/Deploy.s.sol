// SPDX-LICENSE-IDENTIFIER: MIT

pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";

contract Deploy is Script {
    function run() external returns (BTCDepositAddressDeriver) {
        vm.startBroadcast();
        BTCDepositAddressDeriver btcDepositAddressDeriver = new BTCDepositAddressDeriver();
        vm.stopBroadcast();
        return btcDepositAddressDeriver;
    }
}