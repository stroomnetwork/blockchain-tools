// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {Tools} from "../src/Tools.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract AddressReaderWriter is Script {
    function writeContractAddress(
        string memory contractName,
        address contractAddress
    ) public {
        string memory addressFileName = string.concat(
            "./temp/",
            contractName,
            ".",
            Strings.toString(block.chainid),
            ".address"
        );
        string memory addressStr = Strings.toHexString(contractAddress);
        vm.writeFile(addressFileName, addressStr);
    }

    function readContractAddress(
        string memory contractName
    ) public returns (address) {
        string memory addressFileName = string.concat(
            "./temp/",
            contractName,
            ".",
            Strings.toString(block.chainid),
            ".address"
        );
        string memory contractAddressStr = vm.readLine(addressFileName);
        address contractAddress = Tools.toAddress(contractAddressStr);
        return contractAddress;
    }
}
