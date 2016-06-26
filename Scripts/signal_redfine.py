#!/usr/bin/python
# Script to parse and change I/O type in signal.db file
import os

#  Change working directory


fo = open('new_signal.db', 'w')  # temporary file

with open('signal.db') as fi:  # open original file
    for line in fi:
        pos = line.find('pointtype=')  # find point type in file
        strt_line = line[:pos + 10]  # string up to point type
        # string from after point type designation to end
        fin_line = line[pos + 12:]
        # check for each type and append point type accordingly
        if (line.find('SWB_DO') >= 0):
            fo.write((strt_line + 'DO' + fin_line))
        if (line.find('SWB_DI') >= 0):
            fo.write((strt_line + 'DI' + fin_line))
        if (line.find('SWB_FO') >= 0):
            fo.write((strt_line + 'AO' + fin_line))
        if (line.find('SWB_FI') >= 0):
            fo.write((strt_line + 'AI' + fin_line))
fi.close()  # close all files to save memory
fo.close()
os.remove('signal.db')  # remove original file
for filename in os.listdir("."):  # rename correct file to original file name
    if filename.startswith("new_"):
        os.rename(filename, filename[4:])
