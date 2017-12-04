#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#include "Maxfiles.h"
#include "MaxSLiCInterface.h"
#include "../../bfs/bfs.c"


int main(void)
{
	/*int vertex_count = 0;
	char* id_file = "../../data/wiki/wiki_id_links.txt";
	// Get the vertices
	int sizev = sizeof(Vertex*) * number_of_lines;
	int32_t number_of_lines = count_lines(id_file);
	Vertex** vertex_list = malloc(sizev);
	add_vertices(id_file, vertex_list, &vertex_count);
	int sizei = sizeof(int32_t);
	int32_t start_id = 0;
	int32_t end_id = 5; // This should be goal ID.
	int32_t total_steps;
	int32_t* output;*/


	int32_t* vertices; // #children for each vertex
	int32_t* edges; // index number of vertex
	int32_t* data_r; // some number, value of vertex
	int32_t* data_w; // to update data array
	int32_t* edge_counter; // so we know how to offset the edge-array

	int32_t vertex_size; // we get from the CPU team the number of vertices
	int32_t edge_amount; // we get from the CPU team the number of edges



	// Multiple of 384 bytes due to array size (64) burst-aligned
	

	// We send the vertex-list to LMem, and send start and end ID to stream and receive path in output.

	// The manager gets them in EngineCode/src/memstream/MemStreamManager.maxj
	// Write all vertices to LMem.
	printf("Writing all vertices to LMem.\n");
	// address, size, object
	int32_t edge_size = edge_amount * sizeof(int32_t);
	MemStream_writeLMem(0, edge_size, edges);


	printf("Sending info to DFE.\n");	
	//MemStream(endID, size, y, u, s);
	// size here is amount of vertices
	MemStream(vertex_size, vertices, data_r, data_w, edge_counter);
	
	for (int i = 0; i < total_steps; i++) {
		printf("%i", path[i]);
	}

	free(vertex_list);
	printf("Done.\n");
	return 0;
}
