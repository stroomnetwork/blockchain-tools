from segwit_addr import bech32_hrp_expand

hrps = [
    "a", 
    "tb",
    # all possible symbols in HRP 
    "".join(chr(i) for i in range(33, 126+1))
]

if __name__ == "__main__":
    for ihrp, hrp in enumerate(hrps):
        hrp_hex = "".join("{:02x}".format(ord(c)) for c in hrp)
        hrp_expand = bech32_hrp_expand(hrp)
        hrp_expand_hex = "".join("{:02x}".format(c) for c in hrp_expand)
        
        print(f"// bech32_hrp_expand(\"\"\"{hrp}\"\"\") == {hrp_expand}")
        print(f"bytes memory hrp{ihrp} = hex\"{hrp_hex}\";")
        print(f"bytes memory hrpExpandExpected{ihrp} = hex\"{hrp_expand_hex}\";")
        print(f"bytes memory hrpExpandActual{ihrp} = Bech32m.hrpExpand(hrp{ihrp});")
        print(f"assertEq(hrpExpandExpected{ihrp}, hrpExpandActual{ihrp});")
        print()
