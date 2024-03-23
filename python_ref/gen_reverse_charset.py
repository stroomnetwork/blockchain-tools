from segwit_addr import CHARSET

if __name__ == '__main__':
    r = [127 for i in range(128)]
    for i, c in enumerate(CHARSET):
        r[ord(c)] = i
    r_hex = bytes(r).hex()
    print(f"bytes public constant REVERSE_CHARSET = hex\"{r_hex}\";")