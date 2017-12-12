'''The hex encoded string was XOR'd against a single character.
The key is found and the message is decrypted using character frequency
as a scoring metric.'''

#  Import Libraries
import string
import binascii

#  Define all necessary functions


def xor_str(a, b):
    # Define xor function
    result = int(a, 16) ^ int(b, 16)    # Convert to integers and xor them
    return '{:x}'.format(result)    # Convert back to hexadecimal


def my_containsAny(str, set):
    for c in set:
        if c in str:
            return 1
    return 0


#  Dictionary with letter frequencies (English)
letter_freq = dict(e=12.49, t=9.28, a=8.04, o=7.64, i=7.57, n=7.23, s=6.51,
r=6.28, h=5.05, l=4.07, d=3.82, c=3.34, u=2.73, m=2.51, f=2.40, p=2.14,
g=1.87, w=1.68, y=1.66, b=1.48, v=1.05, k=0.54, x=0.23, j=0.16, q=0.12, z=0.09,
E=12.49, T=9.28, A=8.04, O=7.64, I=7.57, N=7.23, S=6.51,
R=6.28, H=5.05, L=4.07, D=3.82, C=3.34, U=2.73, M=2.51, F=2.40, P=2.14,
G=1.87, W=1.68, Y=1.66, B=1.48, V=1.05, K=0.54, X=0.23, J=0.16, Q=0.12, Z=0.09)

#  Set of invalid characters
invalid = set(['*', '&', '`', '{', '}', '_', '-', '', '', '^', '[', ']', '@'])
#  Initializations
letters = string.ascii_letters
metric = 0
highest = 0

with open('singleByteXOR.txt') as f:
    str1 = f.read()
    #print(str1)
    for i in range(0, len(letters)):
    #  Generate keys
        hex_letters = binascii.hexlify(letters[i]) * len(str1)
        #print(hex_letters)
        str2 = xor_str(str1, hex_letters)
        #print(str2)
        decoded_str = binascii.unhexlify(str2)
        #print(decoded_str)
        #  First 33 letters are repeated letter of the key used
        decoded_str1 = decoded_str[35:]
        #print(decoded_str)
        if (not my_containsAny(decoded_str1, invalid)):
            ##  Ignore invalid character phrases
            #print(decoded_str1)

            for letter, freq in list(letter_freq.items()):
            #  Calculate metric for phrase and keep highest score
                metric = metric + (decoded_str1.count(letter) * freq)
                if highest <= metric:
                    highest = metric
                    phrase = decoded_str1
            metric = 0

print(('Metric: %0.2f' % highest))
print(phrase)

f.close()