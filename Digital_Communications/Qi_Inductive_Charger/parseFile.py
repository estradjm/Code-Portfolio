# Import modules
import csv
import re
import os

# Grab all files in the current directory
filenames = next(os.walk(os.getcwd()))[2]

# Parse out filenames for .txt files and create a .csv file to output to
for f in filenames:
    if f.endswith(".txt"):
        filename = os.path.splitext(os.path.basename(f))[0]
        textname = filename + '.txt'
        csvname = filename + '.csv'
        fi = open(textname, 'r')
        fo = open(csvname, 'wb')

        # Create the csv writer object.
        mywriter = csv.writer(fo, dialect='excel')

        # string tokens to pull out lines we want
        token = 'Icoil'
        token2 = 'PPT'
        token3 = 'PPR'

        # CSV fieldnames
        fieldnames = ['Timestamp', 'Vin (mV)', 'Iin (mA)', 'Pinput (mW)', 'Icoil (mA)', 'PPT (mW)',
            'PwrLoss Threshold (mW)', 'PPR (mW)', 'PLoss (mW)', 'FOD']
        # Write headers to csv file
        writer = csv.DictWriter(fo, fieldnames=fieldnames)
        writer.writeheader()

        ### Read the first line and find first timestamp
        line = fi.readline()
        timestamp = re.findall(r"\[(.*?)\]", line)

        # Initialization of temporary iterators/variables
        rest1 = []
        rest2 = []
        rest3 = []
        prevTimestamp1=""
        prevTimestamp2=""
        prevTimestamp3=""

        # Iterate through all lines in file. If any of the three unique tokens are matched,
        # and the timestamps are different, capture the new data dependent on line,
        # pulling out necessary information using regular expressions, otherwise keep going.
        # The data is organized according to the headers in .csv file.
        while line:
            if token in line:
                [timestamp1] = re.findall(r"\[(.*?)\]", line)
                if timestamp1 != prevTimestamp1:
                    rest = re.findall(r'\[.*?\] (.*?): (.*?), (.*?): (.*?), (.*?): (.*?), (.*?): (.*?)\n', line)
                    rest2 = (timestamp1, rest[0][1].split('mV')[0], rest[0][3].split('mA')[0], rest[0][5].split('mW')[0], rest[0][7].split('mA')[0])
                    prevTimestamp1 = timestamp1
            if token2 in line:
                timestamp2 = re.findall(r"\[(.*?)\]", line)
                if timestamp2 != prevTimestamp2:
                    prevTimestamp2 = timestamp2
                    rest = re.findall(r'\[.*?\] (.*?): (.*?), (.*?): (.*?)\n', line)
                    rest3 = (rest2, rest[0][1].split('mW')[0], rest[0][3].split('mW')[0])
            if token3 in line:
                timestamp3 = re.findall(r"\[(.*?)\]", line)
                if timestamp3 != prevTimestamp3:
                    rest = re.findall(r'\[.*?\] (.*?): (.*?), (.*?): (.*?), (.*?):  (.*?) \n', line)
                    prevTimestamp3 = timestamp3
                    rest4 = (rest3, rest[0][1].split('mW')[0], rest[0][3].split('mW')[0], rest[0][5])
                    # Could use a better data structure implementation!
                    rest5 = rest4[0][0][0], rest4[0][0][1], rest4[0][0][2], rest4[0][0][3], rest4[0][0][4], rest4[0][1], rest4[0][2], rest4[1], rest4[2], rest4[3]
                    mywriter.writerow(rest5)
            # Move to the next line in file
            line = fi.readline()

        # Close all files
        fi.close()
        fo.close()
