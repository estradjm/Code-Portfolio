blur: 
	gcc -pg -o blur_ser main.c -lm

blur_omp: 
	gcc -O2 -fopenmp -o blur_omp main.c -lm

clean:
	rm blur_ser blur_omp
