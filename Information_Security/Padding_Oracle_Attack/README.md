# Padding Oracle Attack

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/estradjm/paddingOracleAttack/blob/master/LICENSE.md)

### Padding Oracle Attack to decipher AES CBC mode encrypted communications from a server


The script, attack.py, contains the code used to execute the padding oracle attack given the ciphertext captured in a WireShark session (ciphertext.pcap). Client.py contains code to connect to the server and communicate correctly, and server.py contains the server's code (not used or needed). 

The exploit (attack.py) was tested on a UNM server belonging to Dr. Jedidiah Crandall for CS 544/444: CyberSecurity course with the following parameters:

ip = "shasta.cs.unm.edu"

port = "10042"

keyID = "42"

IV="6c3557445137314654744e7978616f37"

message="969a37b07f0c8612b51b6d2e0812ab639fe23e3110407b2fead289b3ffe2ab030c32d380fa0c068e1361988ea8394f3aaa985a54080d7ee2bbfdd979db6e91683c49201b148a114c504d0a5cb2776e2f97e929ef7ca61cd8b1b6479950be2b99ddb335b1addffbdfd97aba01359e6996f3261825aa9bf44fe5c8acbaf60be3cd73dd8bf9906a1ded8ddf0f875a376b90e55571774be1b6e49b70ce2915655bd0"

The keyID was a unique identifier to discern which message in the pcap file pertained to me (each student had a unique message) and which port to attack on the server (port 10000 + keyID, which in my case is 10042), and the server given by the variable, ip. Using the initialization vector, IV, and the message in blocks of 32 bytes (there are 10 blocks), the server is given a message altered one byte at a time, and the responses from the server are then used to decrypt the messsage. 
