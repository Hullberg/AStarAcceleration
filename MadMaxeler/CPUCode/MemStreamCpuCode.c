#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Maxfiles.h"
#include "MaxSLiCInterface.h"
#include "../../bfs/graph_iteration.c"


int main(void)
{
	clock_t start_simulation_time = clock();
	srand(time(NULL)); // New seed, otherwise same results all the time. Comment out to compare approaches
	vertex_list = malloc(sizeof(Vertex*) * VERTEX_COUNT);

	init_vertices();
	init_arrays(); // We need this to init edges in update_edges.
	int count = 0;

	//Time variables:
	clock_t start_time_memstream;
	clock_t end_time_memstream;
	double memstream_time_sum = 0;
	int32_t** child_array = malloc(sizeof(int32_t*) * EDGE_COUNT);

	for(int i = 0; i < EDGE_COUNT;i++){
		child_array[i]=malloc(sizeof(int32_t) * VERTEX_COUNT);
	}

	int32_t size = sizeof(int32_t) * VERTEX_COUNT;
	int32_t* data_w = malloc(sizeof(int32_t) * VERTEX_COUNT);

	printf("Running a do/while-loop on DFE...\n");

	do {
		// This is update_edges, directly into child_x-arrays
		// Can we send this to EdgeStream?
		for (int i = 0; i < VERTEX_COUNT; i++) {
			for(int j = 0; j < EDGE_COUNT; j++){
				child_array[j][i]=vertex_list[vertex_list[i]->edges[j]]->value;
			}
		}

		// Having issues with dynamic amount of parameters, in this solution
		// Each loop, the kernel posts 'Mapped Elements Changed: Reloaded'.
		start_time_memstream = clock();

		//MemStream(size, child_array[0], child_array[1], child_array[2], child_array[3], data_w);
		MemStream(size, child_array[0], child_array[1], child_array[2], child_array[3], child_array[4], child_array[5], child_array[6], child_array[7], data_w);

		end_time_memstream = clock();
		memstream_time_sum += (end_time_memstream-start_time_memstream);



		//printf("Memstream time: %f\n", ((double)end_time_memstream-start_time_memstream)/CLOCKS_PER_SEC);


		for (int i = 0; i < VERTEX_COUNT; i++) {
			vertex_list[i]->value = data_w[i];
		}

		// Need to find a way to send all edges values to stream, and update children in output.
		// The idea was to send the update_edges into Maxeler to possibly speed up further.
		//EdgeStream(size, a,b);

		count++;

	}while(false);
	//while(!converged());
	printf("\nDone! Converged after %d iterations.\n", count);

	//printf("Converged at: %d\n", child_array[0][0]);



	free(data_w);
	for (int i = 0; i < VERTEX_COUNT; i++){
		free(vertex_list[i]->edges);
		free(vertex_list[i]);
	}
	for (int i = 0; i < EDGE_COUNT; i++) {
		free(edges[i]);
	}

	free(vertex_list);
	for(int i = 0; i < EDGE_COUNT;i++){
		free(child_array[i]);
	}
	free(child_array);
	clock_t end_simulation_time = clock();



	printf("Only CPU time: %f s\n", ((double)end_simulation_time-memstream_time_sum)/CLOCKS_PER_SEC);
	printf("Average Memstream time: %f\n", (memstream_time_sum/count)/CLOCKS_PER_SEC);
	printf("Total time: %f s\n", ((double)end_simulation_time-start_simulation_time)/CLOCKS_PER_SEC);
	printf("Not accurate, just used to compare different approaches.\n");
	printf("Done.\n");
	return 0;
}
