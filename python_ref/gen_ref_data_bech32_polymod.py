#!/usr/bin/env python3

from segwit_addr import bech32_polymod, bech32_hrp_expand, CHARSET

values = [
    [0],
    [1],
    [0, 1],
    [2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12, 13],
    [14, 15, 16, 17, 18, 19],
]

polymod_values = [bech32_polymod(v) for v in values]


if __name__ == "__main__":
    # I do not know how to initialize dynamic arrays in Solidity.
    # So here is an automatic Solidity code generation for tests.
    for iv, (v, pv) in enumerate(zip(values, polymod_values)):
        print(f"// bech32_polymod({v}) == {pv}")
        arr_name = f"values{iv}"
        print(f"uint[] memory {arr_name} = new uint[]({len(v)});")
        for j in range(len(v)):
            print(f"{arr_name}[{j}] = {v[j]};")
        print(f"uint256 polymodExpected{iv} = {pv};")
        print(f"uint256 polymodActual{iv} = Bech32m.polymod({arr_name});")
        print(f"assertEq(polymodExpected{iv}, polymodActual{iv});")
        print()
