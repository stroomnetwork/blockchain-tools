// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Deriver} from "../src/Deriver.sol";

contract DeriverTest is Test {
    Deriver public deriver;

    function setUp() public {
        deriver = new Deriver();
    }

    function test_Derivation() public {
        (uint256 x1, uint256 y1) = deriver.getCombinedPubkey(
            deriver.C1(),
            deriver.C2()
        );
        console.log("x1: ", x1); 
        assertEq(x1, deriver.P3X());
        assertEq(y1, deriver.P3Y());
    }
}
