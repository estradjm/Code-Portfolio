#!/bin/bash

make clean
make blur

radius=1 
sigma=1

#run a test
./blur_serial west_1.ppm out.ppm $radius $sigma

