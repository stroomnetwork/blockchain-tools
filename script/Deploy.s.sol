// SPDX-LICENSE-IDENTIFIER: MIT

pragma solidity ^0.8.19;

import { Script } from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Deploy is Script {
    function run() external returns (BTCDepositAddressDeriver) {
        vm.startBroadcast();
        BTCDepositAddressDeriver btcDepositAddressDeriver = new BTCDepositAddressDeriver();
        vm.stopBroadcast();
        string memory addressFileName = string.concat("./temp/", "BTCDepositAddressDeriver", ".", Strings.toString(block.chainid), ".address");
        string memory addressStr = Strings.toHexString(address(btcDepositAddressDeriver));
        vm.writeFile(addressFileName, addressStr);
        return btcDepositAddressDeriver;
    }
}