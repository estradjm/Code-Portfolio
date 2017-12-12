"""Server.py
   This module is the 'padding oracle'. It takes 2 command-line arguments:

     1. -ip (--ipaddress): The IP address of the machine to run the server.
     2. -p (--port):       The port to listen on.
   
   server.py runs and listens on a port for a 32-byte chunk of data. The first 16-byte block
   is used as the initialization vector and the second 16-byte block is the encrypted data
   that is decrypted server-side and verified that proper padding is used. If proper padding
   is achieved, the server will respond with 'Valid' otherwise it will respond with 'Invalid'.
   This is all students need to work their way down and successfully decrypt the message.

   Example usage:
   python server.py -ip localhost -p 10000 
"""

# Dependencies
import argparse
import socket
import sys
from Crypto.Cipher import AES
from keys import keyids

#-------------------------------------------------------------------

# Size a key should adhere to in chars
KEY_SIZE = 16

# A block is 16 hex bytes, which will be 32 total chars, so a student should supply 64 chars
BLOCK_SIZE = 32

#-------------------------------------------------------------------
def get_2blocks(data):

  all_blocks = len(data)
  if not(all_blocks % BLOCK_SIZE == 0):
    return (' ', ' ')

  else: 
    num_blocks = all_blocks/BLOCK_SIZE
  
    get_blocks = [data[x:x+BLOCK_SIZE] for x in range(0,len(data),BLOCK_SIZE)]
    last_block = get_blocks[num_blocks-1]
    sec_last_block = get_blocks[num_blocks-2]

    print 'Checking pading for IV:', sec_last_block, 'and block', last_block

    # Chop the byte string in half and convert to raw hex
    block_0 = sec_last_block.decode('hex')
    block_1 = last_block.decode('hex')

    return (block_0, block_1)

#-------------------------------------------------------------------

def check_padding(block_pair, secret_key):
    """ The magic: Decrypt the block and check if the padding is valid

    Using the block pair supplied from I/O, decrypt and then check to
    see if the resulting string has valid padding. Return True or False.

    *Note*: The decrypted block can be garbage. As long as it follows,
    the padding rules then we return True. Otherwise, return False.
    """

    iv = block_pair[0]
    cipher_text = block_pair[1]

    if (iv == ' ' and cipher_text == ' '):
        valid_padding = False
        print "Bad Block Size"

    else:
      aes = AES.new(secret_key, AES.MODE_CBC, iv)
      plain_text = aes.decrypt(cipher_text)

      # give the int value of the last char in plain_text   
      pt_len = ord(plain_text[-1])
      # If last byte is:         /x01 then it's valid
      # If last two bytes are:   /x02/x02 then it's valid
      # If last three bytes are: /x03/x03/x03 then it's valid
      # etc...
      valid_padding = (plain_text[-pt_len:] == chr(pt_len) * pt_len)
      return valid_padding


#-------------------------------------------------------------------

def find_key(key_id):
  if keyids.has_key(key_id):
    secret_key = keyids[key_id]
    #exit()
    return secret_key

#-------------------------------------------------------------------

def valid_keyid(key_id):
  valid_key = False

  if keyids.has_key(key_id):
    valid_key = True
    return valid_key

#-------------------------------------------------------------------

# Parse Command-Line Arguments
parser = argparse.ArgumentParser()
parser.add_argument("-ip", "--ipaddress")
parser.add_argument("-p", "--port")
args = parser.parse_args()

# Create TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind socket to port
server_address = (args.ipaddress, int(args.port))
print >>sys.stderr, 'Starting up on: %s port %s' % server_address
sock.bind(server_address)

# Listen for incoming connections
sock.listen(10)

while True:
  print >>sys.stderr, 'Waiting for a connection...' # Wait for a conneciton
  connection, client_address = sock.accept()
  
  try:
    print >>sys.stderr, 'Connection from:', client_address

    # Receive the data in small chunks and retransmit it
    while True:
      # If someone sends more than BLOCK_SIZE * 2 bytes it will only see the first BLOCK_SIZE * 2
      message = connection.recv((BLOCK_SIZE * 11)+3+3)
      print >>sys.stderr, 'Received: "%s"' % message

      split_message = message.split(':') # receive and split the message where':'
      data = split_message[0] # data (spit_message[0]) = ciphertext 
      key_id = split_message[2] # key_id = key id
      blocks_rcvd = split_message[1] # num_blocks of ciphertext (iv not counting as ciphertext block)
      print 'Blocks received', blocks_rcvd

      valid_key = valid_keyid(key_id) 

      if valid_key == True:
        secret_key = find_key(key_id) # look for correspondent secret_key
        print  'Key ID:', key_id
        print 'Secret Key: ', secret_key

      else:
        print >>sys.stderr, 'Key ID incorrect'
        # Connection sends 32 bytes regardless of valid or invalid that way the client knows when to stop listening. Hence, extra spaces.
        connection.sendall("Key ID is not valid. Try again  ")
        break

      # Perform block split and check for valid padding
      block_pair = get_2blocks(data) # block_pair = ciphertext split into 2 blocs
      valid_padding = check_padding(block_pair, secret_key) #check for valid padding 

      if valid_padding == True:
        print >>sys.stderr, 'Sending VALID back to the client'
        # Connection sends 32 bytes regardless of valid or invalid that way the client knows when to stop listening. Hence, extra spaces.
        connection.sendall("Message decrypted successfully  ")
        break


      elif valid_padding == False:
        print >>sys.stderr, 'Sending INVALID back to the client'
        # Connection sends 32 bytes regardless of valid or invalid that way the client knows when to stop listening. Hence, extra spaces.
        connection.sendall("Padding error during decryption!")
        break

    else:
      print >>sys.stderr, 'No more data from:', client_address
      break
  
  finally:
        # Clean up the connection
        connection.close()
