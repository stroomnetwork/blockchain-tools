// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Deriver} from "../src/Deriver.sol";

contract DeriverTest is Test {
    function testDerivationPubkey() public {
        (uint256 x1, uint256 y1) = Deriver.getCombinedPubkey(
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A,
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0,
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC,
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C,
            0xAF0AAFE2C1B97A6F64A78BD31CC1ABECC70623D61EB8D92231E0906AD5D2F739,
            0x71A862373EF0DBB8489B1CE31E0D6F931A5C5AFA2D63FEA663FFAB45D7D467AA
        );
        assertEq(
            x1,
            0x786BA0CC9B0DA200D11CC085D41BBD5F1471DF8DF216CD775B924F4CAC80F341
        );
        assertEq(
            y1,
            0xD351E3FE211B48C6A8C8421F25767ED5D29F7E66944EB5DCD98F47DAF769F897
        );
    }

    function testCoefficientDerivation() public {
        uint256 c1 = Deriver.getCoefficient(
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A,
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0,
            0x71C7656EC7ab88b098defB751B7401B5f6d8976F
        );
        assertEq(
            c1,
            0x5FD0C009DA282DFE7E047C2190B3F00FF04E58B42F715D5345EBA4CD5BF4DBF9
        );

        uint256 c2 = Deriver.getCoefficient(
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC,
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C,
            0x71C7656EC7ab88b098defB751B7401B5f6d8976F
        );
        assertEq(
            c2,
            0xA55B9626A950D34CCAD73EEB13E3510861C6B4C9462668627F1A7DE500B6A1AB
        );
    }

    function testPubkeyFromAddree() public {
        (uint256 x, uint256 y) = Deriver.getPubkeyFromAddress(
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A,
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0,
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC,
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C,
            0x71C7656EC7ab88b098defB751B7401B5f6d8976F
        );
        assertEq(
            x,
            0xF841B419521509E6C50754F2801D94FA3F25D62AA2F55039DA1F7A848FDF7BBD
        );
        assertEq(
            y,
            0xB2445FEAA4E63449F7770E56C153A997F4E1B75707B7BF44ED4B69DEFAFD6813
        );
    }

    function testGetBtcAddressFromEth() public {
        string memory btcAddress = Deriver.getBtcAddressFromEth(
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A,
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0,
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC,
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C,
            bytes("tb"),
            0x71C7656EC7ab88b098defB751B7401B5f6d8976F
        );
        assertEq(
            btcAddress,
            "tb1plpqmgx2jz5y7d3g82negq8v5lgljt4325t64qww6raagfr7l0w7sefvmzw"
        );
    }

    function testComputeTaprootKeyNoScript() public {
        // Test cases were automatically generated in Go.
        // Correspondence between descriptor and regtest address was checked in bitcoind.

        // small x=1 to check padding, FindPubkeyFromX(1)
        // Descriptor: tr(0000000000000000000000000000000000000000000000000000000000000001)
        // Regtest address: bcrt1pw3yacwv2cun92ke5g4gmyvzjxclucqx8t6tml7m0tfqjecvqtzks2sgz5f
        uint256 x0 = 1;
        uint256 y0 = 29896722852569046015560700294576055776214335159245303116488692907525646231534;
        uint256 x0TweakedExpected = 52598790206915998760408158409706115969242582706983276613226717467982222612653;
        uint256 y0TweakedExpected = 8539729109611639503272152634470558050354725767758305540483549745586427273314;
        (uint256 x0Tweaked, uint256 y0Tweaked) = Deriver
            .computeTaprootKeyNoScript(x0, y0);
        assertEq(x0Tweaked, x0TweakedExpected);
        assertEq(y0Tweaked, y0TweakedExpected);

        // x(>=1000) to check padding, FindPubkeyFromX(1000)
        // Descriptor: tr(00000000000000000000000000000000000000000000000000000000000003ec)
        // Regtest address: bcrt1p5l79spdqw2swuwg9zvrjnw6ax5l03h5633prhz8qcr2rcm2gg3wspu4wej
        uint256 x1 = 1004;
        uint256 y1 = 50566750680002108827280051043316308483979214535572331408301622620618248094164;
        uint256 x1TweakedExpected = 75982098679105012767054839615480766874362225667059272419725367141590016476253;
        uint256 y1TweakedExpected = 38111558438345768766105231040238601022767042816083729768024884986909252148597;
        (uint256 x1Tweaked, uint256 y1Tweaked) = Deriver
            .computeTaprootKeyNoScript(x1, y1);
        assertEq(x1Tweaked, x1TweakedExpected);
        assertEq(y1Tweaked, y1TweakedExpected);

        // x(>=1000000) to check padding, FindPubkeyFromX(1000000)
        // Descriptor: tr(00000000000000000000000000000000000000000000000000000000000f4242)
        // Regtest address: bcrt1p48s3pxlgdp9c804saz53fs7n5yxwrq882sr27xhdtvvkn0ajqj9qpncdwt
        uint256 x2 = 1000002;
        uint256 y2 = 115421580779160830541564858798348048665605890024245002666544848392484158543900;
        uint256 x2TweakedExpected = 76838526631355794299542788514028170455259944725644477117600957851609725011082;
        uint256 y2TweakedExpected = 61636608481388897341296123833809412111161299133548647817060478960764143138799;
        (uint256 x2Tweaked, uint256 y2Tweaked) = Deriver
            .computeTaprootKeyNoScript(x2, y2);
        assertEq(x2Tweaked, x2TweakedExpected);
        assertEq(y2Tweaked, y2TweakedExpected);

        // x(>=1000000000) to check padding, FindPubkeyFromX(1000000000)
        // Descriptor: tr(000000000000000000000000000000000000000000000000000000003b9aca03)
        // Regtest address: bcrt1py4y0m4y4cape83840e9qy0u9mhn4mf44m0k6447k5klep6gyk03s29ts3h
        uint256 x3 = 1000000003;
        uint256 y3 = 40276071915510323673084110927775790363542425252812024751949404428417686863292;
        uint256 x3TweakedExpected = 16864540259352835392870939686994004168658892970981429858603412376299126436835;
        uint256 y3TweakedExpected = 62871895376343251820683844942076504881002674530470591206287079343301458236439;
        (uint256 x3Tweaked, uint256 y3Tweaked) = Deriver
            .computeTaprootKeyNoScript(x3, y3);
        assertEq(x3Tweaked, x3TweakedExpected);
        assertEq(y3Tweaked, y3TweakedExpected);

        // some random key, GetPubkeyFromSeed("key-1")
        // Descriptor: tr(d2574f8ea255f1ee32a7ba303fdf3ba0bcf5de9a765aec325179f0fed56147c8)
        // Regtest address: bcrt1ptts7ukatnnp3v4uv8nl6ja4p3jgszpp2fjakkzjdmedru59m4qaslkngeu
        uint256 x4 = 95139962980491431174412159539357321770091795886961022501559818261988217276360;
        uint256 y4 = 46036297902870250637947206317417135133611687575579611582072758463587242207960;
        uint256 x4TweakedExpected = 41107342049127684338865387735159753882100729519671631047080651435112102864955;
        uint256 y4TweakedExpected = 39684114171189517446112675430978734680806571453129682454396918992690845153022;
        (uint256 x4Tweaked, uint256 y4Tweaked) = Deriver
            .computeTaprootKeyNoScript(x4, y4);
        assertEq(x4Tweaked, x4TweakedExpected);
        assertEq(y4Tweaked, y4TweakedExpected);

        // some random key, GetPubkeyFromSeed("key-2")
        // Descriptor: tr(e04cd7c61dd4ba8a0251ae6b55ae9a4f1adc5d1f2ca2db189bb6e913b58081be)
        // Regtest address: bcrt1p4lkh3vc0yhd8yufkl4uzdztz2hla3t55jy7n9nl5yvzmhw8vnqlsasesls
        uint256 x5 = 101453847676250396228413237673246898808317095937272786651400543244471507124670;
        uint256 y5 = 63454576008186559064547728145704133169288740657138044079107482525695746136122;
        uint256 x5TweakedExpected = 79574324293411419662104829151852572098189426134826193796410519409314306496575;
        uint256 y5TweakedExpected = 84049350742986204533456594847398501395878693485889352338247467465353458662720;
        (uint256 x5Tweaked, uint256 y5Tweaked) = Deriver
            .computeTaprootKeyNoScript(x5, y5);
        assertEq(x5Tweaked, x5TweakedExpected);
        assertEq(y5Tweaked, y5TweakedExpected);
    }

    function testgetBtcTaprootAddrFromPubkey() public {
        uint256 x0 = 1;
        bytes memory hrp0 = bytes("bcrt");
        string
            memory expectedBtcAddr0 = "bcrt1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqsws5gfa";
        string memory btcAddr0 = Deriver.getBtcTaprootAddrFromPubkey(x0, hrp0);
        assertEq(expectedBtcAddr0, btcAddr0);

        uint256 x1 = 1004;
        bytes memory hrp1 = bytes("bcrt");
        string
            memory expectedBtcAddr1 = "bcrt1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq0kqgxaz3y";
        string memory btcAddr1 = Deriver.getBtcTaprootAddrFromPubkey(x1, hrp1);
        assertEq(expectedBtcAddr1, btcAddr1);

        uint256 x2 = 1000002;
        bytes memory hrp2 = bytes("bcrt");
        string
            memory expectedBtcAddr2 = "bcrt1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq0gfpqk2l9fn";
        string memory btcAddr2 = Deriver.getBtcTaprootAddrFromPubkey(x2, hrp2);
        assertEq(expectedBtcAddr2, btcAddr2);

        uint256 x3 = 1000000003;
        bytes memory hrp3 = bytes("bcrt");
        string
            memory expectedBtcAddr3 = "bcrt1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqwu6egpskvk9c6";
        string memory btcAddr3 = Deriver.getBtcTaprootAddrFromPubkey(x3, hrp3);
        assertEq(expectedBtcAddr3, btcAddr3);

        uint256 x4 = 49638490350653890404049973095656032488753139080487109443386992570973932368088;
        bytes memory hrp4 = bytes("bcrt");
        string
            memory expectedBtcAddr4 = "bcrt1pdklx85f3ur9plklewyhwlk27au5xpwruxn96fymp3tq3y3zzxrvqzepnl7";
        string memory btcAddr4 = Deriver.getBtcTaprootAddrFromPubkey(x4, hrp4);
        assertEq(expectedBtcAddr4, btcAddr4);

        uint256 x5 = 60127624607440319347311638604827610310097127916858217930208677047728575394005;
        bytes memory hrp5 = bytes("bcrt");
        string
            memory expectedBtcAddr5 = "bcrt1psnhs0r3njpqqheauvx0a6thypn5m4p7uy6ue97w9cgma7wfckr2sdqa585";
        string memory btcAddr5 = Deriver.getBtcTaprootAddrFromPubkey(x5, hrp5);
        assertEq(expectedBtcAddr5, btcAddr5);
    }

    // function testGetBtcAddressTaprootNoScriptFromEth() public {
    //     // Test cases were automatically generated in Go.

    //     uint256 x1_0 = 54147769457631533710022564500742536038246727812137618871549590227497793828474;
    //     uint256 y1_0 = 96091192197178033512370658560500964796461556892477693557977072200584849793968;
    //     uint256 x2_0 = 67261561909726473286993603243929025817028541803191223835743288887468871643510;
    //     uint256 y2_0 = 49473559344142397756767891385407723329456329883991697784595543981689192800614;
    //     address ethAddr_0 = 0x388C818CA8B9251b393131C08a736A67ccB19297;
    //     string
    //         memory expectedBtcAddr_0 = "bcrt1pr53pdru9x6vmshdwhqs2znq5gy5kfwvfjtms340mac6ahvft42cqd42f4x";
    //     string
    //         memory expectedBtcDesc_0 = "tr(46b8b5d09b655da4885a4383a5ef22b36285f106d31dae232ad42f7a7cd4dd42)";
    //     string memory btcAddr_0 = Deriver.getBtcAddressTaprootNoScriptFromEth(
    //         x1_0,
    //         y1_0,
    //         x2_0,
    //         y2_0,
    //         bytes("bcrt"),
    //         ethAddr_0
    //     );
    //     assertEq(expectedBtcAddr_0, btcAddr_0);
    // }
}
