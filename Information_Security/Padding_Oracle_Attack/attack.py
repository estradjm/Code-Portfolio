#!/usr/bin/python

'''
University of New Mexico, Spring 2017

CS544: Intro to CyberSecurity

Lab2: Padding Oracle Chosen Ciphertext Attack

attack.py : Running through every possible value (0-255) 
to determine how to generate correct padding 
(information being leaked from server) byte by byte for the IV, 
to generate the correct plaintext value without knowing the key 
for RSA CBC mode encryption that the server is using. We calculate 
the intermediate value with the artifical padding XOR the modified 
IV byte. To calculate the plaintext with the original IV byte XOR 
the Intermediate byte value.
 
Author: Jenniffer Estrada 

Last Modified: April 3, 2017

Due: April 3, 2017 
'''


# Dependencies
import socket
import sys
import os
import binascii
import six

# Functions
def byte_to_char(bin_input):
	"""
	Given byte as string or int, return character
	>>> byte_to_char("0010010")
	'2'
	>>> byte_to_char(100)
	'd'
	"""
	if isinstance(bin_input, six.string_types):
		return chr(int(bin_input, base=2))
	else: 
		return chr(bin_input)

def byte_to_binary(n):
	"""
	Convert byte to binary, duh. 
	>>> byte_to_binary("00110010")
	"""
	return ''.join(str((n & (1 << i)) and 1) for i in reversed(range(8)))

def hex_to_binary(h):
	return ''.join(byte_to_binary(ord(b)) for b in binascii.unhexlify(h))

def xor_byte(a,b):
	y = int(a, 2)^int(b,2)
 	return bin(y)[2:].zfill(len(b))

# Slightly modified version of client.py
def sendToServer(ipaddress, port, block, keyid):
	
	# Length of either response.
	# Server response may have spaces in it
	# to adhere to message length
	MESSAGE_LENGTH = 32
	BLOCK_SIZE = 32

	cipher_size = len(block)

	if not(cipher_size % BLOCK_SIZE == 0):
		print "Bad block(s) size"
  		exit()

	else:
	  # Create a TCP/IP socket
	  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	  # Connect the socket to the port where the server is listening
	  server_address = (ipaddress, int(port))
	  sock.connect(server_address)

	  # num_blocks to be decrypted (IV not counting as ciphertext block)
	  num_blocks = (cipher_size/BLOCK_SIZE)-1 

	  try:
	      # Send data
	      message = block + ':' + str(num_blocks) + ':' + keyid  
	      sock.sendall(message)

	      # Look for the response
	      amount_received = 0
	      amount_expected = MESSAGE_LENGTH

	      while amount_received < amount_expected:
	          data = sock.recv(MESSAGE_LENGTH)
	          amount_received += len(data)
	  finally:
	      sock.close()
	      if (data == "Message decrypted successfully  "):
	      	return 1
	      else:
		return 0

def substituteIVByte(origIV, l, nbyte, newByte):        
	newIV = ""
        it=0
        origIV = [origIV[i:i + 1] for i in range(0, len(origIV), 1)]
        h1 = l-2+(nbyte*-2)
        h2 = l-1+(nbyte*-2)
        for nibble in origIV:
                if(it == h1):
                        newIV = newIV + newByte[0]
                elif(it == h2):
                        newIV = newIV + newByte[1]
                else:
                        newIV = newIV +  nibble
                it=it+1
        return newIV

def addBinary(a, b):
	"""
	>>> addBinary("10101010", "11001100")
	'101110110'
	>>> addBinary("11000110110", "11010011101")
	'110011010011'
	"""
        solution = []
        summs = 0
        for i in range(0,max(len(a),len(b))):
                if i < len(a) and a[len(a)-1-i]=='1':
                        summs += 1
                if i < len(b) and b[len(b)-1-i]=='1':
                        summs += 1
                solution.insert(0,str(summs%2))
                summs /= 2
        if summs > 0:
                solution.insert(0,str(summs%2))
        return ''.join(solution)


def fixPadding(origIV, l, nbyte, binary_G):
        newIV = ""
        it=0
        origIV = [origIV[i:i + 2] for i in range(0, len(origIV), 2)] # hex bytes
        h1 = l-2+(nbyte*-2)
        size = len(origIV)
        for itbyte in origIV:
                if(it == h1):
                        shifted_byte1 = xor_byte(bin(nbyte+1), xor_byte(bin(nbyte+2),binary_G))
                        shifted_byte = '%02X' % int(shifted_byte1, 2)
                        newIV = newIV + shifted_byte
		elif (it > h1):
                        shifted_byte2 = xor_byte(bin(nbyte+1), xor_byte(bin(nbyte+2),hex_to_binary(itbyte)))
                        shifted_byte2 = '%02X' % int(shifted_byte2, 2)
                        newIV = newIV + shifted_byte2
                else:
                        newIV = newIV +  itbyte
                it = it + 2
        return newIV


# Main Program
if __name__ == "__main__":

	# Constants
	ip = "shasta.cs.unm.edu"
	port = "10042"
	keyID = "42"
	IV="6c3557445137314654744e7978616f37"
	
	message="969a37b07f0c8612b51b6d2e0812ab639fe23e3110407b2fead289b3ffe2ab030c32d380fa0c068e1361988ea8394f3aaa985a54080d7ee2bbfdd979db6e91683c49201b148a114c504d0a5cb2776e2f97e929ef7ca61cd8b1b6479950be2b99ddb335b1addffbdfd97aba01359e6996f3261825aa9bf44fe5c8acbaf60be3cd73dd8bf9906a1ded8ddf0f875a376b90e55571774be1b6e49b70ce2915655bd0"
	block = IV + message
	
	num_blocks = (len(block)/32)-1 # num_blocks to be decrypted (IV not counting as ciphertext block)

# DEBUGGING
#	import pdb
#	pdb.set_trace()

	# iterate through number of blocks
	for i in range(0, num_blocks):
		IV = block[i*32:(i*32)+32]
		ctext =  block[(i*32)+32:(2*32)+32*i]
		l= len(IV)
		
		#iterate through each byte in each block
		for nbyte in range(0, l/2):
			byteToManip = IV[ l-2+(nbyte*-2) : l+(nbyte*-2)]
			origIV_byte = hex_to_binary(byteToManip)
			
			#iterate through all possible values from 0-255
			for Guess in range(0,256):	
				binary_G = bin(Guess)[2:].zfill(8)
				newByte = "{0:0>2X}".format(int(binary_G, 2))
				newIV = substituteIVByte(IV, l, nbyte, newByte)
				
				#print "Original IV for block " + str(i+1) + " and byte " + str(16-nbyte) + " is " + IV + " and is modified with Guess " + newByte +" to be " + newIV + " sent to server"

				# Send new Message to the server and get response 
				if(sendToServer(ip, port, newIV+ctext, keyID)):
					padding = bin(nbyte+1)[2:].zfill(8)
					InByte = xor_byte(padding, binary_G)
					ptByte = xor_byte(origIV_byte, InByte)
					IV =   fixPadding(newIV, l, nbyte, binary_G)
					#print " "
					print "Successful padding found with " + newByte  + ". block: " + str(i+1) + "; byte: " + str(16 - nbyte) + "; Decrypted: " +  str(byte_to_char(ptByte))
					#print "IV with new padding is now: " + IV
					#print " " 
					#break
