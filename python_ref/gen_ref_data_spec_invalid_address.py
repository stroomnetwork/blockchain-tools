import segwit_addr

from tests import INVALID_ADDRESS

if __name__ == "__main__":
    itest2 = 0
    for itest, test_addr in enumerate(INVALID_ADDRESS):
        for hrp in ["bc", "tb"]:
            witver, _ = segwit_addr.decode(hrp, test_addr)
            assert witver is None

            print(f"// addr: {test_addr}")
            print(f"// hrp:  {hrp}")
            print(f"(uint8 actualWitver{itest2}, bytes memory actualWitprog{itest2}, Bech32m.DecodeError err{itest2}) = Bech32m.decodeSegwitAddress(bytes({repr(hrp)}), bytes({repr(test_addr)}));")
            print(f"assertEq(0, actualWitver{itest2}, \"returned witver should be 0 after decoding incorrect address: {repr(test_addr)} with hrp: {repr(hrp)}\");")
            print(f"assertEq(hex\"\", actualWitprog{itest2}, \"returned witprog should be empty after decoding incorrect address: {repr(test_addr)} with hrp: {repr(hrp)}\");")
            print(f"assertTrue(err{itest2} == Bech32m.DecodeError.NoError, \"incorrect error code after decoding incorrect address: {repr(test_addr)} with hrp: {repr(hrp)}\");")
            print()
            itest2 += 1
