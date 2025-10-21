import hashlib

tests = [
    "",
    "010203",
    "ab"*1000,
]


if __name__ == "__main__":
    for itest, data_hex in enumerate(tests):
        data = bytes.fromhex(data_hex)

        # Calculate SHA-512
        sha512_hash = hashlib.sha512(data)
        hash1_hex = sha512_hash.digest()[:32].hex()
        hash2_hex = sha512_hash.digest()[32:].hex()

        print(f"bytes memory data{itest} = hex\"{data_hex}\";")
        print(f"bytes32 hash{itest}_1_expected = hex\"{hash1_hex}\";")
        print(f"bytes32 hash{itest}_2_expected = hex\"{hash2_hex}\";")

        print(f"(bytes32 hash{itest}_1, bytes32 hash{itest}_2) = Sha2Ext.sha512(data{itest});")
        print(f"assertEq(hash{itest}_1, hash{itest}_1_expected);")
        print(f"assertEq(hash{itest}_2, hash{itest}_2_expected);")
        print()

