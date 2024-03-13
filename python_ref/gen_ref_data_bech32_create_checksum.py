from segwit_addr import bech32_create_checksum, Encoding

# TODO(mkl): should these values be 5bits ?
tests = [
    # hrp, data, spec
    ["tb", b"", Encoding.BECH32],
    ["bt", b"some data", Encoding.BECH32M],
    ["btcdd", b"\0ds\n\t\0", Encoding.BECH32M],
]

# def bech32_create_checksum(hrp, data, spec):
#     """Compute the checksum values given HRP and data."""
#     values = bech32_hrp_expand(hrp) + data
#     const = BECH32M_CONST if spec == Encoding.BECH32M else 1
#     polymod = bech32_polymod(values + [0, 0, 0, 0, 0, 0]) ^ const
#     return [(polymod >> 5 * (5 - i)) & 31 for i in range(6)]

# function createChecksum(bytes memory hrp, bytes memory data, BechEncoding spec) public pure returns (bytes memory) {

if __name__ == "__main__":
    for itest, test in enumerate(tests):
        hrp = test[0]
        data = test[1]
        spec = test[2]

        hrp_hex = hrp.encode("utf-8").hex()
        data_hex = data.hex()
        spec_solidity = "Bech32m.BechEncoding.BECH32M" if spec == Encoding.BECH32M else "Bech32m.BechEncoding.BECH32"
        
        chk = bech32_create_checksum(hrp, list(data), spec)
        chk_hex = bytes(chk).hex()

        print(f"// bech32_create_checksum(\"\"\"{hrp}\"\"\", {list(data)}, {spec}) == {chk}")
        print(f"bytes memory hrp{itest} = hex\"{hrp_hex}\";")
        print(f"bytes memory data{itest} = hex\"{data_hex}\";")
        print(f"Bech32m.BechEncoding spec{itest} = {spec_solidity};")
        print(f"bytes memory chkExpected{itest} = hex\"{chk_hex}\";")
        print(f"bytes memory chkActual{itest} = Bech32m.createChecksum(hrp{itest}, data{itest}, spec{itest});")
        print(f"assertEq(chkExpected{itest}, chkActual{itest});")
        print()
    