from segwit_addr import bech32_encode, Encoding

tests = [
    # hrp data(5-bit) spec
    ["tb", [], Encoding.BECH32],
    ["bt", [1, 2, 3, 4, 5], Encoding.BECH32M],
    ["abcd", [0,1, 30, 31], Encoding.BECH32M],
    ["\"12", [12, 31, 0], Encoding.BECH32],
]

if __name__ == "__main__":
    for (itest, test) in enumerate(tests):
        hrp, data, spec = test

        hrp_hex = hrp.encode("utf-8").hex()
        data_hex = bytes(data).hex()
        spec_solidity = "Bech32m.BechEncoding.BECH32M" if spec == Encoding.BECH32M else "Bech32m.BechEncoding.BECH32"

        encoded = bech32_encode(hrp, data, spec)
        encoded_hex = encoded.encode("utf-8").hex()

        print(f"// bech32_encode(\"\"\"{hrp}\"\"\", {data}, {spec}) == \"\"\"{encoded}\"\"\"")
        print(f"bytes memory hrp{itest} = hex\"{hrp_hex}\";")
        print(f"bytes memory data{itest} = hex\"{data_hex}\";")
        print(f"Bech32m.BechEncoding spec{itest} = {spec_solidity};")
        print(f"bytes memory encodedExpected{itest} = hex\"{encoded_hex}\";")
        print(f"bytes memory encodedActual{itest} = Bech32m.bech32Encode(hrp{itest}, data{itest}, spec{itest});")
        print(f"assertEq(encodedExpected{itest}, encodedActual{itest});")
        print()
