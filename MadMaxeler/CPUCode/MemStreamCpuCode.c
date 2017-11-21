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


	for(int i = 0; i<size; ++i) {
		x[i] = random() % 100;
		y[i] = random() % 100;
	}


	// Unable to find where these functions are defined
	// The manager gets them in EngineCode/src/memstream/MemStreamManager.maxj
	// I assume this is where we write the vertices & edges to
	printf("Writing to LMem.\n");
	MemStream_writeLMem(0, sizeBytes, x);


	// s is the output variable
	// I assume this is where we add unvisited vertices.
	printf("Running on DFE.\n");	
	MemStream(scalar, size, y, s);
	

	for(int i=0; i<size; ++i)
		// The line below is in kernel:  DFEVar sum = x + y + a;
		// Followed by io.output("s", sum, type)
		if (s[i] != x[i] + y[i] + scalar)
			return 1;

	printf("Done.\n");
	return 0;
}
