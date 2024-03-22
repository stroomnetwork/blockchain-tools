from hashlib import sha256

from segwit_addr import convertbits

from gen_ref_data_convertbits_8_to_5 import iter_to_bin, byte_to_bin

def last_bits(s):
    if len(s) % 40 == 0:
        return ""
    n_blocks = len(s) // 40
    return s[n_blocks*40:]
    

if __name__ == "__main__":
    data_all = sha256(b"sample data").digest() + sha256(b"sample data 2").digest()
    data_5bit_all = convertbits(data_all, 8, 5)
    for i_test in range(len(data_5bit_all)):
        data_5bit = data_5bit_all[:i_test]
        data_8bit_expected = convertbits(data_5bit, 5, 8, False)
        
        data_5bit_hex = "".join(f"{b:02x}" for b in data_5bit)
        if data_8bit_expected is not None:
            data_8bit_expected_hex = "".join(f"{b:02x}" for b in data_8bit_expected)
        else:
            data_8bit_expected_hex = ""
        print(f"// convertbits({data_5bit}, 5, 8, False) == {data_8bit_expected}")
        print(f"bytes memory data5Bit{i_test} = hex\"{data_5bit_hex}\";")
        print(f"bytes memory data8BitExpected{i_test} = hex\"{data_8bit_expected_hex}\";")
        print(f"(bytes memory data8BitActual{i_test}, Bech32m.DecodeError err{i_test}) = Bech32m.convert5to8(data5Bit{i_test});");
        print(f"assertEq(data8BitExpected{i_test}, data8BitActual{i_test});")
        if data_8bit_expected is not None:
            print(f"assertTrue(err{i_test} == Bech32m.DecodeError.NoError);")
        else:
            print(f"assertTrue(err{i_test} != Bech32m.DecodeError.NoError);")
        print()

        # if converted is not None:
        #     data_5bit_bits = iter_to_bin(data_5bit[:i], bin_size=5, sep="")
        #     data_8bit_bits = iter_to_bin(converted, bin_size=8, sep="")
        #     print(last_bits(data_5bit_bits))
        #     print(last_bits(data_8bit_bits))
        #     print()
   