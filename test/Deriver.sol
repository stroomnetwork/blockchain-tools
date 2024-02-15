// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Deriver} from "../src/Deriver.sol";

contract DeriverTest is Test {
    Deriver public deriver;

    function setUp() public {
        deriver = new Deriver();
    }

    function test_DerivationPubkey() public {
        (uint256 x1, uint256 y1) = deriver.getCombinedPubkey(
            deriver.C1(),
            deriver.C2()
        );
        assertEq(x1, deriver.P3X());
        assertEq(y1, deriver.P3Y());
    }

    function test_CoefficientDerivation() public {
        uint256 c1 = deriver.getCoefficient(
            deriver.P1X(),
            deriver.P1Y(),
            deriver.userAddress()
        );
        assertEq(c1, 0x5FD0C009DA282DFE7E047C2190B3F00FF04E58B42F715D5345EBA4CD5BF4DBF9);

        uint256 c2 = deriver.getCoefficient(
            deriver.P2X(),
            deriver.P2Y(),
            deriver.userAddress()
        );
        assertEq(c2, 0xA55B9626A950D34CCAD73EEB13E3510861C6B4C9462668627F1A7DE500B6A1AB);
    }
}
