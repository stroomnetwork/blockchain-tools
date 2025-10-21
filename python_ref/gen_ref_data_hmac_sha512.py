import hashlib
import hmac

tests = [
    [bytes.fromhex("010203"), bytes.fromhex("040506")],
    [bytes.fromhex("01"*128), bytes.fromhex("04")],
    [bytes.fromhex("01"*150), bytes.fromhex("04")],
]


if __name__ == "__main__":
    for itest, test in enumerate(tests):
        key, message = test

        key_hex = key.hex()
        message_hex = message.hex()

        hmac_result = hmac.new(key, message, hashlib.sha512).digest()
        hmac1_hex = hmac_result[:32].hex()
        hmac2_hex = hmac_result[32:].hex()

        print(f"bytes memory key{itest} = hex\"{key_hex}\";")
        print(f"bytes memory message{itest} = hex\"{message_hex}\";")
        print(f"bytes32 hmac{itest}_1_expected = hex\"{hmac1_hex}\";")
        print(f"bytes32 hmac{itest}_2_expected = hex\"{hmac2_hex}\";")
        print(f"(bytes32 hmac{itest}_1, bytes32 hmac{itest}_2) = Hmac.hmacSha512(key{itest}, message{itest});")
        print(f"assertEq(hmac{itest}_1, hmac{itest}_1_expected);")
        print(f"assertEq(hmac{itest}_2, hmac{itest}_2_expected);")
        print()

