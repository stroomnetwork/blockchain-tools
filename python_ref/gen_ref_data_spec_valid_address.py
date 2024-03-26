import segwit_addr
from tests import VALID_ADDRESS

if __name__ == "__main__":
    for itest, (address, hexscript) in enumerate(VALID_ADDRESS):
        hrp = "bc"
        witver, witprog = segwit_addr.decode(hrp, address)
        if witver is None:
            hrp = "tb"
            witver, witprog = segwit_addr.decode(hrp, address)
        assert witver is not None
        witprog_hex = bytes(witprog).hex()

        print(f"// {address}")
        print(f"bytes memory hrp{itest} = bytes({repr(hrp)});")
        print(f"bytes memory address{itest} = bytes({repr(address)});")
        print(f"bytes memory addressLowerExpected{itest} = bytes({repr(address.lower())});")
        print(f"uint8 expectedWitver{itest} = {witver};")
        print(f"bytes memory expectedWitprog{itest} = hex\"{witprog_hex}\";")
        print(f"(uint8 actualWitver{itest}, bytes memory actualWitprog{itest}, Bech32m.DecodeError err{itest}) = Bech32m.decodeSegwitAddress(hrp{itest}, address{itest});")
        print(f"assertEq(expectedWitver{itest}, actualWitver{itest}, \"incorrect witver after decoding address: {repr(address)}\");")
        print(f"assertEq(expectedWitprog{itest}, actualWitprog{itest}, \"incorrect witprog after decoding address: {repr(address)}\");")
        print(f"assertTrue(err{itest} == Bech32m.DecodeError.NoError, \"unexpected error decoding address: {repr(address)}\");")
        print(f"bytes memory addrEncodedActual{itest} = Bech32m.encodeSegwitAddress(hrp{itest}, actualWitver{itest}, actualWitprog{itest});")
        print(f"assertEq(addressLowerExpected{itest}, addrEncodedActual{itest}, \"incorrect address after decoding and then encoding address: {repr(address)}\");")
        print()