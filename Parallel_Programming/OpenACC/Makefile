blur: 
	icc -g -O3 -o blur_serial main.c -lm

blur_acc: 
	pgcc -g -O3 -ta=tesla:cc60,managed,lineinfo,fastmath,llvm,safecache,loadcache:L1,beta,rdc -o blur_acc main.c -lm

blur_acc_exp: 
	pgcc -acc -Minfo=all -ta=tesla:cc60,managed -o blur_acc main.c -lm

clean:
	rm blur_serial blur_acc
