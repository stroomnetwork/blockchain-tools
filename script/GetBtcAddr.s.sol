// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {Tools} from "../src/Tools.sol";
import {AddressReaderWriter} from "./AddressReaderWriter.s.sol";

contract GetBtcAddr is Script, AddressReaderWriter {
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

        uint256 tokenId = vm.envUint("TOKEN_ID");
        console.log("TOKEN_ID:", tokenId);

        BTCDepositAddressDeriver deriver = BTCDepositAddressDeriver(
            contractAddress
        );
        string memory btcAddr = deriver.getBTCDepositAddress(tokenId);
        console.log("btcAddr:", btcAddr);

        string memory btcAddrFileName = vm.envOr(
            "BTC_ADDR_FILE",
            string("")
        );
        if (!Tools.areStringsEqual(btcAddrFileName, "")) {
            vm.writeFile(btcAddrFileName, btcAddr);
        }
    }
}
