#!/bin/bash
module purge
module load openmpi/1.10.0/gcc/4.8.3 compiler/gcc/4.8.5 

#remove all files
rm blur_mpi rank_*
make clean 

make blur_mpi

#radius=1 
#sigma=1

#run a test in multiples 
#nranks=1

clear

for nranks in {1..16}; do
echo "============================================================";
echo "number of ranks: " $nranks;
mpirun -n $nranks ./blur_mpi; #west_1.ppm out.ppm $radius $sigma
echo "============================================================";
done;
