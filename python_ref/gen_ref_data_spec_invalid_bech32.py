from segwit_addr import bech32_decode, Encoding

from tests import INVALID_BECH32

if __name__ == "__main__":
    print("// Generated code is semi-correct. Everything is correct except for the returned error code. ")
    print("// Error code should be set manually from comments in test.py and manual analysis.")
    print()
    for itest, bech_str in enumerate(INVALID_BECH32):
        hrp, data5bit, spec = bech32_decode(bech_str)
        assert spec == None

        bech_str_hex = bech_str.encode("utf-8").hex()
        hrp_hex = ""
        data5bit_hex = ""
        spec_solidity = "Bech32m.BechEncoding.UNKNOWN"
        err_solidity = "Bech32m.DecodeError.NoError"

        print(f"// {repr(bech_str)}")
        print(f"bytes memory bech{itest} = hex\"{bech_str_hex}\";")
        print(f"bytes memory hrpExpected{itest} = hex\"{hrp_hex}\";")
        print(f"bytes memory data5bitExpected{itest} = hex\"{data5bit_hex}\";")
        print(f"Bech32m.BechEncoding encodingExpected{itest} = {spec_solidity};")
        print(f"Bech32m.DecodeError errExpected{itest} = {err_solidity};")
        print(f"(bytes memory hrpActual{itest}, bytes memory data5bitActual{itest}, Bech32m.BechEncoding encodingActual{itest}, Bech32m.DecodeError errActual{itest}) = Bech32m.bech32Decode(bech{itest});")
        print(f"assertEq(hrpExpected{itest}, hrpActual{itest}, unicode\"hrp is incorrect after parsing invalid bech32: {repr(bech_str)}\");")
        print(f"assertEq(data5bitExpected{itest}, data5bitActual{itest}, unicode\"data5bit is incorrect after parsing invalid bech32: {repr(bech_str)}\");")
        print(f"assertTrue(encodingExpected{itest} == encodingActual{itest}, unicode\"encoding is incorrect after parsing invalid bech32: {repr(bech_str)}\");")
        print(f"assertTrue(errExpected{itest} == errActual{itest}, unicode\"error code is incorrect after parsing invalid bech32: {repr(bech_str)}\");")
        print()
