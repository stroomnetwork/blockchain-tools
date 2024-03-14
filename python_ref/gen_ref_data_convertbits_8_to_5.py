from segwit_addr import convertbits

def byte_to_bin(x, bin_size=8):
    return bin(x)[2:].zfill(bin_size)

def iter_to_bin(iterable, bin_size=8, sep=" "):
    return sep.join(byte_to_bin(x, bin_size) for x in iterable)

if __name__ == "__main__":
    max_len = 16
    all_data = bytes.fromhex("5128751e76e8199196d454941c45d1b3a323f1433bd6751e76e8199196d454941c45d1b3a323f1433bd6")[:max_len]
    
    for i_data in range(max_len):
        data = all_data[:i_data]
        data_5bits = convertbits(data, 8, 5)
        # print("-"*80)
        # print(f"{iter_to_bin(data)}")
        # print(f"{iter_to_bin(data_5bits, 5)}")
        # print()
        # print(f"{iter_to_bin(data, sep="")}")
        # print(f"{iter_to_bin(data_5bits, 5, sep="")}")
        # print("-"*80)

        data_hex = data.hex()
        data_5bits_hex = bytes(data_5bits).hex()

        print(f"// convertbits({data}, 8, 5) == {data_5bits}")
        print(f"bytes memory dataIn{i_data} = hex\"{data_hex}\";")
        print(f"bytes memory dataOutExpected{i_data} = hex\"{data_5bits_hex}\";")
        print(f"bytes memory dataOutActual{i_data} = Bech32m.conver8To5(dataIn{i_data});")
        print(f"assertEq(dataOutExpected{i_data}, dataOutActual{i_data});")
        print()