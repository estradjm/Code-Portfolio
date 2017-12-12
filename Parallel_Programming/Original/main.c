/* 
All changes to code are copyright, 2017, Jenniffer Estrada, jmestrada@unm.edu
Research projects -- UNM and Jenniffer Estrada 
 */

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

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

//FILTER *filter_create_avg(int radius);

//FILTER *filter_create_gauss(int radius, double sigma);

//void filter_print(FILTER *filter);

//void filter_free(FILTER *filter);


typedef struct {
	unsigned char R;
	unsigned char G;
	unsigned char B;
} pixel;

//.ppm image
typedef struct {
	char header[3];
	int width, height;
	int color_depth;
	pixel **pixels;
} IMAGE;

//Loads an .ppm image from a given file
//IMAGE *image_load(const char *image_name);

//Writes the given image to the "image->image_name" file
//int image_write(IMAGE *image, const char *file_name);

//
//IMAGE *image_create_blank(IMAGE *source);

//Free
//void image_free(IMAGE *image);

//Apply a filter to the image
//IMAGE *apply_filter(IMAGE *original, FILTER *filter);


// HANDLE IMAGE READ AND WRITE 

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

	//Alocate memory for pixels
	image->pixels = (pixel**) malloc(image->height * sizeof(pixel*));
	int i, j;
	for(i = 0; i < image->height; i++)
		image->pixels[i] = (pixel*) malloc(image->width * sizeof(pixel));

	//Read pixels
	for(i = 0; i < image->height; i++)
		for(j = 0; j < image->width; j++)
			fscanf(file, "%c%c%c", &(image->pixels[i][j].R), &(image->pixels[i][j].G), &(image->pixels[i][j].B));

	//Close file
	fclose(file);

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
	int i;
	for(i = 0; i < image->height; i++)
		free(image->pixels[i]);
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
	//TODO: nu mai ignora marginile
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



	//The image that is going to be blurred
	IMAGE *image = NULL;

	//The resulting image
	IMAGE *result = NULL;

	//The used filter
	FILTER *filter;

	//Info
	char image_file_name[50];
	char result_file_name[50];
	int radius;
	double sigma;

	//Arguments: argv[0]="path", argv[1]="image_name.ppm", argv[2]="result_image_name.ppm" argv[3]="radius" argv[4]="sigma"
	if(argc == 5) {	//If enought arguments given take the info from the them
		//Original image file name
		strcpy(image_file_name, argv[1]);

		//Result image file name
		strcpy(result_file_name, argv[2]);

		//Convert radius
		radius = atoi(argv[3]);
	
		//Convert sigma
		sigma = atof(argv[4]);
	} else { //Read info from keyboard
		//Original image file name
		printf("Original image name: ");
		scanf("%s", image_file_name);
		
		//Result image file name
		printf("Result image name: ");
		scanf("%s", result_file_name);

		//Read radius
		printf("Radius: ");
		scanf("%d", &radius);

		//Read sigma
		printf("Sigma: ");
		scanf("%lf", &sigma);
	}

	//Load image
	printf("Loading image...\n");
	image = image_load(image_file_name);
	
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

	printf("DONE!\n");

	return 0;
}
