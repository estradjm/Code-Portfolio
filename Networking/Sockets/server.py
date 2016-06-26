# server.py
# NOTE: Run on the raspberry pi after getting RPi.GPIO library
import socket
import RPi.GPIO as GPIO # Import library
GPIO.setmode(GPIO.BCM) # Setup the RPi board
# Create a socket object
serversocket = socket.socket(
 socket.AF_INET, socket.SOCK_STREAM)
# Get local machine name
host = '192.168.0.26' # replace with your correct IP or use socket.gethostname()
port = 9999
# Bind to the port
serversocket.bind((host, port))
# Queue up to 5 requests
serversocket.listen(5)
print(("Server Running. IP: " + str(host)))
while True:
 # Establish a connection
 clientsocket, addr = serversocket.accept()
 print(("Got a connection from " + str(addr)))
 num = clientsocket.recv(1024).decode()
 state = clientsocket.recv(1024).decode()
 if num == 'clean':
 GPIO.cleanup()
 r = "Board reset!"
 clientsocket.send(r.encode())
 else:
 GPIO.setup(int(num), GPIO.OUT) # Select pin
 GPIO.output(int(num), int(state)) # Change the state of the selected pin
 print(("Recieved state change of " + str(state) + " for pin " + str(num)))
 r = "Server executed state change!"
 clientsocket.send(r.encode())
 clientsocket.close()