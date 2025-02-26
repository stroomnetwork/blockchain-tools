// SPDX-License-Identifier: MIT
// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py

pragma solidity ^0.8.27;

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

    function explainDecodeError(DecodeError err) internal pure returns (string memory) {
        if (err == DecodeError.NoError) {
            return string("No error");
        } else if (err == DecodeError.IncorrectPadding) {
            return string("Incorrect Padding");
        } else if (err == DecodeError.IncorrectLength) {
            return string("Incorrect address length");
        } else if (err == DecodeError.CharacterOutOfRange) {
            return string("Address contain character out of range");
        } else if (err == DecodeError.MixedCase) {
            return string("Address consists of both capital and small letters");
        } else if (err == DecodeError.IncorrectChecksum) {
            return string("Address checksum does not match");
        } else if (err == DecodeError.TooShortChecksum) {
            return string("Address checksum is too short");
        } else if (err == DecodeError.InputIsTooLong) {
            return string("Address is too long");
        } else if (err == DecodeError.NotBech32Character) {
            return string("Address contains character which is not in bech32 encoding");
        } else if (err == DecodeError.HRPIsEmpty) {
            return string("Network prefix is empty");
        } else if (err == DecodeError.NoDelimiter) {
            return string("No prefix delimiter in the address");
        } else if (err == DecodeError.HRPMismatch) {
            return string("Network prefix is different from expected");
        } else if (err == DecodeError.WitnessProgramTooSmall) {
            return string("Witness program should be at least 2 bytes");
        } else if (err == DecodeError.EmptyData) {
            return string("Witness program is empty");
        } else if (err == DecodeError.WitnessProgramTooLarge) {
            return string("Witness program should be maximum 40 bytes");
        } else if (err == DecodeError.SegwitVersionTooLarge) {
            return string("Segwit version should be from 0 to 16 (including). Got some larger number.");
        } else if (err == DecodeError.IncorrectSegwitV0Program) {
            return string("Length of segwit v0 program should be either 20 or 32 bytes");
        } else if (err == DecodeError.IncorrectEncodingForSegwitV0) {
            return string("Segwit v0 should be encoded using Bech32");
        } else if (err == DecodeError.IncorrectEncodingForSegwitVn) {
            return string("Segwit with versions 1-16 should be encoded with Bech32m");
        }
        return "";
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
            for (uint i = 0; i < 5; ++i) {
                if ((top >> i) & 1 == 1) {
                    chk ^= GENERATOR[i];
                }
            }
        }
        return chk;
    }

    // Expand the HRP into values for checksum computation.
    // hrpExpand DOES NOT check the validity of the HRP
    function hrpExpand(bytes memory hrp) internal pure returns (bytes memory) {

        bytes memory a = new bytes(hrp.length + hrp.length + 1);
        for (uint i = 0; i < hrp.length; i += 1) {
            a[i] = hrp[i] >> 5;
            a[i + hrp.length + 1] = bytes1(uint8(hrp[i]) & 31);
        }
        a[hrp.length] = 0;
        return a;
    }

    // Compute the checksum values given HRP and data.
    function createChecksum(
        bytes memory hrp,
        bytes memory data,
        BechEncoding spec
    ) internal pure returns (bytes memory) {

        // TODO(mkl): add check for UNKNOWN encoding
        uint const = spec == BechEncoding.BECH32M ? BECH32M_CONST : 1;
        bytes memory hrpExpandBytes = hrpExpand(hrp);
        uint[] memory polymodArg = new uint[](
            hrpExpandBytes.length + data.length + 6
        );

        for (uint i = 0; i < hrpExpandBytes.length; i += 1) {
            polymodArg[i] = uint8(hrpExpandBytes[i]);
        }
        for (uint i = 0; i < data.length; i += 1) {
            polymodArg[i + hrpExpandBytes.length] = uint8(data[i]);
        }

        uint polymodVal = polymod(polymodArg) ^ const;

        bytes memory chk = new bytes(6);

        chk[0] = bytes1(uint8((polymodVal >> (5 * (5))) & 31));
        chk[1] = bytes1(uint8((polymodVal >> (5 * (4))) & 31));
        chk[2] = bytes1(uint8((polymodVal >> (5 * (3))) & 31));
        chk[3] = bytes1(uint8((polymodVal >> (5 * (2))) & 31));
        chk[4] = bytes1(uint8((polymodVal >> (5 * (1))) & 31));
        chk[5] = bytes1(uint8((polymodVal >> (5 * (0))) & 31));

        return chk;
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

    // Compute a Bech32 string given HRP and data values.
    function bech32Encode(
        bytes memory hrp,
        bytes memory data,
        BechEncoding spec
    ) internal pure returns (bytes memory) {

        if (spec == BechEncoding.UNKNOWN) {
            revert EncodingIsUnknown();
        }
        // 6 bytes of the checksum in a 5-bit format
        bytes memory chk = createChecksum(hrp, data, spec);

        // <hrp> 1 <data-5bit-format> <6bytes of chk-5bit-format>

        // reuse data and chk arrays to modify data in place to save gas

        for (uint i = 0; i < data.length; i += 1) {
            // ret[i + hrp.length + 1] = CHARSET[uint8(data[i])];
            data[i] = CHARSET[uint8(data[i])];
        }

        for (uint i = 0; i < 6; i += 1) {
            // ret[startChk + i] = CHARSET[uint8(chk[i])];
            chk[i] = CHARSET[uint8(chk[i])];
        }

        return bytes.concat(hrp, SEPARATOR, data, chk);
    }

    // Convert 5 bytes to 8 groups of 5 bits, with padding
    function conver8To5(bytes memory a) internal pure returns (bytes memory) {
        // We group the data into 5-byte groups
        // Because 5-byte group has the bitlength 40
        // Thus it can be easily converted to 8 5-bit groups.
        uint nGroup40bit = a.length / 5;

        // Some input bytes may not get into 5-byte input group
        // so we need to process the remaining bytes
        uint nRemainInp8bit = a.length % 5;

        // 0: 0 -> 0
        // 1: 8 -> 2
        // 2: 16 -> 4
        // 3: 24 -> 5
        // 4: 32 -> 7
        // Number of additional 5-bits should be added
        uint nRemainOut5Bit = 0;
        // Number of padding bits should be added
        uint nPadBits = 0;
        if (nRemainInp8bit == 1) {
            nRemainOut5Bit = 2;
            nPadBits = 2;
        } else if (nRemainInp8bit == 2) {
            nRemainOut5Bit = 4;
            nPadBits = 4;
        } else if (nRemainInp8bit == 3) {
            nRemainOut5Bit = 5;
            nPadBits = 1;
        } else if (nRemainInp8bit == 4) {
            nRemainOut5Bit = 7;
            nPadBits = 3;
        }

        uint outLen = nGroup40bit * 8 + nRemainOut5Bit;
        bytes memory b = new bytes(outLen);

        for (uint ig = 0; ig < nGroup40bit; ig += 1) {
            uint i = ig * 5;
            uint j = ig * 8;
            uint w = 256 ** 4 *
                uint(uint8(a[i])) +
                256 ** 3 *
                uint(uint8(a[i + 1])) +
                256 ** 2 *
                uint(uint8(a[i + 2])) +
                256 *
                uint(uint8(a[i + 3])) +
                uint(uint8(a[i + 4]));
            b[j + 7] = bytes1(uint8(w & 31));
            b[j + 6] = bytes1(uint8((w >> 5) & 31));
            b[j + 5] = bytes1(uint8((w >> 10) & 31));
            b[j + 4] = bytes1(uint8((w >> 15) & 31));
            b[j + 3] = bytes1(uint8((w >> 20) & 31));
            b[j + 2] = bytes1(uint8((w >> 25) & 31));
            b[j + 1] = bytes1(uint8((w >> 30) & 31));
            b[j] = bytes1(uint8((w >> 35) & 31));
        }

        if (nRemainOut5Bit > 0) {
            uint w;
            for (uint i = nGroup40bit * 5; i < a.length; i += 1) {
                w = (w << 8) + uint(uint8(a[i]));
            }
            w <<= nPadBits;
            for (uint j = 0; j < nRemainOut5Bit; j += 1) {
                b[nGroup40bit * 8 + j] = bytes1(
                    uint8((w >> (5 * (nRemainOut5Bit - j - 1))) & 31)
                );
            }
        }

        return b;
    }

    function encodeSegwitAddress(
        bytes memory hrp,
        uint8 witVer,
        bytes memory witProg
    ) internal pure returns (bytes memory) {
        BechEncoding spec = witVer == 0
            ? BechEncoding.BECH32
            : BechEncoding.BECH32M;

        bytes memory witProg5bit = conver8To5(witProg);
        bytes memory encArg = bytes.concat(bytes1(witVer), witProg5bit);

        return bech32Encode(hrp, encArg, spec);
    }

    // Convert 8 groups of 5 bits to 5 bytes
    function convert5to8(
        bytes memory data5Bits
    ) internal pure returns (bytes memory, DecodeError) {
        uint vRest;
        uint nRest5Bits = data5Bits.length % 8;
        uint nRest8Bits;
        uint nGroups40Bits = data5Bits.length / 8;
        uint startRest5Bit = nGroups40Bits * 8;
        uint startRest8Bit = nGroups40Bits * 5;

        if (nRest5Bits == 1) {
            return (new bytes(0), DecodeError.IncorrectLength);
        } else if (nRest5Bits == 2) {
            if (uint8(data5Bits[data5Bits.length - 1]) & 3 == 0) {
                vRest =
                    (uint(uint8(data5Bits[startRest5Bit])) << 5) +
                    uint(uint8(data5Bits[startRest5Bit + 1]));
                vRest >>= 2;
                nRest8Bits = 1;
            } else {
                return (new bytes(0), DecodeError.IncorrectPadding);
            }
        } else if (nRest5Bits == 3) {
            return (new bytes(0), DecodeError.IncorrectLength);
        } else if (nRest5Bits == 4) {
            if (uint8(data5Bits[data5Bits.length - 1]) & 15 == 0) {
                vRest =
                    (uint(uint8(data5Bits[startRest5Bit])) << 15) +
                    (uint(uint8(data5Bits[startRest5Bit + 1])) << 10) +
                    (uint(uint8(data5Bits[startRest5Bit + 2])) << 5) +
                    uint(uint8(data5Bits[startRest5Bit + 3]));
                vRest >>= 4;
                nRest8Bits = 2;
            } else {
                return (new bytes(0), DecodeError.IncorrectPadding);
            }
        } else if (nRest5Bits == 5) {
            if (uint8(data5Bits[data5Bits.length - 1]) & 1 == 0) {
                vRest =
                    (uint(uint8(data5Bits[startRest5Bit])) << 20) +
                    (uint(uint8(data5Bits[startRest5Bit + 1])) << 15) +
                    (uint(uint8(data5Bits[startRest5Bit + 2])) << 10) +
                    (uint(uint8(data5Bits[startRest5Bit + 3])) << 5) +
                    (uint(uint8(data5Bits[startRest5Bit + 4])));
                vRest >>= 1;
                nRest8Bits = 3;
            } else {
                return (new bytes(0), DecodeError.IncorrectPadding);
            }
        } else if (nRest5Bits == 6) {
            return (new bytes(0), DecodeError.IncorrectLength);
        } else if (nRest5Bits == 7) {
            if (uint8(data5Bits[data5Bits.length - 1]) & 7 == 0) {
                vRest =
                    (uint(uint8(data5Bits[startRest5Bit])) << 30) +
                    (uint(uint8(data5Bits[startRest5Bit + 1])) << 25) +
                    (uint(uint8(data5Bits[startRest5Bit + 2])) << 20) +
                    (uint(uint8(data5Bits[startRest5Bit + 3])) << 15) +
                    (uint(uint8(data5Bits[startRest5Bit + 4])) << 10) +
                    (uint(uint8(data5Bits[startRest5Bit + 5])) << 5) +
                    uint(uint8(data5Bits[startRest5Bit + 6]));
                vRest >>= 3;
                nRest8Bits = 4;
            } else {
                return (new bytes(0), DecodeError.IncorrectPadding);
            }
        }

        bytes memory rez8Bits = new bytes(nGroups40Bits * 5 + nRest8Bits);

        for (uint ig = 0; ig < nGroups40Bits; ig += 1) {
            uint i = ig * 8;
            uint j = ig * 5;
            uint v = (uint(uint8(data5Bits[i])) << 35);
            v += (uint(uint8(data5Bits[i + 1])) << 30);
            v += (uint(uint8(data5Bits[i + 2])) << 25);
            v += (uint(uint8(data5Bits[i + 3])) << 20);
            v += (uint(uint8(data5Bits[i + 4])) << 15);
            v += (uint(uint8(data5Bits[i + 5])) << 10);
            v += (uint(uint8(data5Bits[i + 6])) << 5);
            v += uint(uint8(data5Bits[i + 7]));
            rez8Bits[j] = bytes1(uint8((v >> 32) & 255));
            rez8Bits[j + 1] = bytes1(uint8((v >> 24) & 255));
            rez8Bits[j + 2] = bytes1(uint8((v >> 16) & 255));
            rez8Bits[j + 3] = bytes1(uint8((v >> 8) & 255));
            rez8Bits[j + 4] = bytes1(uint8((v) & 255));
        }

        if (nRest8Bits == 1) {
            rez8Bits[startRest8Bit] = bytes1(uint8(vRest & 255));
        } else if (nRest8Bits == 2) {
            rez8Bits[startRest8Bit] = bytes1(uint8((vRest >> 8) & 255));
            rez8Bits[startRest8Bit + 1] = bytes1(uint8(vRest & 255));
        } else if (nRest8Bits == 3) {
            rez8Bits[startRest8Bit] = bytes1(uint8((vRest >> 16) & 255));
            rez8Bits[startRest8Bit + 1] = bytes1(uint8((vRest >> 8) & 255));
            rez8Bits[startRest8Bit + 2] = bytes1(uint8(vRest & 255));
        } else if (nRest8Bits == 4) {
            rez8Bits[startRest8Bit] = bytes1(uint8((vRest >> 24) & 255));
            rez8Bits[startRest8Bit + 1] = bytes1(uint8((vRest >> 16) & 255));
            rez8Bits[startRest8Bit + 2] = bytes1(uint8((vRest >> 8) & 255));
            rez8Bits[startRest8Bit + 3] = bytes1(uint8(vRest & 255));
        }

        return (rez8Bits, DecodeError.NoError);
    }

    // check that all characters are in the range 33-126 inclusive\
    function isValidCharacterRange(
        bytes memory bech
    ) internal pure returns (bool) {
        for (uint i = 0; i < bech.length; i += 1) {
            if (uint8(bech[i]) < 33 || uint8(bech[i]) > 126) {
                return false;
            }
        }
        return true;
    }

    function isMixedCase(bytes memory b) internal pure returns (bool) {
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

    function toLower(bytes memory a) internal pure returns (bytes memory) {
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
    ) internal pure returns (bytes memory, DecodeError) {
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
        internal
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

    function areBytesEqual(
        bytes memory a,
        bytes memory b
    ) internal pure returns (bool) {
        if (a.length != b.length) {
            return false;
        }
        for (uint i = 0; i < a.length; i += 1) {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    // Decode a segwit address
    function decodeSegwitAddress(
        bytes memory expectedHrp,
        bytes memory addr
    ) internal pure returns (uint8, bytes memory, DecodeError) {
        (
            bytes memory hrpGot,
            bytes memory data5Bit,
            BechEncoding spec,
            DecodeError err
        ) = bech32Decode(addr);
        if (err != DecodeError.NoError) {
            return (0, new bytes(0), err);
        }

        if (!areBytesEqual(expectedHrp, hrpGot)) {
            return (0, new bytes(0), DecodeError.HRPMismatch);
        }

        if (data5Bit.length == 0) {
            return (0, new bytes(0), DecodeError.EmptyData);
        }

        if (uint8(data5Bit[0]) > 16) {
            return (0, new bytes(0), DecodeError.SegwitVersionTooLarge);
        }

        bytes memory data5BitNoVer = new bytes(data5Bit.length - 1);
        for (uint i = 0; i < data5BitNoVer.length; i += 1) {
            data5BitNoVer[i] = data5Bit[i + 1];
        }

        bytes memory data8Bit;
        (data8Bit, err) = convert5to8(data5BitNoVer);
        if (err != DecodeError.NoError) {
            return (0, new bytes(0), err);
        }

        if (data8Bit.length < 2) {
            return (0, new bytes(0), DecodeError.WitnessProgramTooSmall);
        }

        if (data8Bit.length > 40) {
            return (0, new bytes(0), DecodeError.WitnessProgramTooLarge);
        }

        if (
            uint8(data5Bit[0]) == 0 &&
            data8Bit.length != 20 &&
            data8Bit.length != 32
        ) {
            return (0, new bytes(0), DecodeError.IncorrectSegwitV0Program);
        }

        if (uint8(data5Bit[0]) == 0 && spec != BechEncoding.BECH32) {
            return (0, new bytes(0), DecodeError.IncorrectEncodingForSegwitV0);
        }

        if (uint8(data5Bit[0]) != 0 && spec != BechEncoding.BECH32M) {
            return (0, new bytes(0), DecodeError.IncorrectEncodingForSegwitVn);
        }

        return (uint8(data5Bit[0]), data8Bit, DecodeError.NoError);
    }
}
