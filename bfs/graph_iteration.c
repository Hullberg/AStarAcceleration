#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#include "vertex.c"

#define EDGE_COUNT 5
#define VERTEX_COUNT 1000

Vertex** vertex_list;

int32_t* edges[EDGE_COUNT];
/*
int32_t* edge_0;
int32_t* edge_1;
int32_t* edge_2;
int32_t* edge_3;
int32_t* edge_4;
*/
////////////
/////// INIT
////////////

Vertex* create_vertex(){
 
  
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->value = rand() % 100001; // between 1 and 100000
  vertex->edges = malloc(sizeof(int) * EDGE_COUNT);
  for (int i = 0; i < EDGE_COUNT; i++) {
    vertex->edges[i] = rand() % VERTEX_COUNT;
    printf("i: %d  index: %d\n", i, vertex->edges[i]);
  }
  return vertex;
}

void init_vertices(){
 
  for (int i = 0; i < VERTEX_COUNT; i++) {
    vertex_list[i] = create_vertex();
  }
}

void init_arrays(){

  for (int i = 0; i < EDGE_COUNT; i++){
    edges[i] = malloc(sizeof(int) * VERTEX_COUNT);
  }
  for (int i = 0; i < VERTEX_COUNT; i++) {
    for (int j = 0; j < EDGE_COUNT; j++) {
      edges[j][i] = vertex_list[vertex_list[i]->edges[j]]->value;
    }
  }
}

////////////////
/////// FUNCTION
////////////////

void magic_function(){

}

void iterator(){

}

void replace_read_array(){

}

void check_pass_fail(){

}

bool converged(){
  return false;
}

////////////
/////// MAIN
////////////

int main(int argc, char* argv[]) {
  srand(time(NULL));
  vertex_list = malloc(sizeof(Vertex*) * VERTEX_COUNT);

  init_vertices();

  init_arrays();

  for (int i = 0; i < VERTEX_COUNT; i++) {
    printf("i: %d    edges0: %d    edges1: %d    edges2: %d    edges3: %d    edges4: %d\n",
	   i, edges[0][i], edges[1][i], edges[2][i], edges[3][i], edges[4][i]);
  }

  return 0;
}
