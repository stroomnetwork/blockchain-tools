// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// TODO(mkl): what License?
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py
pragma solidity ^0.8;

import {BytesLib} from "./BytesLib.sol";

error EncodingIsUnknown();

library Bech32m {
    enum BechEncoding {
        // Used is SegWit v.0
        BECH32,
        // Used in SegWit v.1, e.g. Taproot
        BECH32M,
        // Specifies an unknown encoding
        // Usually it means some error
        UNKNOWN
    }

    // TODO(mkl): add comment about errors.
    enum DecodeError {
        NoError,
        IncorrectPadding,
        IncorrectLength,
        CharacterOutOfRange,
        MixedCase,
        IncorrectChecksum,
        TooShortChecksum,
        InputIsTooLong,
        NotBech32Character,
        HRPIsEmpty,
        NoDelimiter

        // // decoded HRP is different from expected HRP
        // HRPMismatch

        // // witness program should be at least 2 bytes
        // WitnessProgramTooSmall

        // // witness program should be maximum 40 bytes
        // WitnessProgramTooLarge

        // // segwit version should be from 0 to 16 (including). Got some larger number.
        // SegwitVersionTooLarge

        // // Length of segwit v0 program should be either 20 or 32 bytes. 20 for PWKH, 32 for P2WSH
        // IncorrectSegwitV0Program

        // // Segwit v0 should be encoded using Bech32
        // IncorrectEncodingForSegwitV0

        // // Segwit with versions 1-16 should be encoded with Bech32m
        // IncorrectEncodingForSegwitVn
    }



    // TODO(mkl): implement ExplainDecodeError(DecodeError err) -> string

    // using BytesLib for bytes;

    // CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
    bytes public constant CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";

    // generatated by gen_reverse_charset.py
    // index is character code in ASCII
    // value is Bech32 character value
    // if value is 0x7f=127 then character is not in the Bech32 charset
    bytes public constant REVERSE_CHARSET =
        hex"7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f0f7f0a1115141a1e07057f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f1d7f180d190908177f12161f1b137f010003100b1c0c0e0604027f7f7f7f7f";

    // BECH32M_CONST = 0x2bc830a3
    uint256 public constant BECH32M_CONST = 0x2bc830a3;

    // TODO(mkl): port implementation from C++ reference because it is more readable
    // https://github.com/sipa/bech32/blob/master/ref/c%2B%2B/bech32.cpp
    //     /** This function will compute what 6 5-bit values to XOR into the last 6 input values, in order to
    //  *  make the checksum 0. These 6 values are packed together in a single 30-bit integer. The higher
    //  *  bits correspond to earlier values. */
    // uint32_t polymod(const data& values)
    // {
    //     // The input is interpreted as a list of coefficients of a polynomial over F = GF(32), with an
    //     // implicit 1 in front. If the input is [v0,v1,v2,v3,v4], that polynomial is v(x) =
    //     // 1*x^5 + v0*x^4 + v1*x^3 + v2*x^2 + v3*x + v4. The implicit 1 guarantees that
    //     // [v0,v1,v2,...] has a distinct checksum from [0,v0,v1,v2,...].

    //     // The output is a 30-bit integer whose 5-bit groups are the coefficients of the remainder of
    //     // v(x) mod g(x), where g(x) is the Bech32 generator,
    //     // x^6 + {29}x^5 + {22}x^4 + {20}x^3 + {21}x^2 + {29}x + {18}. g(x) is chosen in such a way
    //     // that the resulting code is a BCH code, guaranteeing detection of up to 3 errors within a
    //     // window of 1023 characters. Among the various possible BCH codes, one was selected to in
    //     // fact guarantee detection of up to 4 errors within a window of 89 characters.

    //     // Note that the coefficients are elements of GF(32), here represented as decimal numbers
    //     // between {}. In this finite field, addition is just XOR of the corresponding numbers. For
    //     // example, {27} + {13} = {27 ^ 13} = {22}. Multiplication is more complicated, and requires
    //     // treating the bits of values themselves as coefficients of a polynomial over a smaller field,
    //     // GF(2), and multiplying those polynomials mod a^5 + a^3 + 1. For example, {5} * {26} =
    //     // (a^2 + 1) * (a^4 + a^3 + a) = (a^4 + a^3 + a) * a^2 + (a^4 + a^3 + a) = a^6 + a^5 + a^4 + a
    //     // = a^3 + 1 (mod a^5 + a^3 + 1) = {9}.

    //     // During the course of the loop below, `c` contains the bitpacked coefficients of the
    //     // polynomial constructed from just the values of v that were processed so far, mod g(x). In
    //     // the above example, `c` initially corresponds to 1 mod g(x), and after processing 2 inputs of
    //     // v, it corresponds to x^2 + v0*x + v1 mod g(x). As 1 mod g(x) = 1, that is the starting value
    //     // for `c`.
    //     uint32_t c = 1;
    //     for (const auto v_i : values) {
    //         // We want to update `c` to correspond to a polynomial with one extra term. If the initial
    //         // value of `c` consists of the coefficients of c(x) = f(x) mod g(x), we modify it to
    //         // correspond to c'(x) = (f(x) * x + v_i) mod g(x), where v_i is the next input to
    //         // process. Simplifying:
    //         // c'(x) = (f(x) * x + v_i) mod g(x)
    //         //         ((f(x) mod g(x)) * x + v_i) mod g(x)
    //         //         (c(x) * x + v_i) mod g(x)
    //         // If c(x) = c0*x^5 + c1*x^4 + c2*x^3 + c3*x^2 + c4*x + c5, we want to compute
    //         // c'(x) = (c0*x^5 + c1*x^4 + c2*x^3 + c3*x^2 + c4*x + c5) * x + v_i mod g(x)
    //         //       = c0*x^6 + c1*x^5 + c2*x^4 + c3*x^3 + c4*x^2 + c5*x + v_i mod g(x)
    //         //       = c0*(x^6 mod g(x)) + c1*x^5 + c2*x^4 + c3*x^3 + c4*x^2 + c5*x + v_i
    //         // If we call (x^6 mod g(x)) = k(x), this can be written as
    //         // c'(x) = (c1*x^5 + c2*x^4 + c3*x^3 + c4*x^2 + c5*x + v_i) + c0*k(x)

    //         // First, determine the value of c0:
    //         uint8_t c0 = c >> 25;

    //         // Then compute c1*x^5 + c2*x^4 + c3*x^3 + c4*x^2 + c5*x + v_i:
    //         c = ((c & 0x1ffffff) << 5) ^ v_i;

    //         // Finally, for each set bit n in c0, conditionally add {2^n}k(x):
    //         if (c0 & 1)  c ^= 0x3b6a57b2; //     k(x) = {29}x^5 + {22}x^4 + {20}x^3 + {21}x^2 + {29}x + {18}
    //         if (c0 & 2)  c ^= 0x26508e6d; //  {2}k(x) = {19}x^5 +  {5}x^4 +     x^3 +  {3}x^2 + {19}x + {13}
    //         if (c0 & 4)  c ^= 0x1ea119fa; //  {4}k(x) = {15}x^5 + {10}x^4 +  {2}x^3 +  {6}x^2 + {15}x + {26}
    //         if (c0 & 8)  c ^= 0x3d4233dd; //  {8}k(x) = {30}x^5 + {20}x^4 +  {4}x^3 + {12}x^2 + {30}x + {29}
    //         if (c0 & 16) c ^= 0x2a1462b3; // {16}k(x) = {21}x^5 +     x^4 +  {8}x^3 + {24}x^2 + {21}x + {19}
    //     }
    //     return c;
    // }

    // def bech32_polymod(values):
    // """Internal function that computes the Bech32 checksum."""
    // generator = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    // chk = 1
    // for value in values:
    //     top = chk >> 25
    //     chk = (chk & 0x1ffffff) << 5 ^ value
    //     for i in range(5):
    //         chk ^= generator[i] if ((top >> i) & 1) else 0
    // return chk
    // TODO(mkl): what this function is actually doing?
    // TODO(mkl): should values be bytes?
    function polymod(uint[] memory values) public pure returns (uint) {
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

    // def bech32_hrp_expand(hrp):
    //     """Expand the HRP into values for checksum computation."""
    //     return [ord(x) >> 5 for x in hrp] + [0] + [ord(x) & 31 for x in hrp]
    // According to https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
    // The human-readable part, which is intended to convey the type of data, or anything else that is relevant to the reader.
    // This part MUST contain 1 to 83 US-ASCII characters, with each character having a value in the range [33-126].
    // HRP validity may be further restricted by specific applications.
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

    // def bech32_create_checksum(hrp, data, spec):
    // """Compute the checksum values given HRP and data."""
    //     values = bech32_hrp_expand(hrp) + data
    //     const = BECH32M_CONST if spec == Encoding.BECH32M else 1
    //     polymod = bech32_polymod(values + [0, 0, 0, 0, 0, 0]) ^ const
    //     return [(polymod >> 5 * (5 - i)) & 31 for i in range(6)]
    function createChecksum(
        bytes memory hrp,
        bytes memory data,
        BechEncoding spec
    ) public pure returns (bytes memory) {
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

        // TODO(mkl): unroll the loop
        bytes memory chk = new bytes(6);
        for (uint p = 0; p < 6; p += 1) {
            chk[p] = bytes1(uint8((polymodVal >> (5 * (5 - p))) & 31));
        }
        return chk;
    }

    // def bech32_verify_checksum(hrp, data):
    //     """Verify a checksum given HRP and converted data characters."""
    //     const = bech32_polymod(bech32_hrp_expand(hrp) + data)
    //     if const == 1:
    //         return Encoding.BECH32
    //     if const == BECH32M_CONST:
    //         return Encoding.BECH32M
    //     return None
    function verifyChecksum(
        bytes memory hrp,
        bytes memory data
    ) public pure returns (BechEncoding) {
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

    // def bech32_encode(hrp, data, spec):
    //     """Compute a Bech32 string given HRP and data values."""
    //     combined = data + bech32_create_checksum(hrp, data, spec)
    //     return hrp + '1' + ''.join([CHARSET[d] for d in combined])
    // data shold be converted to 5bit format before calling this function
    function bech32Encode(
        bytes memory hrp,
        bytes memory data,
        BechEncoding spec
    ) public pure returns (bytes memory) {
        if (spec == BechEncoding.UNKNOWN) {
            revert EncodingIsUnknown();
        }
        // 6 bytes of the checksum in a 5-bit format
        bytes memory chk = createChecksum(hrp, data, spec);

        // <hrp> 1 <data-5bit-format> <6bytes of chk-5bit-format>
        // so total length is hrp.length + data.length + 7
        bytes memory ret = new bytes(hrp.length + data.length + 7);

        for (uint i = 0; i < hrp.length; i += 1) {
            ret[i] = hrp[i];
        }

        ret[hrp.length] = 0x31; // '1'

        for (uint i = 0; i < data.length; i += 1) {
            ret[i + hrp.length + 1] = CHARSET[uint8(data[i])];
        }

        // index of start of the checksum
        uint startChk = hrp.length + 1 + data.length;
        for (uint i = 0; i < 6; i += 1) {
            ret[startChk + i] = CHARSET[uint8(chk[i])];
        }

        return ret;
    }

    // with padding
    function conver8To5(bytes memory a) public pure returns (bytes memory) {
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
    ) public pure returns (bytes memory) {
        BechEncoding spec = witVer == 0
            ? BechEncoding.BECH32
            : BechEncoding.BECH32M;
        bytes memory witProg5bit = conver8To5(witProg);
        bytes memory encArg = new bytes(witProg5bit.length + 1);
        encArg[0] = bytes1(witVer);
        for (uint i = 0; i < witProg5bit.length; i += 1) {
            encArg[i + 1] = witProg5bit[i];
        }
        return bech32Encode(hrp, encArg, spec);
    }

    function convert5to8(
        bytes memory data5Bits
    ) public pure returns (bytes memory, DecodeError) {
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
        returns (bytes memory, bytes memory, BechEncoding, DecodeError)
    {   
        if (bech.length > 90) {
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.InputIsTooLong);
        }

        if (!isValidCharacterRange(bech)) {
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.CharacterOutOfRange);
        }

        if (isMixedCase(bech)) {
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.MixedCase);
        }

        bytes memory bechLow = toLower(bech);
        int delimiterPos = int256(bechLow.length) - 1;
        while (true) {
            delimiterPos -= 1;
            if (delimiterPos < 0) {
                return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.NoDelimiter);
            }
            // 0x31 is '1'
            if (bechLow[uint256(delimiterPos)] == 0x31) {
                break;
            }
        }
        if (delimiterPos < 1) {
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.HRPIsEmpty);
        }
        if (delimiterPos + 7 > int(bechLow.length)) {
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.TooShortChecksum);
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
            return (new bytes(0), new bytes(0), BechEncoding.UNKNOWN, DecodeError.IncorrectChecksum);
        }

        bytes memory data5Bit = new bytes(dataAll5Bit.length - 6);
        for (uint i = 0; i < data5Bit.length; i += 1) {
            data5Bit[i] = dataAll5Bit[i];
        }

        return (hrp, data5Bit, spec, DecodeError.NoError);
    }

    function areBytesEqual(bytes memory a, bytes memory b) public pure returns (bool) {
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

    // def decode(hrp, addr):
    // """Decode a segwit address."""
    // hrpgot, data, spec = bech32_decode(addr)
    // if hrpgot != hrp:
    //     return (None, None)
    // decoded = convertbits(data[1:], 5, 8, False)
    // if decoded is None or len(decoded) < 2 or len(decoded) > 40:
    //     return (None, None)
    // if data[0] > 16:
    //     return (None, None)
    // if data[0] == 0 and len(decoded) != 20 and len(decoded) != 32:
    //     return (None, None)
    // if data[0] == 0 and spec != Encoding.BECH32 or data[0] != 0 and spec != Encoding.BECH32M:
    //     return (None, None)
    // return (data[0], decoded)
}
