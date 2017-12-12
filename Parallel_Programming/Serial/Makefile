blur: 
	gcc -pg -o blur_ser main.c -lm

blur_vec: 
	icc -o blur_vec main.c -lm

blur_omp: 
	gcc -o blur_omp main.c -lm

blur_mpi: 
	mpicc -o blur_mpi main.c -lm

blur_acc: 
	pgcc -acc -Minfo=accel -ta=cc60,managed -o blur_acc main.c -lm

clean:
	rm blur_ser blur_vec blur_omp blur_mpi blur_acc
