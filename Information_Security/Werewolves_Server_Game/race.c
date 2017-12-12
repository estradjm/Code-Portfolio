#include <stdlib.h>
#include <stdio.h>

#define MAX_BYTES 1024

int main(int argc, char* argv[]) {

    // local vars
    FILE *fp;
    char *filename = argv[1];
    char *text;

    // allocate memory
    text = calloc(MAX_BYTES+1, sizeof(char));
    if(text==NULL) {
        printf("error with calloc\n");
        return(1);
    }

    // check to see we've called with an argument
    if(argc<=1) {
        printf("usage: race <filename>\n");
        return(1);
    }

    // look for file
    printf("attempting to read file: '%s'...", filename);
    fflush(stdout);
    while(fp==NULL) fp = fopen(filename, "r");
    printf("\n");

    // success
    printf("race: GOT IT!  now watching...\n");
    while(1) {
        char *p = fgets(text, MAX_BYTES, fp);
        if(p==NULL) continue;
        printf("%s", text);
    }
    fclose(fp);
    free(text);
    return(0);
}

