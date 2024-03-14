from segwit_addr import encode

tests = [
    ["bt", 0, b'01'*10],
    ["tb", 0, b'02'*16],
    ["bt", 1, b'03'*16],
    ["tb", 1, b'04'*16],
]


if __name__ == "__main__":
    for itest, test in enumerate(tests):
        hrp, witver, witprog = test
        
        hrp_hex = hrp.encode('utf-8').hex()
        witprog_hex = witprog.hex()
        addr = encode(hrp, witver, witprog)
        addr_hex = addr.encode('utf-8').hex()

        print(f"// encode(\"{hrp}\", {witver}, {witprog}) == \"{addr}\"")
        print(f"bytes memory hrp{itest} = hex\"{hrp_hex}\";")
        print(f"uint8 witver{itest} = {witver};")
        print(f"bytes memory witprog{itest} = hex\"{witprog_hex}\";")
        print(f"bytes memory expectedAddr{itest} = hex\"{addr_hex}\";")
        print(f"bytes memory actualAddr{itest} = Bech32m.encodeSegwitAddress(hrp{itest}, witver{itest}, witprog{itest});")
        print(f"assertEq(expectedAddr{itest}, actualAddr{itest});")
        print()

