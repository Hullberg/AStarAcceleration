#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "Maxfiles.h"
#include "MaxSLiCInterface.h"


int main(void)
{
	// Multiple of 384 bytes due to array size (64) burst-aligned
	const int size = 384;
	int sizeBytes = size * sizeof(int32_t);
	int32_t *x = malloc(sizeBytes); //TODO Change this to Vertex struct, should be ALL vertices.
	int32_t *y = malloc(sizeBytes);
	int32_t *s = malloc(sizeBytes);
	int32_t *u = malloc(sizeBytes);
	int scalar = 5; // TODO This should be goal ID.


	for(int i = 0; i<size; ++i) {
		x[i] = random() % 100;
		y[i] = random() % 100 +1;
		u[i] = 0;
	}

	// The manager gets them in EngineCode/src/memstream/MemStreamManager.maxj
	// Write all vertices to LMem.
	printf("Writing to LMem.\n");
	MemStream_writeLMem(0, sizeBytes, x);


	// First run we send in the ID of the start-vertix. Result is an int* of children's ID's.
	// Send those ID's through the same process.
	// Repeat until goal is found.
	printf("Running on DFE.\n");	
	MemStream(scalar, size, y, u, s);
	

	for(int i=0; i<size; ++i){
		// The line below is in kernel:  DFEVar sum = x + y + a;
		// This will be executed for that index when the data is ready
		// Followed by io.output("s", sum, type)
		printf("s=%d, x= %d, y= %d, sc= %d, u = %d  \n", s[i], x[i+1], y[i], scalar, u[i]);
		//if (s[i] != x[i] + y[i] + scalar + u[i])
			//return 1;

	}
	//printf("First done, next one up! \n");
	/*for(int i = 0; i<size; ++i) {
		y[i] = s[i];
	}
	MemStream(scalar, size, y, s);
	for(int i=0; i<size; ++i){
			// The line below is in kernel:  DFEVar sum = x + y + a;
			// This will be executed for that index when the data is ready
			// Followed by io.output("s", sum, type)
			printf("%d = %d + %d  \n", s[i], x[i], y[i]);

		}*/
	printf("Done.\n");
	return 0;
}
