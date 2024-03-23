from segwit_addr import bech32_encode, Encoding

# Test only correct bech strings
tests = [
    # HRP, 5bit data, encoding
    ("tb", [0, 1, 2], Encoding.BECH32),
    ("bc", [], Encoding.BECH32M),
    ("tb", [i for i in range(32)], Encoding.BECH32M),
]

if __name__ == "__main__":
    for (itest, test) in enumerate(tests):
        hrp, data, spec = test
        encoded = bech32_encode(hrp, data, spec)
        
        hrp_hex = hrp.encode("utf-8").hex()
        data_hex = bytes(data).hex()
        if spec == Encoding.BECH32:
            spec_str_solidity = "Bech32m.BechEncoding.BECH32"
            spec_str_python = "Encoding.BECH32"
        elif spec == Encoding.BECH32M:
            spec_str_solidity = "Bech32m.BechEncoding.BECH32M"
            spec_str_python = "Encoding.BECH32M"
        else:
            raise ValueError("Unknown BECH encoding")
        encoded_hex = encoded.encode("utf-8").hex()

        print(f"// bech32_encode('''{hrp}''', {data}, {spec_str_python}) == '''{encoded}'''")
        print(f"bytes memory encodedData{itest} = hex\"{encoded_hex}\";")
        print(f"(bytes memory hrpActual{itest}, bytes memory dataActual{itest}, Bech32m.BechEncoding specActual{itest}, Bech32m.DecodeError err{itest}) =  Bech32m.bech32Decode(encodedData{itest});")
        print(f"assertEq(hrpActual{itest}, hex\"{hrp_hex}\"); // {hrp}")
        print(f"assertEq(dataActual{itest}, hex\"{data_hex}\");")
        print(f"assertTrue(specActual{itest} == {spec_str_solidity});")
        print(f"assertTrue(err{itest} == Bech32m.DecodeError.NoError);")
        print()
