// https://github.com/gregdhill/bech32-sol/blob/master/src/Bech32.sol
// TODO(mkl): what License?
// based on https://github.com/bitcoin/bips/blob/master/bip-0350.mediawiki
// https://github.com/sipa/bech32/blob/master/ref/python/segwit_addr.py
pragma solidity ^0.8;

import {BytesLib} from "./BytesLib.sol";

enum BechEncoding {
    // Used is SegWit v.0
    BECH32,

    // Used in SegWit v.1, e.g. Taproot
    BECH32M
}

library Bech32m {
    using BytesLib for bytes;

    // CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
    bytes constant public CHARSET = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';

    // BECH32M_CONST = 0x2bc830a3
    uint256 constant public BECH32M_CONST= 0x2bc830a3;

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
    function polymod(uint[] memory values) public pure returns(uint) {
        uint32[5] memory GENERATOR = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3];
        uint chk = 1;
        for (uint p = 0; p < values.length; p++) {
            uint top = chk >> 25;
            chk = (chk & 0x1ffffff) << 5 ^ values[p];
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
        bytes memory a = new bytes(hrp.length+hrp.length+1);
        for (uint i = 0; i < hrp.length; i+=1) {
            a[i] = hrp[i] >> 5;
            a[i+hrp.length+1] = bytes1(uint8(hrp[i]) & 31);
        }
        a[hrp.length] = 0;
        return a;
    }


    // function hrpExpand(uint[] memory hrp) public pure returns (uint[] memory) {
    //     uint[] memory ret = new uint[](hrp.length+hrp.length+1);
    //     for (uint p = 0; p < hrp.length; p++) {
    //         ret[p] = hrp[p] >> 5;
    //     }
    //     ret[hrp.length] = 0;
    //     for (uint p = 0; p < hrp.length; p++) {
    //         ret[p+hrp.length+1] = hrp[p] & 31;
    //     }
    //     return ret;
    // }

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