// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract SetSeed is Script {
    // https://www.educative.io/answers/how-to-compare-two-strings-in-solidity
    function areStringsEqual(
        string memory str1,
        string memory str2
    ) public pure returns (bool) {
        return
            keccak256(abi.encodePacked(str1)) ==
            keccak256(abi.encodePacked(str2));
    }

    // https://stackoverflow.com/questions/69551020/trying-to-convert-address-string-to-type-address-in-solidity
    function fromHexChar(uint8 c) public pure returns (uint8) {
        if (bytes1(c) >= bytes1('0') && bytes1(c) <= bytes1('9')) {
            return c - uint8(bytes1('0'));
        }
        if (bytes1(c) >= bytes1('a') && bytes1(c) <= bytes1('f')) {
            return 10 + c - uint8(bytes1('a'));
        }
        if (bytes1(c) >= bytes1('A') && bytes1(c) <= bytes1('F')) {
            return 10 + c - uint8(bytes1('A'));
        }
        return 0;
    }
    
    // https://stackoverflow.com/questions/69551020/trying-to-convert-address-string-to-type-address-in-solidity
    function hexStringToAddress(string memory s) public pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length%2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint i=0; i<ss.length/2; ++i) {
            r[i] = bytes1(fromHexChar(uint8(ss[2*i])) * 16 +
                        fromHexChar(uint8(ss[2*i+1])));
        }

        return r;

    }
    
    // https://stackoverflow.com/questions/69551020/trying-to-convert-address-string-to-type-address-in-solidity
    function toAddress(string memory s) public pure returns (address) {
        bytes memory _bytes = hexStringToAddress(s);
        require(_bytes.length >= 1 + 20, "toAddress_outOfBounds");
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), 1)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function run() external {
        // get contract address
        // if environmental variable is set then use its value
        // otherwise try get value from the latest deployment
        address contractAddress;
        string memory contractAddressStr = vm.envOr(
            "CONTRACT_ADDR",
            string("")
        );
        if (!areStringsEqual(contractAddressStr, "")) {
            contractAddress = vm.envAddress("CONTRACT_ADDR");
        } else {
            string memory addressFileName = string.concat(
                "./temp/",
                "BTCDepositAddressDeriver",
                ".",
                Strings.toString(block.chainid),
                ".address"
            );
            contractAddressStr = vm.readLine(addressFileName);
            console.log("contractAddressStr", contractAddressStr);
            contractAddress = toAddress(contractAddressStr);
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

        // set validators' pubkeys and network prefix
        vm.startBroadcast();
        deriver.setSeed(
            btcAddr1,
            btcAddr2,
            BTCDepositAddressDeriver.BitcoinNetwork(network)
        );
        vm.stopBroadcast();
    }
}
