# client.py
import socket
# Create a socket object
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Get local machine name
host = '192.168.0.26' # Use your correct IP or use socket.gethostname()
port = 9999
# Connection to hostname on the port.
s.connect((host, port))
color = raw_input("Choose the LED color (white or red or clean): ")
state = raw_input("On or Off state (1 or 0): ")
if color == 'white':
 num = 3
else:
 if color == 'red':
 num = 2
 else:
 print(('Cleaning up...'))
 num = 'clean'
 state = 0
s.send(str(num).encode())
s.send(str(state).encode())
# Receive no more than 1024 bytes
tm = s.recv(1024).decode()
print(tm)
s.close()