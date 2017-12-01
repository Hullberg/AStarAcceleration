#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include "fileToMatrix.c"
// gcc -std=c99 -Wall bfs.c -o bfs



Vertex** vertex_list;       // array of vertex pointers
int number_of_vertices = 0; // USED IN fileToMatrix.c, mostly arbitrary at this point but needed

int32_t* vertices;     // Contains ints of how many edges each index has
int32_t* data_r;       // Contains data for the index to read ->[]
int32_t* data_w;       // Contains data for the index to write  []->
int32_t* edge_counter; // Contains number of edges UP TO THE SPECIFC INDEX
int32_t* edges;        // Contains as many edges as can be found in vertices (LARGE)


///////////////////////////////////////
///////////////////////////////////////


void init_arrays(int vertex_count, int* vertex_size, int* edge_size){
  srand(time(NULL));
  int edge_count = 0;
  int edge_index = 0;
  *vertex_size = sizeof(int) * vertex_count;
  vertices = malloc(*vertex_size);
  data_r = malloc(*vertex_size);
  data_w = malloc(*vertex_size);
  edge_counter = malloc(*vertex_size);
  for (int i = 0; i < vertex_count; i++) { 
    //vertices, edges, data
    edge_counter[i] = edge_count;
    edge_count += vertex_list[i]->children_size;
  }
  *edge_size = sizeof(int) * edge_count;
  edges = malloc(*edge_size);
  
  for (int i = 0; i < vertex_count; i++) {
    vertices[i] = vertex_list[i]->children_size;
    data_r[i] = rand();
    for (int j = 0; j < vertex_list[i]->children_size; j++, edge_index++) { 
      edges[edge_index] = vertex_list[i]->children[j];
    }
  }
}


void print_arrays(int vertex_count){
  int edge_index = 0;
  for (int i = 0; i < vertex_count; i++) {
    printf("vertices[%d]: %d\n", i, vertices[i]);
    printf("edge_counter[%i]: %d\n",i,edge_counter[i]);
    printf("data[%d]: %d\n", i, data_r[i]);
    /*for (int j = 0; j < vertices[i]; j++, edge_index++) {
      printf("edges[%d] (corresponding to i = %d): %d\n", edge_index, i, edges[edge_index]);
      }*/
    printf("<===================================>\n");
  }
}

///////////////////////////////////////
///////////////////////////////////////


int main(int argc, char* argv[]) {
  char* id_file = argv[2];
  int vertex_size = 0;
  int edge_size = 0;
  
  // count lines
  int vertex_count = count_lines(id_file);
  
  // make verices OBSOLETE pls replace
  vertex_list = malloc(sizeof(Vertex*) * vertex_count);
  add_vertices(id_file, vertex_list, &number_of_vertices);
  
  
  init_arrays(vertex_count, &vertex_size, &edge_size);

  //////// free vertex struct
  for(int i = 0; i< vertex_count; i++){
    free(vertex_list[i]->children);
    free(vertex_list[i]);
  }
  free(vertex_list);
  ////////

  //////// free rest
  free(vertices);
  free(edges);    
  free(data_r); 
  free(data_w);   
  free(edge_counter);
  return 0;
}
