"""Client.py

   This module is the python code that can be used to connect to the Oracle and manipulate the ciphertext. 
   It takes 4 arguments:

     1. -ip (--ipaddress):  The IP address of the machine to run the server.
     2. -p (--port):        The port to listen on.
     3. -b (--block):       The 32-byte block sent to the server
     4. -id (--keyid):      The unique keyid that was assigned to each student       

   Feed 'client.py' a 32 hex-byte chunk concatenated where:
   - The first 16 hex-bytes are the block (initialization vector) that can be used to manipulate the Oracle. 
   - The second 16 hex-bytes are the block of data that should be decrypted.

   Each student has a unique keyid assigned, which corresponds to a secret key that is unique to their encrypted text. 
   The server will respond to the client with 'Message decrypted successfully' (valid padding) if the input decrypts with successful padding 
   And "Padding error during decryption" (invalid padding) otherwise.
   The server will only check padding for 2 blocks at the time (iv + ciphertext), if more blocks are sent it will check padding on the last two blocks.

   *Note* A hex byte is two chars (00, fe, ab, etc..) so two blocks of size 16 should be 64 TOTAL in length!

   Example usage:
   python client.py -ip localhost -p 10000 -b '0000000000000000000000000000000ec41cb170426f83ef05538c51ca28bbf3' -id 00

   In this case the IV is: 0000000000000000000000000000000e
   And the cipher text is:  c41cb170426f83ef05538c51ca28bbf3'
"""
# Dependencies
import argparse
import socket
import sys

	
# Length of either response.
# Server response may have spaces in it
# to adhere to message length
MESSAGE_LENGTH = 32
BLOCK_SIZE = 32

# Handle command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-ip", "--ipaddress", help='ip address where the server is running', required=True)
parser.add_argument("-p", "--port", help='port where the server is listening on', required=True)
parser.add_argument("-b", "--block", help='the 32-byte block sent to the server', required=True)
parser.add_argument("-id", "--keyid", help='unique key id', required=True)
args = parser.parse_args()

cipher_size = len(args.block)

if not(cipher_size % BLOCK_SIZE == 0):
  print "Bad block(s) size"
  exit()

else:
  # Create a TCP/IP socket
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

  # Connect the socket to the port where the server is listening
  server_address = (args.ipaddress, int(args.port))
  sock.connect(server_address)

  num_blocks = (cipher_size/BLOCK_SIZE)-1 # num_blocks to be decrypted (IV not counting as ciphertext block)

  try:
      # Send data
      message = args.block + ':' + str(num_blocks) + ':' + args.keyid  
      print >>sys.stderr, 'Sending: "%s"' % message
      sock.sendall(message)

      # Look for the response
      amount_received = 0
      amount_expected = MESSAGE_LENGTH

      while amount_received < amount_expected:
          data = sock.recv(MESSAGE_LENGTH)
          amount_received += len(data)
          print >>sys.stderr, 'Received: "%s"' % data
#	  # Attack starts here
#	  if (data == 'Message decrypted successfully  '):
#		print >>sys.stderr, 'start attack!'
#		#for i in range(1:num_blocks):
#		IV = args.block[0:15]
#		ctext =  args.block[16:32]
#		binary_IV = IV.decode("hex")
#		binary_ctext = ctext.decode("hex")
#		#for nbyte in range(16:0): # go through each byte in the block in reverse order 	  
#		for R in range(0:255):
#			binary_IVbyte = binary_IV[nbyte]
#			binary_R = R.encode("binary")
#			xoredSS = xor_strings(binary_R, binary_IVbyte).encode("hex")
#			newMessage = IV[0:14]`+ xoredSS + ctext
#			# Send new Message to the server and get response 
#			if (data == 'Message decrypted successfully   '):
#				#store the value of R into a list
#				
#			#print >>sys.stderr, xored	
  finally:
      sock.close()
