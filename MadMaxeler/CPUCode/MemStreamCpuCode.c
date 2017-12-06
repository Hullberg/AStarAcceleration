#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Maxfiles.h"
#include "MaxSLiCInterface.h"
#include "../../bfs/graph_iteration.c"


int main(void)
{
	//srand(time(NULL));
	vertex_list = malloc(sizeof(Vertex*) * VERTEX_COUNT);

	init_vertices();

	init_arrays();
	int count = 0;

	// Fill children from edges-pointer
	int32_t* child_0 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_1 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_2 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_3 = malloc(sizeof(int32_t) * VERTEX_COUNT);
	int32_t* child_4 = malloc(sizeof(int32_t) * VERTEX_COUNT);


	int32_t size = sizeof(int32_t) * VERTEX_COUNT;
	// Fill those with reasonable input from graph_iteration.c.
	int32_t* data_w = malloc(sizeof(int32_t) * VERTEX_COUNT);
	printf("Running on DFE.\n");
	//MemStream(endID, size, y, u, s);

	//double total_t;
	do {
		for (int i = 0; i < VERTEX_COUNT; i++) {
			child_0[i] = edges[0][i];
			child_1[i] = edges[1][i];
			child_2[i] = edges[2][i];
			child_3[i] = edges[3][i];
			child_4[i] = edges[4][i];
		}

		printf("before %i\n", child_3[0]);

		//clock_t start_t, end_t;
		//start_t = clock();
		MemStream(size, child_0, child_1, child_2, child_3, child_4, data_w);
		printf("after %i\n", child_3[0]);
		//end_t = clock();
		//double this_t = end_t - start_t;
		//printf("Seconds: %f\n", this_t/CLOCKS_PER_SEC);
		//total_t += this_t;


		for (int i = 0; i < VERTEX_COUNT; i++) {
			vertex_list[i]->value = data_w[i];
		}

		update_edges();

		count++;

	} while(!converged());
	printf("\nDone! Converged after %d iterations.\n", count);
	// We can free child_0 and child_1, but the others end with abort exit code return -1
	//free(child_0);
	//free(child_1);
	//free(child_2);
	//free(child_3);
	for (int i = 0; i < 100; i++) {
		printf("%d, %d, %d, %d, %d\n", child_0[i],child_1[i],child_2[i],child_3[i],child_4[i]);
	}

	/*printf("%d\n",child_0[0]);
	printf("%d\n",child_1[0]);
	printf("%d\n",child_2[0]);
	printf("%d\n",child_3[0]);
	printf("%d\n",child_4[0]);*/
	free(child_4);
	return 0;

	free(data_w);
	for (int i = 0; i < VERTEX_COUNT; i++){
		free(vertex_list[i]->edges);
		free(vertex_list[i]);
	}
	for (int i = 0; i < EDGE_COUNT; i++) {
		free(edges[i]);
	}
	free(vertex_list);
	printf("crashes below this.");
	free(child_0);
	free(child_1);
	free(child_2);
	free(child_3);
	free(child_4);

	// The get_path could be done here in CPU-code once everything is done.
	//free(vertex_list);
	printf("Done.\n");
	return 0;
}
