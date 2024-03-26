from segwit_addr import bech32_decode, Encoding

from tests import VALID_BECH32M

if __name__ == "__main__":
    for itest, bech_str in enumerate(VALID_BECH32M):
        hrp, data5bit, spec = bech32_decode(bech_str)
        assert spec == Encoding.BECH32M

        bech_str_hex = bech_str.encode("utf-8").hex()
        hrp_hex = hrp.encode("utf-8").hex()
        data5bit_hex = bytes(data5bit).hex()
        spec_solidity = "Bech32m.BechEncoding.BECH32M"
        err_solidity = "Bech32m.DecodeError.NoError"

        print(f"// {bech_str}")
        print(f"bytes memory bech{itest} = hex\"{bech_str_hex}\";")
        print(f"bytes memory hrpExpected{itest} = hex\"{hrp_hex}\";")
        print(f"bytes memory data5bitExpected{itest} = hex\"{data5bit_hex}\";")
        print(f"Bech32m.BechEncoding encodingExpected{itest} = {spec_solidity};")
        print(f"Bech32m.DecodeError errExpected{itest} = {err_solidity};")
        print(f"(bytes memory hrpActual{itest}, bytes memory data5bitActual{itest}, Bech32m.BechEncoding encodingActual{itest}, Bech32m.DecodeError errActual{itest}) = Bech32m.bech32Decode(bech{itest});")
        print(f"assertEq(hrpExpected{itest}, hrpActual{itest});")
        print(f"assertEq(data5bitExpected{itest}, data5bitActual{itest});")
        print(f"assertTrue(encodingExpected{itest} == encodingActual{itest});")
        print(f"assertTrue(errExpected{itest} == errActual{itest});")
        print()
