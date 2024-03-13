// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// TODO(mkl): what License?
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py
pragma solidity ^0.8;

import {BytesLib} from "./BytesLib.sol";

library Bech32m {
    enum BechEncoding {
        // Used is SegWit v.0
        BECH32,
        // Used in SegWit v.1, e.g. Taproot
        BECH32M,
        // Specifies an uknown encoding
        // Usually it means some error
        UKNOWN
    }
    // using BytesLib for bytes;

    // CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
    bytes public constant CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l";

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

        return BechEncoding.UKNOWN;
    }

    // function concat(uint[] memory left, uint[] memory right) internal pure returns(uint[] memory) {
    //     uint[] memory ret = new uint[](left.length + right.length);

    //     uint i = 0;
    //     for (; i < left.length; i++) {
    //         ret[i] = left[i];
    //     }

    //     uint j = 0;
    //     while (j < right.length) {
    //         ret[i++] = right[j++];
    //     }

    //     return ret;
    // }

    // function extend(uint[] memory array, uint val, uint num) internal pure returns(uint[] memory) {
    //     uint[] memory ret = new uint[](array.length + num);

    //     uint i = 0;
    //     for (; i < array.length; i++) {
    //         ret[i] = array[i];
    //     }

    //     uint j = 0;
    //     while (j < num) {
    //         ret[i++] = val;
    //         j++;
    //     }

    //     return ret;
    // }

    // function createChecksum(uint[] memory hrp, uint[] memory data) internal pure returns (uint[] memory) {
    //     uint[] memory values = extend(concat(hrpExpand(hrp), data), 0, 6);
    //     uint mod = polymod(values) ^ 1;
    //     uint[] memory ret = new uint[](6);
    //     for (uint p = 0; p < 6; p++) {
    //         ret[p] = (mod >> 5 * (5 - p)) & 31;
    //     }
    //     return ret;
    // }

    // function encode(uint[] memory hrp, uint[] memory data) internal pure returns (bytes memory) {
    //     uint[] memory combined = concat(data, createChecksum(hrp, data));
    //     // TODO: prepend hrp

    //     bytes memory ret = new bytes(combined.length);
    //     for (uint p = 0; p < combined.length; p++) {
    //         ret[p] = CHARSET[combined[p]];
    //     }

    //     return ret;
    // }

    // function convert(uint[] memory data, uint inBits, uint outBits) internal pure returns (uint[] memory) {
    //     uint value = 0;
    //     uint bits = 0;
    //     uint maxV = (1 << outBits) - 1;

    //     uint[] memory ret = new uint[](32);
    //     uint j = 0;
    //     for (uint i = 0; i < data.length; ++i) {
    //         value = (value << inBits) | data[i];
    //         bits += inBits;

    //         while (bits >= outBits) {
    //             bits -= outBits;
    //             ret[j] = (value >> bits) & maxV;
    //             j += 1;
    //         }
    //     }

    //     return ret;
    // }
}
