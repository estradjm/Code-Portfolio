#!/bin/bash

rm out_serial.ppm out_openacc.ppm
make clean
make blur
make blur_acc


radius=1 
sigma=1

#run a test

#clear

echo " ----- Serial Wall Time-----------"
echo " " 
./blur_serial west.ppm out_serial.ppm $radius $sigma
echo " ----- Serial Wall Time-----------"
echo " " 
./blur_serial west_1.ppm out_serial.ppm $radius $sigma
echo " " 
echo " --------OpenACC Wall Time -----------------"
echo " " 
echo " --------OpenACC Wall Time -----------------"
echo " " 
./blur_acc west_1.ppm out_openacc.ppm $radius $sigma
echo " " 
echo " ------------------------------------"

