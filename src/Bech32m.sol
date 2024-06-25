// SPDX-License-Identifier: MIT
// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py

pragma solidity ^0.8.24;

error EncodingIsUnknown();

library Bech32m {

    enum BechEncoding {
        // Used is SegWit v.0
        BECH32,
        // Used in SegWit v.1, e.g. Taproot
        BECH32M,
        // Specifies an unknown encoding, usually it means some error
        UNKNOWN
    }

    enum DecodeError {
        NoError,
        IncorrectPadding,
        IncorrectLength,
        CharacterOutOfRange,
        MixedCase,
        //checksum does not match
        IncorrectChecksum,
        //checksum bytes length is too short
        TooShortChecksum,
        InputIsTooLong,
        NotBech32Character,
        // Network prefix is not set
        HRPIsEmpty,
        NoDelimiter,
        // decoded HRP is different from expected HRP
        HRPMismatch,
        EmptyData,
        // witness program should be at least 2 bytes
        WitnessProgramTooSmall,
        // witness program should be maximum 40 bytes
        WitnessProgramTooLarge,
        // segwit version should be from 0 to 16 (including). Got some larger number.
        SegwitVersionTooLarge,
        // Length of segwit v0 program should be either 20 or 32 bytes. 20 for PWKH, 32 for P2WSH
        IncorrectSegwitV0Program,
        // Segwit v0 should be encoded using Bech32
        IncorrectEncodingForSegwitV0,
        // Segwit with versions 1-16 should be encoded with Bech32m
        IncorrectEncodingForSegwitVn
    }

    // Possible characters for Bitcoin address
    bytes internal constant CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";

    // index is character code in ASCII
    // value is Bech32 character value
    // if value is 0x7f=127 then character is not in the Bech32 charset
    bytes internal constant REVERSE_CHARSET =
        hex"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f0f7f0a1115141a1e07057f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f1d7f180d190908177f12161f1b137f010003100b1c0c0e0604027f7f7f7f7f";

    // Bech32m constant
    uint256 internal constant BECH32M_CONST = 0x2bc830a3;

    // 1 byte for the separator
    bytes1 internal constant SEPARATOR = bytes1(0x31);

    // Internal function that computes the Bech32 checksum.
    function polymod(uint[] memory values) internal pure returns (uint) {

        // Generator constants
        uint32[5] memory GENERATOR = [
            0x3b6a57b2,
            0x26508e6d,
            0x1ea119fa,
            0x3d4233dd,
            0x2a1462b3
        ];

        uint chk = 1;
        for (uint p = 0; p < values.length; p++) {
            uint top = chk >> 25;
            chk = ((chk & 0x1ffffff) << 5) ^ values[p];
            for (uint i = 0; i < 5; i++) {
                if ((top >> i) & 1 == 1) {
                    chk ^= GENERATOR[i];
                }
            }
        }
        return chk;
    }

    // Expand the HRP into values for checksum computation.
    // hrpExpand DOES NOT check the validity of the HRP
    function hrpExpand(bytes memory hrp) public pure returns (bytes memory) {

        bytes memory a = new bytes(hrp.length + hrp.length + 1);
        for (uint i = 0; i < hrp.length; i += 1) {
            a[i] = hrp[i] >> 5;
            a[i + hrp.length + 1] = bytes1(uint8(hrp[i]) & 31);
        }
        a[hrp.length] = 0;
        return a;
    }

    // Verify a checksum given HRP and converted data characters.
    function verifyChecksum(
        bytes memory hrp,
        bytes memory data
    ) internal pure returns (BechEncoding) {

        bytes memory hrpExpandBytes = hrpExpand(hrp);

        uint[] memory polymodArg = new uint[](
            hrpExpandBytes.length + data.length
        );
        for (uint i = 0; i < hrpExpandBytes.length; i += 1) {
            polymodArg[i] = uint8(hrpExpandBytes[i]);
        }
        for (uint i = 0; i < data.length; i += 1) {
            polymodArg[i + hrpExpandBytes.length] = uint8(data[i]);
        }

        uint polymodVal = polymod(polymodArg);
        if (polymodVal == 1) {
            return BechEncoding.BECH32;
        }
        if (polymodVal == BECH32M_CONST) {
            return BechEncoding.BECH32M;
        }

        return BechEncoding.UNKNOWN;
    }


    // check that all characters are in the range 33-126 inclusive\
    function isValidCharacterRange(
        bytes memory bech
    ) public pure returns (bool) {
        for (uint i = 0; i < bech.length; i += 1) {
            if (uint8(bech[i]) < 33 || uint8(bech[i]) > 126) {
                return false;
            }
        }
        return true;
    }

    function isMixedCase(bytes memory b) public pure returns (bool) {
        bool hasLower = false;
        bool hasUpper = false;

        // The range of ASCII values for uppercase letters A-Z is 65-90,
        // and the range for lowercase letters a-z is 97-122.
        for (uint i = 0; i < b.length; i += 1) {
            if (uint8(b[i]) >= 97 && uint8(b[i]) <= 122) {
                hasLower = true;
            } else if (uint8(b[i]) >= 65 && uint8(b[i]) <= 90) {
                hasUpper = true;
            }
            if (hasLower && hasUpper) {
                return true;
            }
        }

        return false;
    }

    function toLower(bytes memory a) public pure returns (bytes memory) {
        bytes memory b = new bytes(a.length);
        for (uint i = 0; i < a.length; i += 1) {
            if (uint8(a[i]) >= 65 && uint8(a[i]) <= 90) {
                b[i] = bytes1(uint8(a[i]) + 32);
            } else {
                b[i] = a[i];
            }
        }
        return b;
    }

    // start included
    // stop excluded
    function decodeCharactersBech32(
        bytes memory bech,
        uint start,
        uint stop
    ) public pure returns (bytes memory, DecodeError) {
        bytes memory decoded = new bytes(stop - start);
        for (uint i = start; i < stop; i += 1) {
            uint8 c = uint8(bech[i]);
            if (c >= REVERSE_CHARSET.length || REVERSE_CHARSET[c] == 0x7f) {
                return (new bytes(0), DecodeError.NotBech32Character);
            }
            decoded[i - start] = REVERSE_CHARSET[c];
        }
        return (decoded, DecodeError.NoError);
    }

    function bech32Decode(
        bytes memory bech
    )
        public
        pure
        returns (bytes memory, bytes memory, BechEncoding, DecodeError)
    {
        if (bech.length > 90) {
            return (
                new bytes(0),
                new bytes(0),
                BechEncoding.UNKNOWN,
                DecodeError.InputIsTooLong
            );
        }

        if (!isValidCharacterRange(bech)) {
            return (
                new bytes(0),
                new bytes(0),
                BechEncoding.UNKNOWN,
                DecodeError.CharacterOutOfRange
            );
        }

        if (isMixedCase(bech)) {
            return (
                new bytes(0),
                new bytes(0),
                BechEncoding.UNKNOWN,
                DecodeError.MixedCase
            );
        }

        bytes memory bechLow = toLower(bech);
        int delimiterPos = int256(bechLow.length) - 1;
        while (true) {
            delimiterPos -= 1;
            if (delimiterPos < 0) {
                return (
                    new bytes(0),
                    new bytes(0),
                    BechEncoding.UNKNOWN,
                    DecodeError.NoDelimiter
                );
            }
            // 0x31 is '1'
            if (bechLow[uint256(delimiterPos)] == 0x31) {
                break;
            }
        }
        if (delimiterPos < 1) {
            return (
                new bytes(0),
                new bytes(0),
                BechEncoding.UNKNOWN,
                DecodeError.HRPIsEmpty
            );
        }
        if (delimiterPos + 7 > int(bechLow.length)) {
            return (
                new bytes(0),
                new bytes(0),
                BechEncoding.UNKNOWN,
                DecodeError.TooShortChecksum
            );
        }

        bytes memory hrp = new bytes(uint(delimiterPos));
        for (uint i = 0; i < uint(delimiterPos); i += 1) {
            hrp[i] = bechLow[i];
        }

        (bytes memory dataAll5Bit, DecodeError err) = decodeCharactersBech32(
            bechLow,
            uint(delimiterPos + 1),
            bechLow.length
        );
        if (err != DecodeError.NoError) {
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, err);
        }

        BechEncoding spec = verifyChecksum(hrp, dataAll5Bit);
        if (spec == BechEncoding.UNKNOWN) {
            return (
                new bytes(0),
                new bytes(0),
                BechEncoding.UNKNOWN,
                DecodeError.IncorrectChecksum
            );
        }

        bytes memory data5Bit = new bytes(dataAll5Bit.length - 6);
        for (uint i = 0; i < data5Bit.length; i += 1) {
            data5Bit[i] = dataAll5Bit[i];
        }

        return (hrp, data5Bit, spec, DecodeError.NoError);
    }

    // Decode a segwit address
    function decodeSegwitAddress(
        bytes calldata expectedHrp,
        bytes calldata addr
    ) public pure returns (uint8, bytes memory, DecodeError) {
        (
            bytes memory hrpGot,
            bytes memory data5Bit,
            BechEncoding spec,
            DecodeError err
        ) = bech32Decode(addr);


        bytes memory data8Bit;

        return (uint8(data5Bit[0]), data8Bit, DecodeError.NoError);
    }
}
