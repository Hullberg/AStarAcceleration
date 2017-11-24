#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "Maxfiles.h"
#include "MaxSLiCInterface.h"
#include "../../bfs/bfs.c"


int main(void)
{
	int vertex_count = 0;
	char* id_file = "../../data/wiki/wiki_id_links.txt";
	// Get the vertices
	int32_t number_of_lines = count_lines(id_file);
	Vertex** vertex_list = malloc(sizeof(Vertex*) * number_of_lines);
	add_vertices(id_file, vertex_list, &vertex_count);

	int start_id = 0;
	int end_id = 5; // This should be goal ID.

	// Multiple of 384 bytes due to array size (64) burst-aligned
	const int size = 384;
	int sizeBytes = size * sizeof(int32_t);
	// Idea: All variables combined is the whole struct.
	// So we send in a label, a boolean for visited, parent_index, children_size, children*
	//int32_t *x = malloc(sizeBytes); //TODO Change this to Vertex struct, should be ALL vertices.
	//int32_t *y = malloc(sizeBytes);
	//int32_t *s = malloc(sizeBytes);
	//int32_t *u = malloc(sizeBytes);

	Vertex* start_vertex = vertex_list[start_id];
	int visited_vertices_count = 0;
	int32_t *unvisited_queue = malloc(sizeBytes); // The queue from which we pull vertices to send into stream
	unvisited_queue[visited_vertices_count] = start_id;

	// Put this in the loop to iterate over everything, and send each vertex into stream.
	// Make all non-pointers to scalars.
	int vertex_label;// = malloc(sizeBytes);
	int visited;// = malloc(sizeof(int32_t)); // Convert the boolean value to 0 or 1 ?
	int parent_index;// = malloc(sizeBytes);

	int temp = start_vertex->children_size %16;
	printf("%d\n", temp);
	int temp2 = 16-temp;
	printf("%d\n", temp2);
	int testy = temp + temp2;
	printf("%d\n",testy);

	int32_t sixteen_byte_align = start_vertex->children_size % 16;
	if (sixteen_byte_align != 0) {
		sixteen_byte_align = 16 - sixteen_byte_align;
	}
	printf("%d\n", (sixteen_byte_align+start_vertex->children_size)*4%16);
	int32_t children_m = (sixteen_byte_align + start_vertex->children_size)*4;
	int32_t *children = malloc(children_m);
	//printf("Children If: %d \n", sizeof(children));

	int32_t *output = malloc(sizeof(Vertex*));
	printf("initiated the startvertix\n");

	// Loop below here?

	// while ( unvisited_queue is not empty ) do loop
	vertex_label = start_vertex->label;
	if (start_vertex->visited) visited = 1;
	else visited = 0;
	parent_index = start_vertex->parent_index;
	children = start_vertex->children_size;
	//int32_t bajs = children % 16;
	printf("%d \n", output[0]);


	// The manager gets them in EngineCode/src/memstream/MemStreamManager.maxj
	// Write all vertices to LMem.
	//printf("Writing to LMem.\n");
	//MemStream_writeLMem(0, sizeBytes, x);


	printf("Running on DFE.\n");	
	//MemStream(endID, size, y, u, s);
	CPUStream(end_id, size, vertex_label, visited, parent_index, children, output);
	
	// put all of output's pointers into unvisited_queue and repeat.

	// Append output to the queue
	printf("Output: %i", output[0]);


	/*for(int i=0; i<size; ++i){
		// The line below is in kernel:  DFEVar sum = x + y + a;
		// This will be executed for that index when the data is ready
		// Followed by io.output("s", sum, type)
		printf("s=%d, x= %d, y= %d, sc= %d, u = %d  \n", s[i], x[i+1], y[i], scalar, u[i]);
		//if (s[i] != x[i] + y[i] + scalar + u[i])
			//return 1;

	}*/

	// The get_path could be done here in CPU-code once everything is done.
	//free(vertex_list);
	printf("Done.\n");
	return 0;
}
