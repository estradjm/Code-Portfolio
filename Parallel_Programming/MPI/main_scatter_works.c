/* 
All changes to code are copyright, 2017, Jenniffer Estrada, jmestrada@unm.edu
Research projects -- UNM and Jenniffer Estrada 
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <mpi.h>

#define PI 3.14159265

typedef enum {
	FILTER_AVG, 
	FILTER_GAUSS
} filter_type;

typedef struct {
	int radius;
	double **matrix;
	int type;
} FILTER;

typedef struct {
	long long int R;
	long long int G;
	long long int B;
} pixel;

//.ppm image
typedef struct {
	char header[3];
	int width, height;
	int color_depth;
	pixel **pixels;
} IMAGE;



IMAGE *image_load(const char *image_name) {
	//Declare image struct
	IMAGE *image = (IMAGE*) malloc( sizeof(IMAGE) );

	//Open file
	FILE *file = fopen(image_name, "r");
	if(!file)
		return NULL;

	//Read image info
	fscanf(file, "%s", image->header);
	fscanf(file, "%d %d %d", &(image->width), &(image->height), &(image->color_depth));
	(image->width)=8;
	(image->height)=8;
	//Alocate contiguous memory
	void * pixels_contiguous = (pixel**) malloc(image->height * image->width * sizeof(pixel));
	int i, j;

	//allocate column of pointers
	image->pixels = (pixel**) malloc(image->height * sizeof(pixel*));
	
	// base address
	image->pixels[0] = pixels_contiguous;

	// Assigning pointers to each row in matrix
	for(i = 1; i < image->height; i++)
		image->pixels[i] = image->pixels[i-1]+image->width;


	//Read pixels
	for(i = 0; i < image->height; i++)
		for(j = 0; j < image->width; j++)
			fscanf(file, "%c%c%c", &(image->pixels[i][j].R), &(image->pixels[i][j].G), &(image->pixels[i][j].B));
	
	for(i = 0; i < image->height; i++)
		for(j = 0; j < image->width; j++){
			 (image->pixels[i][j].R)=i;
			(image->pixels[i][j].G )= j;
			(image->pixels[i][j].B)=1;
		}
	//Close file
	fclose(file);

	return image;
}

// Create local contiguous memory subset array for MPI - vertical dimension of the main image is equally divided by number of processes plus the halos (top and bottom)
IMAGE *image_local(int nx, int ny, int nprocs, int halo_width) {

	//Declare image struct
	IMAGE *image = (IMAGE*) malloc( sizeof(IMAGE) );
	image->height=ny/nprocs+halo_width;
	image->width = nx;
	//Alocate contiguous memory
	void * pixels_contiguous = (pixel**) malloc(nx * ((ny/nprocs) + (halo_width)) * sizeof(pixel));
	int i, j;

	//allocate column of pointers
	image->pixels = (pixel**) malloc(((ny/nprocs) + halo_width) * sizeof(pixel*));
	
	// base address
	image->pixels[0] = pixels_contiguous;

	// Assigning pointers to each row in matrix
	for(i = 1; i < ((ny/nprocs) + halo_width); i++)
		image->pixels[i] = image->pixels[i-1]+nx;

printf("ABOUT TO START THE LOOP!! .........");	
	for(i = 0; i < (ny)/nprocs+halo_width; i++)
		for(j = 0; j < nx; j++){
			printf("%d %d %d ", i, j, image->pixels[i][j].R);
			 (image->pixels[i][j].R)= -i;
			(image->pixels[i][j].G )= -j;
			(image->pixels[i][j].B)=-1;
		}
	return image;
}

int image_write(IMAGE *image, const char *file_name) {
	//Open file
	FILE *file = fopen(file_name, "w");
	if(!file)
		return 0;
	
	//Write image info
	fprintf(file, "%s\n%d %d\n%d", image->header, image->width, image->height, image->color_depth);

	//Write pixels
	int i, j;
	for(i = 0; i < image->height; i++)
		for(j = 0; j < image->width; j++)
			fprintf(file, "%c%c%c", image->pixels[i][j].R, image->pixels[i][j].G, image->pixels[i][j].B);

	//Write EOF
	fprintf(file, "%d", EOF);

	//Close file
	fclose(file);

	return 1;
}

IMAGE *image_create_blank(IMAGE *source) {
	//Declare
	IMAGE *image = (IMAGE*) malloc( sizeof(IMAGE) );

	//Copy info(except pixels)
	strcpy(image->header, source->header);
	image->height = source->height;
	image->width = source->width;
	image->color_depth = source->color_depth;

	//Alloc mem for pixels
	image->pixels = (pixel**) malloc(image->height * sizeof(pixel*));
	int i;
	for(i = 0; i < image->height; i++)
		image->pixels[i] = (pixel*) malloc(image->width * sizeof(pixel));

	return image;
}

void image_free(IMAGE *image) {
	//Free pixels

	free(image->pixels[0]);
	free(image->pixels);

	//Free image
	free(image);
}


// Create filter
FILTER *filter_create_avg(int radius) {
	//Allocate mem for the structure
	FILTER *filter = (FILTER*) malloc(sizeof(FILTER));
	filter->radius = radius;
	filter->type = FILTER_AVG;

	//Used for iterations
	int i, j;

	//The matrix width and height
	int dim = 2*radius+1;

	//Alocate mem for the matrix
	filter->matrix = (double**) malloc(dim * sizeof(double*));
	for(i = 0; i < dim; i++)
		filter->matrix[i] = (double*) malloc(dim * sizeof(double));

	//The value that every entry in the matrix will contain
	double avg = 1.0 / (dim * dim);

	//Set the values
	for(i = 0; i < dim; i++)
		for(j = 0; j < dim; j++)
			filter->matrix[i][j] = avg;

	return filter;	
}

double gauss_2d(int x, int y, double sigma) {
	double result = 1.0 / (2 * PI * sigma * sigma);
	result *= exp(-(x*x+y*y)/(2 * sigma * sigma));
	return result;
}

FILTER *filter_create_gauss(int radius, double sigma) {
	//Allocate mem for the structure
	FILTER *filter = (FILTER*) malloc(sizeof(FILTER));
	filter->radius = radius;
	filter->type = FILTER_GAUSS;

	//Used for iterations
	int i, j;

	//The matrix width and height
	int dim = 2*radius+1;

	//Alocate mem for the matrix
	filter->matrix = (double**) malloc(dim * sizeof(double*));
	for(i = 0; i < dim; i++)
		filter->matrix[i] = (double*) malloc(dim * sizeof(double));

	//Calculate
	double sum = 0.0;
	for(i = -radius; i <= radius; i++)
		for(j = -radius; j <= radius; j++) {
			filter->matrix[i+radius][j+radius] = gauss_2d(j, i, sigma);
			sum += filter->matrix[i+radius][j+radius];
		}

	//Correct so that the sum of all elements ~= 1
	for(i = 0; i < 2*radius+1; i++)
		for(j = 0; j < 2*radius+1; j++)
			filter->matrix[i][j] /= sum;

	return filter;
}

void filter_print(FILTER *filter) {
	int dim = 2*filter->radius+1, i, j;

	for(i = 0; i < dim; i++) {
		for(j = 0; j < dim; j++) 
			printf("%lf ", filter->matrix[i][j]);
		printf("\n");
	}
}

void filter_free(FILTER *filter) {
	//Free matrix
	int dim=2*filter->radius+1, i;
	for(i = 0; i < dim; i++)
		free(filter->matrix[i]);
	free(filter->matrix);

	//Free filter
	free(filter);
}


// Manipulate image with filter
void apply_to_pixel(int x, int y, IMAGE *original, IMAGE *result, FILTER *filter) {
	if(x<filter->radius || y<filter->radius || x>=original->width-filter->radius || y>=original->height-filter->radius) {
		result->pixels[y][x] = original->pixels[y][x];
		return;
	}

	int i, j;
	pixel res;
	res.R = res.G = res.B = 0;
	double fil;

	for(i = -filter->radius; i <= filter->radius; i++) 
		for(j = -filter->radius; j <= filter->radius; j++) {
			fil = filter->matrix[i+filter->radius][j+filter->radius];
			res.R += fil * original->pixels[y+i][x+j].R;
			res.G += fil * original->pixels[y+i][x+j].G;
			res.B += fil * original->pixels[y+i][x+j].B;
		}
	
	result->pixels[y][x].R = res.R;
	result->pixels[y][x].G = res.G;
	result->pixels[y][x].B = res.B;
}

IMAGE *apply_filter(IMAGE *original, FILTER *filter) {
	IMAGE *result = image_create_blank(original);

	int x, y;
	for(y = 0; y < original->height; y++)
		for(x = 0; x < original->width; x++)
			apply_to_pixel(x, y, original, result, filter);

	return result;
}


// MAIN PROGRAM
int main(int argc, char *argv[]) {

	int rank, nprocs, nx, ny;
	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	

	//The image that is going to be blurred
	IMAGE *image = NULL;

	//The resulting image
	IMAGE *result = NULL;

	//The used filter
	FILTER *filter;

	//Info
	char image_file_name[50]="west.ppm";
	char result_file_name[50]="out_mpi.ppm";
	int radius=1;
	double sigma=1.0;

	//Load image
	printf("Loading image...\n");

	image = image_load(image_file_name);
	printf("Finished Loading image...\n");
	ny = image->height;
	nx = image->width;
	
	printf("Got image sizes ...\n");
	printf(" IMAGE height: %d \n IMAGE width: %d \n", ny, nx); 
	
	int halo_width = 2*radius; 


	IMAGE * local = image_local(nx, ny, nprocs,  halo_width); 
	if(ny/nprocs*nprocs != ny){
		printf("ERROR: Height not a multiple of processes! \n");
		MPI_Finalize();
		exit(0);
	}
	printf("%d: %d %d %d %p %p", rank, nx, ny, nprocs, image->pixels, &(local->pixels[radius][0]));
	fflush(stdout);
	MPI_Barrier(MPI_COMM_WORLD);

	
	char file[100];
	sprintf(file, "rank_%d.txt", rank); 
	FILE *fp = fopen(file, "w");
	int i, j;
	for ( i=0;i<image->height ;i++ ){
		for(j=0;j<image->width ;j++){
			fprintf(fp, " %d %d ", image->pixels[i][j].R, image->pixels[i][j].G);
		}
		fprintf(fp, "\n");
	}

	fprintf(fp, "\n");
	fprintf(fp, "\n");
	fprintf(fp, "\n");

	for ( i=0;i<image->height/nprocs +2*radius ;i++ ){
		for(j=0;j<image->width ;j++){
			fprintf(fp, " %d %d ", local->pixels[i][j].R, local->pixels[i][j].G);
		}
		fprintf(fp, "\n");
	}
	MPI_Scatter(&(image->pixels[0][0]), (ny/nprocs)*3* nx, MPI_LONG_LONG, &(local->pixels[radius][0]), (ny/nprocs)*3 * nx, MPI_LONG_LONG, 0, MPI_COMM_WORLD ); // every process should create it's own contiguous correct sized local array
	//MPI_Scatter(image->pixels, (ny/nprocs)*3* nx, MPI_CHAR, &local->pixels[radius][0], (ny/nprocs) *3* nx, MPI_CHAR, 0, MPI_COMM_WORLD ); // every process should create it's own contiguous correct sized local array
	fprintf(fp, "\n");
	fprintf(fp, "After Scatter: \n");
	fprintf(fp, "\n");
	for ( i=0;i<image->height/nprocs +2*radius ;i++ ){
		for(j=0;j<image->width ;j++){
			fprintf(fp, " %d %d ", local->pixels[i][j].R, local->pixels[i][j].G);
		}
		fprintf(fp, "\n");
	}
// Checking output of each rank using text files marked with each Rank ID
	MPI_Finalize();
	exit(0);	
	sprintf(file, "rank_%d.txt", rank); 
	image_write(local, file);

	image_free(local);
	MPI_Finalize();
	return 0;
/*	
	int pabove (rank+1)%nprocs;
	int pbelow = (rank-1+nprocs)%nprocs;
	MPI_Request req[2*nprocs]; //1 and 0 for pair of procs - now just two, make generalized!
	MPI_Irecv(&local[0], ny/npy, MPI_DOUBLE, pbelow, 1, MPI_COMM_WORLD, &req[0]);
	MPI_Irecv(&local[0], ny/npy, MPI_DOUBLE, pabove, 0, MPI_COMM_WORLD, &req[1]); //unsure of dimensions for locals?
	MPI_Isend(&local[0], ny/npy, MPI_DOUBLE, pbelow, 1, MPI_COMM_WORLD, &req[2]);
	MPI_Isend(&local[0], ny/npy, MPI_DOUBLE, pabove, 0, MPI_COMM_WORLD, &req[3]);

	MPI_Waitall(4, req, MPI_STATUS_IGNORE);

	printf("\n checkpoint!!! \n")

*/	
	//Create filter
	printf("Creating filter...\n");
	filter = filter_create_gauss(radius, sigma);

	//Apply filter
	printf("Appling filter...\n");
	result = apply_filter(image, filter);

	//Write image to disk
	printf("Writing image to disk...\n");
	image_write(result, result_file_name);

	//Free memory
	image_free(image);
	image_free(result);
	filter_free(filter);
	
	image_free(local);
	MPI_Finalize();

	printf("DONE!\n");

//	return 0;
}
