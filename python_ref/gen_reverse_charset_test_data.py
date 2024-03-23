from segwit_addr import CHARSET

reverse_map = {ch:i for (i, ch) in enumerate(CHARSET)}

def decode(a):
    b = []
    for ch in a:
        if ch not in reverse_map:
            return None
        b.append(reverse_map[ch])
    return bytes(b)

tests = [
    CHARSET,
    CHARSET[10:] + CHARSET[:10],
    "1ab",
    "\xff",
]

if __name__ == '__main__':
    itest2 = 0
    for itest, test in enumerate(tests):
        ranges = [(0, len(test))]
        if itest == 1:
            ranges.append((0, 10))
            ranges.append((15, len(test)))
            ranges.append((5, 21))
        for start, stop in ranges:
            all_decoded = decode(test)
            if all_decoded is None:
                data_expected_hex = ""
                err_expected_solidity = "Bech32m.DecodeError.NotBech32Character"
            else:
                data_expected_hex = all_decoded[start:stop].hex()
                err_expected_solidity = "Bech32m.DecodeError.NoError"
            
            print(f"bytes memory data{itest2} = hex\"{test.encode().hex()}\";")
            print(f"bytes memory rezExpected{itest2} = hex\"{data_expected_hex}\";")
            print(f"Bech32m.DecodeError errExpected{itest2} = {err_expected_solidity};")
            print(f"(bytes memory rezActual{itest2}, Bech32m.DecodeError errActual{itest2}) = Bech32m.decodeCharactersBech32(data{itest2}, {start}, {stop});")
            print(f"assertEq(rezExpected{itest2}, rezActual{itest2});")
            print(f"assertTrue(errExpected{itest2} == errActual{itest2});")
            print()
            itest2 += 1
