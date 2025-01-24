// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {BTCDepositAddressDeriver} from "../src/BTCDepositAddressDeriver.sol";
import {BitcoinNetworkEncoder} from "../src/BitcoinNetworkEncoder.sol";

contract BTCDepositAddressDeriverTest is Test {
    BTCDepositAddressDeriver deriver;

    function setUp() public {
        deriver = new BTCDepositAddressDeriver();
    }

    function testParseBTCTaprootAddress1() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3"
        );
        assertEq(
            x,
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A
        );
        assertEq(
            y,
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0
        );
    }

    function testParseBTCTaprootAddress2() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz"
        );
        assertEq(
            x,
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC
        );
        assertEq(
            y,
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C
        );
    }

    function testParseBTCTaprootAddress3() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq5zuyut"
        );
    }

    function testParseBTCTaprootAddress4() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqh2y7hd"
        );
    }

    function testParseBTCTaprootAddress5() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "BC1S0XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ54WELL"
        );
    }

    function testParseBTCTaprootAddress6() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1q0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq24jc47"
        );
    }

    function testParseBTCTaprootAddress7() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1p38j9r5y49hruaue7wxjce0updqjuyyx0kh56v8s25huc6995vvpql3jow4"
        );
    }

    function testParseBTCTaprootAddress8() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "BC130XLXVLHEMJA6C4DQV22UAPCTQUPFHLXM9H8Z3K2E72Q4K9HCZ7VQ7ZWS8R"
        );
    }

    function testParseBTCTaprootAddress9() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1pw5dgrnzv"
        );
    }

    function testParseBTCTaprootAddress10() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v8n0nx0muaewav253zgeav"
        );
    }

    function testParseBTCTaprootAddress11() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vq47Zagq"
        );
    }

    function testParseBTCTaprootAddress12() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7v07qwwzcrf"
        );
    }

    function testParseBTCTaprootAddress13() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vpggkg4j"
        );
    }

    function testParseBTCTaprootAddress14() public {
        vm.expectRevert();
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1gmk9yu"
        );
    }

    function testParseBTCTaprootAddress15() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1p0xlxvlhemja6c4dqv22uapctqupfhlxm9h8z3k2e72q4k9hcz7vqzk5jj0"
        );
        assertEq(
            x,
            0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
        );
        assertEq(
            y,
            0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
        );
    }

    function testParseBTCTaprootAddress16() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "tb",
            "tb1pqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesf3hn0c"
        );
        assertEq(
            x,
            0xC4A5CAD46221B2A187905E5266362B99D5E91C6CE24D165DAB93E86433
        );
        assertEq(
            y,
            0xE938F4061E36DEF24C05DDCFD738363AAFF7BBC09267C7079451A0F169500766
        );
    }

    function testParseBTCTaprootAddress17() public {
        (uint256 x, uint256 y) = deriver.parseBTCTaprootAddress(
            "bc",
            "bc1pldma57nkrdrvtx7elspzgfa23qcxglzzunxxmqkwq8pnwpa4sd6s3406mu"
        );
        assertEq(
            x,
            0xFB77DA7A761B46C59BD9FC022427AA8830647C42E4CC6D82CE01C33707B58375
        );
        assertEq(
            y,
            0x68251ED41C7645E4AE49F68B0F4A207E4327501CB0B4BB7E3F5D86EF815794C6
        );
        //console.log("pubkey:", x, y);
    }

    function testSetSeed() public {
        assertEq(deriver.wasSeedSet(), false);
        assertEq(deriver.btcAddr1(), "");
        assertEq(deriver.btcAddr2(), "");
        assertEq(deriver.networkHrp(), "");
        assertEq(deriver.p1x(), 0);
        assertEq(deriver.p1y(), 0);
        assertEq(deriver.p2x(), 0);
        assertEq(deriver.p2y(), 0);

        vm.expectEmit(address(deriver));
        emit BTCDepositAddressDeriver.SeedChanged(
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz",
            "tb"
        );
        deriver.setSeed(
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3",
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz",
            BitcoinNetworkEncoder.Network.Testnet
        );

        assertEq(deriver.wasSeedSet(), true);
        assertEq(
            deriver.btcAddr1(),
            "tb1p7g532zgvuzv8fz3hs02wvn2almqh8qyvz4xdr564nannkxh28kdq62ewy3"
        );
        assertEq(
            deriver.btcAddr2(),
            "tb1psfpmk6v8cvd8kr4rdda0l8gwyn42v5yfjlqkhnureprgs5tuumkqvdkewz"
        );
        assertEq(deriver.networkHrp(), "tb");
        assertEq(
            deriver.p1x(),
            0xF22915090CE098748A3783D4E64D5DFEC173808C154CD1D3559F673B1AEA3D9A
        );
        assertEq(
            deriver.p1y(),
            0xEE340CB6B7C08A2B96B7C34A70B5B980FAD90AD4E9D0BE50302DA7542A73C0E0
        );
        assertEq(
            deriver.p2x(),
            0x8243BB6987C31A7B0EA36B7AFF9D0E24EAA6508997C16BCF83C84688517CE6EC
        );
        assertEq(
            deriver.p2y(),
            0x4FEF9EF44EA93A90E91CB9ED229F0D684F6A56EBB0787174369D4DADDCB1A85C
        );
    }

    // This test was generated automatically in Go.
    // pk1: 77b68d2b2eb93a1d44118cce2bf40a870c13b33cb2fc34ff51ed474e747f367a
    // pk2: 94b4b1e7676caf70c0c07ceb84c723fce2099689efcd741a852598086043f176
    // resulting descriptor: tr(73e0ef552f3e3a4b1b35d1be0476107fb060afb49634ef5ef22ac54171ff0541)
    function testGetBTCDepositAddress_0_mainnet() public {
        deriver.setSeed(
            "bc1pw7mg62ewhyap63q33n8zhaq2suxp8veukt7rfl63a4r5uarlxeaqdvrymq",
            "bc1pjj6trem8djhhpsxq0n4cf3erln3qn95falxhgx59ykvqsczr79mqnuzsa3",
            BitcoinNetworkEncoder.Network.Mainnet
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x388C818CA8B9251b393131C08a736A67ccB19297
        );
        assertEq(
            btcAddress,
            "bc1paz50paqaeph7xecyt8hzc9ly3sfyuaw0nmaaahat8mn37hrlhcjqwf8xe4"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 77b68d2b2eb93a1d44118cce2bf40a870c13b33cb2fc34ff51ed474e747f367a
    // pk2: 94b4b1e7676caf70c0c07ceb84c723fce2099689efcd741a852598086043f176
    // resulting descriptor: tr(73e0ef552f3e3a4b1b35d1be0476107fb060afb49634ef5ef22ac54171ff0541)
    function testGetBTCDepositAddress_0_testnet() public {
        deriver.setSeed(
            "tb1pw7mg62ewhyap63q33n8zhaq2suxp8veukt7rfl63a4r5uarlxeaq6y4tp0",
            "tb1pjj6trem8djhhpsxq0n4cf3erln3qn95falxhgx59ykvqsczr79mqy55l87",
            BitcoinNetworkEncoder.Network.Testnet
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x388C818CA8B9251b393131C08a736A67ccB19297
        );
        assertEq(
            btcAddress,
            "tb1paz50paqaeph7xecyt8hzc9ly3sfyuaw0nmaaahat8mn37hrlhcjqep3fr6"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 77b68d2b2eb93a1d44118cce2bf40a870c13b33cb2fc34ff51ed474e747f367a
    // pk2: 94b4b1e7676caf70c0c07ceb84c723fce2099689efcd741a852598086043f176
    // resulting descriptor: tr(73e0ef552f3e3a4b1b35d1be0476107fb060afb49634ef5ef22ac54171ff0541)
    function testGetBTCDepositAddress_0_regtest() public {
        deriver.setSeed(
            "bcrt1pw7mg62ewhyap63q33n8zhaq2suxp8veukt7rfl63a4r5uarlxeaqhald54",
            "bcrt1pjj6trem8djhhpsxq0n4cf3erln3qn95falxhgx59ykvqsczr79mqfd7ejy",
            BitcoinNetworkEncoder.Network.Regtest
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x388C818CA8B9251b393131C08a736A67ccB19297
        );
        assertEq(
            btcAddress,
            "bcrt1paz50paqaeph7xecyt8hzc9ly3sfyuaw0nmaaahat8mn37hrlhcjq5cm0kq"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 77b68d2b2eb93a1d44118cce2bf40a870c13b33cb2fc34ff51ed474e747f367a
    // pk2: 94b4b1e7676caf70c0c07ceb84c723fce2099689efcd741a852598086043f176
    // resulting descriptor: tr(73e0ef552f3e3a4b1b35d1be0476107fb060afb49634ef5ef22ac54171ff0541)
    function testGetBTCDepositAddress_0_simnet() public {
        deriver.setSeed(
            "sb1pw7mg62ewhyap63q33n8zhaq2suxp8veukt7rfl63a4r5uarlxeaqa4lvc2",
            "sb1pjj6trem8djhhpsxq0n4cf3erln3qn95falxhgx59ykvqsczr79mqr97c7m",
            BitcoinNetworkEncoder.Network.Simnet
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x388C818CA8B9251b393131C08a736A67ccB19297
        );
        assertEq(
            btcAddress,
            "sb1paz50paqaeph7xecyt8hzc9ly3sfyuaw0nmaaahat8mn37hrlhcjq7smw6l"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 0000000000000000000000000000000000000000000000000000000000000001
    // pk2: f1ec99e484b7c7f31f22a19d6f8f59508abb3e86bdf8ff4d4f6afbd8bb4133d8
    // resulting descriptor: tr(9829a5f5185b5556d42ee4fcd80cceabacc6abd6eea3904b0d95547b265a6b80)
    function testGetBTCDepositAddress_1_mainnet() public {
        deriver.setSeed(
            "bc1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqs5pgpxg",
            "bc1p78kfneyyklrlx8ez5xwklr6e2z9tk05xhhu07n20dtaa3w6px0vqa3ptvn",
            BitcoinNetworkEncoder.Network.Mainnet
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x5e17BFfaD9f5D57Bcc17071aec4249C9176A728d
        );
        assertEq(
            btcAddress,
            "bc1pc5ydppgpkeg5nrcetqu8g0rjeytsqww3j6xq50tlulqvwnfhhxcs9403q9"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 0000000000000000000000000000000000000000000000000000000000000001
    // pk2: f1ec99e484b7c7f31f22a19d6f8f59508abb3e86bdf8ff4d4f6afbd8bb4133d8
    // resulting descriptor: tr(9829a5f5185b5556d42ee4fcd80cceabacc6abd6eea3904b0d95547b265a6b80)
    function testGetBTCDepositAddress_1_testnet() public {
        deriver.setSeed(
            "tb1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqsrf7wu8",
            "tb1p78kfneyyklrlx8ez5xwklr6e2z9tk05xhhu07n20dtaa3w6px0vq2ehyku",
            BitcoinNetworkEncoder.Network.Testnet
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x5e17BFfaD9f5D57Bcc17071aec4249C9176A728d
        );
        assertEq(
            btcAddress,
            "tb1pc5ydppgpkeg5nrcetqu8g0rjeytsqww3j6xq50tlulqvwnfhhxcsjae762"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 0000000000000000000000000000000000000000000000000000000000000001
    // pk2: f1ec99e484b7c7f31f22a19d6f8f59508abb3e86bdf8ff4d4f6afbd8bb4133d8
    // resulting descriptor: tr(9829a5f5185b5556d42ee4fcd80cceabacc6abd6eea3904b0d95547b265a6b80)
    function testGetBTCDepositAddress_1_regtest() public {
        deriver.setSeed(
            "bcrt1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqsws5gfa",
            "bcrt1p78kfneyyklrlx8ez5xwklr6e2z9tk05xhhu07n20dtaa3w6px0vq8qazrx",
            BitcoinNetworkEncoder.Network.Regtest
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x5e17BFfaD9f5D57Bcc17071aec4249C9176A728d
        );
        assertEq(
            btcAddress,
            "bcrt1pc5ydppgpkeg5nrcetqu8g0rjeytsqww3j6xq50tlulqvwnfhhxcslync0s"
        );
    }

    // This test was generated automatically in Go.
    // pk1: 0000000000000000000000000000000000000000000000000000000000000001
    // pk2: f1ec99e484b7c7f31f22a19d6f8f59508abb3e86bdf8ff4d4f6afbd8bb4133d8
    // resulting descriptor: tr(9829a5f5185b5556d42ee4fcd80cceabacc6abd6eea3904b0d95547b265a6b80)
    function testGetBTCDepositAddress_1_simnet() public {
        deriver.setSeed(
            "sb1pqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqsyc5f9z",
            "sb1p78kfneyyklrlx8ez5xwklr6e2z9tk05xhhu07n20dtaa3w6px0vqdgar0e",
            BitcoinNetworkEncoder.Network.Simnet
        );

        string memory btcAddress = deriver.getBTCDepositAddress(
            0x5e17BFfaD9f5D57Bcc17071aec4249C9176A728d
        );
        assertEq(
            btcAddress,
            "sb1pc5ydppgpkeg5nrcetqu8g0rjeytsqww3j6xq50tlulqvwnfhhxcs4vner0"
        );
    }
}
