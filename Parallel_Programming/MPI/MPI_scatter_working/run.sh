#!/bin/bash

make

radius=1 
sigma=1

#run a test
./blur west_1.ppm out.ppm $radius $sigma

