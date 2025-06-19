// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "forge-std/console.sol";

import "./Base58.sol";
import "./BitcoinNetworkEncoder.sol";

contract BitcoinUtils {
    // There are currently three invoice address formats in use:

    // P2PKH which begin with the number 1, eg: 1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2
    // P2SH type starting with the number 3, eg: 3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy
    // Bech32 type starting with bc1, eg: bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq

    // Testnet:
    // P2PKH which begin with the number m or n, eg: mipcBbFg9gMiCh81Kj8tqqdgoZub1ZJRfn
    // P2SH type starting with the number 2, eg: 2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc
    // Bech32 type starting with tb1, eg: tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx

    // Regtest:
    // P2PKH which begin with the number m or n, eg: mipcBbFg9gMiCh81Kj8tqqdgoZub1ZJRfn
    // P2SH type starting with the number 2, eg: 2MzQwSSnBHWHqSAqtTVQ6v47XtaisrJa1Vc
    // Bech32 type starting with bcrt1, eg: bcrt1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx
    // Taproot address, eg: bcrt1pnmrmugapastum8ztvgwcn8hvq2avmcwh2j4ssru7rtyygkpqq98q4wyd6s

    string constant BECH32_ALPHABET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";

    function BECH32_ALPHABET_MAP(bytes1 char) public view returns (uint8) {
        // '{"0":15,"2":10,"3":17,"4":21,"5":20,"6":26,"7":30,"8":7,"9":5,"q":0,"p":1,"z":2,"r":3,"y":4,"x":6,"g":8,"f":9,"t":11,"v":12,"d":13,"w":14,"s":16,"j":18,"n":19,"k":22,"h":23,"c":24,"e":25,"m":27,"u":28,"a":29,"l":31}'

        if (char == bytes1("0")) return 15;
        if (char == bytes1("2")) return 10;
        if (char == bytes1("3")) return 17;
        if (char == bytes1("4")) return 21;
        if (char == bytes1("5")) return 20;
        if (char == bytes1("6")) return 26;
        if (char == bytes1("8")) return 7;
        if (char == bytes1("7")) return 30;
        if (char == bytes1("9")) return 5;

        if (char == bytes1("q")) return 0;
        if (char == bytes1("p")) return 1;
        if (char == bytes1("z")) return 2;
        if (char == bytes1("r")) return 3;
        if (char == bytes1("y")) return 4;
        if (char == bytes1("x")) return 6;
        if (char == bytes1("g")) return 8;
        if (char == bytes1("f")) return 9;
        if (char == bytes1("t")) return 11;
        if (char == bytes1("v")) return 12;
        if (char == bytes1("d")) return 13;
        if (char == bytes1("w")) return 14;
        if (char == bytes1("s")) return 16;
        if (char == bytes1("j")) return 18;
        if (char == bytes1("n")) return 19;
        if (char == bytes1("k")) return 22;
        if (char == bytes1("h")) return 23;
        if (char == bytes1("c")) return 24;
        if (char == bytes1("e")) return 25;
        if (char == bytes1("m")) return 27;
        if (char == bytes1("u")) return 28;
        if (char == bytes1("a")) return 29;
        if (char == bytes1("l")) return 31;

        console.log("Invalid character");
        console.logBytes1(char);

        return type(uint8).max;
    }

    function validateBitcoinAddress(
        BitcoinNetworkEncoder.Network network,
        string calldata BTCAddress
    ) public view returns (bool)
    {
        bytes memory empty;

        if (equalBytes(bytes(BTCAddress), empty)) return false;

        console.log("\nraw address data");
        console.logBytes(bytes(BTCAddress));

        bytes memory BTC_P2PKH = BitcoinNetworkEncoder.getBtcBase58_P2PKH(network);
        bytes memory BTC_P2SH = BitcoinNetworkEncoder.getBtcBase58_P2SH(network);
        bytes memory prefix = BitcoinNetworkEncoder.getBtcBech32Prefix(network);

        if (equalBytes(bytes(BTCAddress)[: 1], BTC_P2PKH) || equalBytes(bytes(BTCAddress)[: 1], BTC_P2SH) &&
        !equalBytes(bytes(BTCAddress)[: prefix.length], prefix)) {
            if (bytes(BTCAddress).length < 26 || bytes(BTCAddress).length > 35 || !alphabetCheck(bytes(BTCAddress))) {
                return false;
            }

            // check base58 checksum and encoding
            return validateBase58Checksum(BTCAddress);
        }

        if (equalBytes(bytes(BTCAddress)[: prefix.length], prefix)) {
            if (network == BitcoinNetworkEncoder.Network.Regtest) {
                if (bytes(BTCAddress).length < 43 || bytes(BTCAddress).length > 64) return false;
            } else {
                if (bytes(BTCAddress).length < 42 || bytes(BTCAddress).length > 62) return false;
            }

            // check bech32 checksum and encoding
            return validateBech32Checksum(BTCAddress);
        }

        return false;
    }

    function equalBytes(bytes memory one, bytes memory two) public pure returns (bool) {
        if (!(one.length == two.length)) {
            return false;
        }
        for (uint256 i = 0; i < one.length; ++i) {
            if (!(one[i] == two[i])) {
                return false;
            }
        }
        return true;
    }

    function alphabetCheck(bytes memory BTCAddress) public pure returns (bool) {
        uint256 BTCAddressLength = BTCAddress.length;
        for (uint256 i = 0; i < BTCAddressLength; ++i) {
            uint8 charCode = uint8(BTCAddress[i]);
            bool contains = isLetter(charCode);
            if (!contains) return false;
        }

        return true;
    }

    function isLetter(uint8 charCode) internal pure returns (bool) {
        if (charCode == 73 || charCode == 79 || charCode == 108) {
            return false;
        }
        if (charCode >= 49 && charCode <= 57) {
            return true;
        }
        if (charCode >= 65 && charCode <= 90) {
            return true;
        }
        if (charCode >= 97 && charCode <= 122) {
            return true;
        }
        return false;
    }

    // This function supports both bech32 (SegWit v0) and bech32m (Taproot/SegWit v1) addresses
    function validateBech32Checksum(string memory btcAddress) public view returns (bool) {
        console.log("\nvalidate bech32 checksum");
        console.log("address");
        console.log(btcAddress);

        bytes memory _btcAddress = bytes(btcAddress);

        if (_btcAddress.length < 8) {
            console.log("too short");
            return false;
        }

        if (_btcAddress.length > 90) {
            console.log("too long");
            return false;
        }

        // Note: Mixed case validation is skipped to optimize gas usage.
        // Most Bitcoin wallets ensure correct case, and checksum validation provides sufficient safety.

        _btcAddress = bytes(btcAddress);

        uint256 split = 0;
        uint256 _btcAddressLength = _btcAddress.length;
        for (uint256 i = 0; i < _btcAddressLength; ++i) {
            if (_btcAddress[i] == "1") {
                split = i;
                break;
            }
        }

        if (split == 0) {
            console.log("no separator");
            return false;
        }

        if (split == 1) {
            console.log("missing prefix");
            return false;
        }

        bytes memory prefix = new bytes(split);
        uint256 wordCharsLength = _btcAddress.length - split - 1;
        bytes memory wordChars = new bytes(wordCharsLength);

        for (uint256 i = 0; i < split; ++i) {
            prefix[i] = _btcAddress[i];
        }
        for (uint256 i = 0; i < wordCharsLength; ++i) {
            wordChars[i] = _btcAddress[i + split + 1];
        }

        console.log("prefix");
        console.logBytes(prefix);

        if (wordChars.length < 6) {
            console.log("data too short");
            return false;
        }

        uint256 chk = prefixChk(bytes(prefix));

        if (chk == 0) {
            console.log("invalid prefix");
            return false;
        }

        bytes memory words = new bytes(wordChars.length);
        uint256 wordsLength = words.length;
        for (uint256 i = 0; i < wordsLength; ++i) {
            bytes1 c = wordChars[i];
            uint8 v = BECH32_ALPHABET_MAP(c);

            // ALPHABET_MAP reverts if the character is not in the map, so this is not needed
            if (v == type(uint8).max) {
                console.log("unknown character");
                console.log(i);
                console.logBytes1(c);
                console.log("char", string(abi.encodePacked(c)));
                return false;
            }

            chk = polymodStep(chk) ^ v;

            // not in the checksum?
            if (i + 6 >= wordChars.length) continue;

            words[i] = bytes1(v);
        }

        console.log("words");
        console.logBytes(words);

        // ENCODING_CONST is bech32 or bech32m
        if (chk != uint256(0x2bc830a3) && chk != 1) {
            console.log("invalid checksum", chk);
            return false;
        }

        console.log("valid checksum", chk);

        return true;
    }

    function polymodStep(uint256 pre) public pure returns (uint256) {
        uint256 b = pre >> 25;

        return (
            ((pre & 0x1ffffff) << 5) ^ ((b >> 0) & 1 == 1 ? 0x3b6a57b2 : 0) ^ ((b >> 1) & 1 == 1 ? 0x26508e6d : 0)
            ^ ((b >> 2) & 1 == 1 ? 0x1ea119fa : 0) ^ ((b >> 3) & 1 == 1 ? 0x3d4233dd : 0)
            ^ ((b >> 4) & 1 == 1 ? 0x2a1462b3 : 0)
        );
    }

    function prefixChk(bytes memory prefix) public pure returns (uint256) {
        uint256 chk = 1;
        uint256 prefixLength = bytes(prefix).length;
        for (uint256 i = 0; i < prefixLength; ++i) {
            uint256 c = uint8(prefix[i]);
            if (c < 33 || c > 126) revert("Invalid prefix");

            chk = polymodStep(chk) ^ (c >> 5);
        }
        chk = polymodStep(chk);

        prefixLength = prefix.length;
        for (uint256 i = 0; i < prefixLength; ++i) {
            uint256 v = uint8(prefix[i]);
            chk = polymodStep(chk) ^ (v & 0x1f);
        }
        return chk;
    }

    function validateBase58Checksum(string calldata btcAddress) public view returns (bool) {
        bytes memory rawData = decodeFromString(btcAddress);

        console.log("validateBase58Checksum");

        console.log("payload");
        console.logBytes(rawData);

        // raw data is: 1 byte version + 20 bytes of data + 4 bytes of checksum
        if (rawData.length != 25) return false;

        // version is 1 byte

        bytes memory version = new bytes(1);
        version[0] = rawData[0];

        console.log("version");
        console.logBytes(version);

        bytes memory payload = new bytes(rawData.length - 1 - 4);
        uint256 payloadLength = rawData.length - 1 - 4;
        for (uint256 i = 0; i < payloadLength; ++i) {
            payload[i] = rawData[i + 1];
        }

        console.log("payload");
        console.logBytes(payload);

        if (payload.length != 20) return false;

        bytes memory checksum = new bytes(4);
        for (uint256 i = 0; i < 4; ++i) {
            checksum[i] = rawData[rawData.length - 4 + i];
        }

        console.log("checksum");
        console.logBytes(checksum);

        bytes32 calculateChecksum = sha256(abi.encodePacked(sha256(abi.encodePacked(version, payload))));

        console.log("calculated checksum");
        console.logBytes32(calculateChecksum);

        if (
            (checksum[0] ^ calculateChecksum[0]) | (checksum[1] ^ calculateChecksum[1])
            | (checksum[2] ^ calculateChecksum[2]) | (checksum[3] ^ calculateChecksum[3]) != 0
        ) return false;

        return true;
    }
}
