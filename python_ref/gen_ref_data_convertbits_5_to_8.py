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
    for i_test in range(0, len(data_5bit_all)):
        data_5bit = data_5bit_all[:i_test]
        data_8bit_expected = convertbits(data_5bit, 5, 8, False)
        print(data_5bit)
        print(data_8bit_expected)
        print()

        # if converted is not None:
        #     data_5bit_bits = iter_to_bin(data_5bit[:i], bin_size=5, sep="")
        #     data_8bit_bits = iter_to_bin(converted, bin_size=8, sep="")
        #     print(last_bits(data_5bit_bits))
        #     print(last_bits(data_8bit_bits))
        #     print()
    # convertbits(data[1:], 5, 8, False)
    
