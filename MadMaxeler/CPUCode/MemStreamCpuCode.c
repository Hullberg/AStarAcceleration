#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Maxfiles.h"
#include "MaxSLiCInterface.h"
#include "../../bfs/graph_iteration.c"


int main(void)
{
	clock_t start = clock();
	srand(time(NULL)); // New seed, otherwise same results all the time. Comment out to compare approaches
	vertex_list = malloc(sizeof(Vertex*) * VERTEX_COUNT);

	init_vertices();
	init_arrays(); // We need this to init edges in update_edges.
	int count = 0;

	int32_t* child_0 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_1 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_2 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_3 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_4 = malloc(sizeof(int32_t) * VERTEX_COUNT);

	int32_t size = sizeof(int32_t) * VERTEX_COUNT;
	int32_t* data_w = malloc(sizeof(int32_t) * VERTEX_COUNT);

	printf("Running a do/while-loop on DFE...\n");

	do {
		// This is update_edges, directly into child_x-arrays
		// Can we send this to EdgeStream?
		for (int i = 0; i < VERTEX_COUNT; i++) {
			child_0[i] = vertex_list[vertex_list[i]->edges[0]]->value;
			child_1[i] = vertex_list[vertex_list[i]->edges[1]]->value;
			child_2[i] = vertex_list[vertex_list[i]->edges[2]]->value;
			child_3[i] = vertex_list[vertex_list[i]->edges[3]]->value;
			child_4[i] = vertex_list[vertex_list[i]->edges[4]]->value;
		}

		// Having issues with dynamic amount of parameters, in this solution
		// Each loop, the kernel posts 'Mapped Elements Changed: Reloaded'.
		MemStream(size, child_0, child_1, child_2, child_3, child_4, data_w);


		for (int i = 0; i < VERTEX_COUNT; i++) {
			vertex_list[i]->value = data_w[i];
		}

		// Need to find a way to send all edges values to stream, and update children in output.
		// The idea was to send the update_edges into Maxeler to possibly speed up further.
		//EdgeStream(size, a,b);

		count++;

	} while(!converged());
	printf("\nDone! Converged after %d iterations.\n", count);
	printf("Converged at: %d\n", child_0[1337]);



	free(data_w);
	for (int i = 0; i < VERTEX_COUNT; i++){
		free(vertex_list[i]->edges);
		free(vertex_list[i]);
	}
	for (int i = 0; i < EDGE_COUNT; i++) {
		free(edges[i]);
	}
	free(vertex_list);
	free(child_0);
	free(child_1);
	free(child_2);
	free(child_3);
	free(child_4);

	clock_t t = clock();

	printf("Some form of simulation time: %f\n", ((double)t-start)/CLOCKS_PER_SEC);
	printf("Not accurate, just used to compare different approaches.\n");
	printf("Done.\n");
	return 0;
}
