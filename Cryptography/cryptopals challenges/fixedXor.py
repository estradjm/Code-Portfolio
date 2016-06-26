'''Function that takes two equal-length buffers
and produces their XOR combination'''


def xor_str(a, b):
    result = int(a, 16) ^ int(b, 16)    # convert to integers and xor them
    return '{:x}'.format(result)    # convert back to hexadecimal

# Test out function
str1 = '1c0111001f010100061a024b53535009181c'
str2 = '686974207468652062756c6c277320657965'
print(str1)
print(str2)
print ((xor_str(str1, str2)))