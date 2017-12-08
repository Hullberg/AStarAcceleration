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
	//srand(time(NULL)); // New seed, otherwise same results all the time
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

	for (int i = 0; i < VERTEX_COUNT; i++) {
					child_0[i] = edges[0][i];
					child_1[i] = edges[1][i];
					child_2[i] = edges[2][i];
					child_3[i] = edges[3][i];
					child_4[i] = edges[4][i];
				}

	int32_t size = sizeof(int32_t) * VERTEX_COUNT;
	// Fill those with reasonable input from graph_iteration.c.
	int32_t* data_w = malloc(sizeof(int32_t) * VERTEX_COUNT);

	printf("Running on DFE.\n");

	//double total_t;
	//clock_t t, t2;

	do {


		// Having issues with dynamic amount of parameters, in this solution
		MemStream(size, child_0, child_1, child_2, child_3, child_4, data_w);


		for (int i = 0; i < VERTEX_COUNT; i++) {
			vertex_list[i]->value = data_w[i];
		}

		// Unroll update_edges into maxeler. and just keep it at children.
		/*
		void update_edges() {
  	  		for (int i = 0; i < VERTEX_COUNT; i++) {
				for (int j = 0; j < EDGE_COUNT; j++) {
 					edges[j][i] = vertex_list[vertex_list[i]->edges[j]]->value;
    			}
			}
1
			// UNROLL:
			 * for (int i = 0; i < VERTEX_COUNT; i++) {
			child_0[i] = vertex_list[vertex_list[i]->edges[0]]->value;
			child_1[i] = vertex_list[vertex_list[i]->edges[1]]->value;
			child_2[i] = vertex_list[vertex_list[i]->edges[2]]->value;
			child_3[i] = vertex_list[vertex_list[i]->edges[3]]->value;
			child_4[i] = vertex_list[vertex_list[i]->edges[4]]->value;
		}

		}
		 */

		//t = clock();
		//printf("%f\n", (double)t);
		// Unrolled: 9.84, rolled: 8.87 (update_edges)
		for (int i = 0; i < VERTEX_COUNT; i+=5) {
			child_0[i] = vertex_list[vertex_list[i]->edges[0]]->value;
			child_0[i+1] = vertex_list[vertex_list[i+1]->edges[0]]->value;
			child_0[i+2] = vertex_list[vertex_list[i+2]->edges[0]]->value;
			child_0[i+3] = vertex_list[vertex_list[i+3]->edges[0]]->value;
			child_0[i+4] = vertex_list[vertex_list[i+4]->edges[0]]->value;
			child_1[i] = vertex_list[vertex_list[i]->edges[1]]->value;
			child_1[i+1] = vertex_list[vertex_list[i+1]->edges[1]]->value;
			child_1[i+2] = vertex_list[vertex_list[i+2]->edges[1]]->value;
			child_1[i+3] = vertex_list[vertex_list[i+3]->edges[1]]->value;
			child_1[i+4] = vertex_list[vertex_list[i+4]->edges[1]]->value;
			child_2[i] = vertex_list[vertex_list[i]->edges[2]]->value;
			child_2[i+1] = vertex_list[vertex_list[i+1]->edges[2]]->value;
			child_2[i+2] = vertex_list[vertex_list[i+2]->edges[2]]->value;
			child_2[i+3] = vertex_list[vertex_list[i+3]->edges[2]]->value;
			child_2[i+4] = vertex_list[vertex_list[i+4]->edges[2]]->value;
			child_3[i] = vertex_list[vertex_list[i]->edges[3]]->value;
			child_3[i+1] = vertex_list[vertex_list[i+1]->edges[3]]->value;
			child_3[i+2] = vertex_list[vertex_list[i+2]->edges[3]]->value;
			child_3[i+3] = vertex_list[vertex_list[i+3]->edges[3]]->value;
			child_3[i+4] = vertex_list[vertex_list[i+4]->edges[3]]->value;
			child_4[i] = vertex_list[vertex_list[i]->edges[4]]->value;
			child_4[i+1] = vertex_list[vertex_list[i+1]->edges[4]]->value;
			child_4[i+2] = vertex_list[vertex_list[i+2]->edges[4]]->value;
			child_4[i+3] = vertex_list[vertex_list[i+3]->edges[4]]->value;
			child_4[i+4] = vertex_list[vertex_list[i+4]->edges[4]]->value;
		}
		//update_edges();

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

	// The get_path could be done here in CPU-code once everything is done.

	clock_t t = clock();

	printf("Total time: %f\n", ((double)t-start)/CLOCKS_PER_SEC);
	printf("Done.\n");
	return 0;
}
