#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "Maxfiles.h"
#include "MaxSLiCInterface.h"

int main(void)
{
	const int size = 384;
	int sizeBytes = size * sizeof(int32_t);
	int32_t *x = malloc(sizeBytes);
	int32_t *y = malloc(sizeBytes);
	int32_t *s = malloc(sizeBytes);
	int scalar = 3; 

	// TODO Generate input data
	for(int i = 0; i<size; ++i) {
		x[i] = random() % 100;
		y[i] = random() % 100;
	}

	printf("Writing to LMem.\n");
	MemStream_writeLMem(0, sizeBytes, x);

	printf("Running on DFE.\n");	
	MemStream(scalar, size, y, s);
	
	// TODO Use result data
	for(int i=0; i<size; ++i)
		if (s[i] != x[i] + y[i] + scalar)
			return 1;

	printf("Done.\n");
	return 0;
}
