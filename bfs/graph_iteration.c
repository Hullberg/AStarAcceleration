#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#include "vertex.c"

#define EDGE_COUNT 5
#define VERTEX_COUNT 50000

Vertex** vertex_list;

int32_t* edges[EDGE_COUNT]; // [][][][][]
                            // [][][][][]
                            // [][][][][]
                            // [][][][][]
                            // x VERTEX_COUNT
////////////
/////// INIT
////////////

Vertex* create_vertex(){  
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->value = (rand() % (VERTEX_COUNT))+1; // between 1 and 100000
  vertex->edges = malloc(sizeof(int) * EDGE_COUNT);
  for (int i = 0; i < EDGE_COUNT; i++) {
    vertex->edges[i] = rand() % VERTEX_COUNT;
    //printf("i: %d  index: %d\n", i, vertex->edges[i]);
  }
  return vertex;
}

void init_vertices(){
  for (int i = 0; i < VERTEX_COUNT; i++) {
    vertex_list[i] = create_vertex();
  }
}

void update_edges() {
  for (int i = 0; i < VERTEX_COUNT; i++) {
    for (int j = 0; j < EDGE_COUNT; j++) {
      edges[j][i] = vertex_list[vertex_list[i]->edges[j]]->value;
    }
  }
  printf("update end\n");
}

void init_arrays(){
  for (int i = 0; i < EDGE_COUNT; i++){
    edges[i] = malloc(sizeof(int) * VERTEX_COUNT);
  }
  update_edges();
}

////////////////
/////// FUNCTION
////////////////

void magic_function(int index){
  int32_t sum = 0;  
  for (int i = 0; i < EDGE_COUNT; i++) {
    sum += edges[i][index];
  }
  vertex_list[index]->value = sum / EDGE_COUNT;
}

void iterate(){
  for (int i = 0; i < VERTEX_COUNT; i++) {
    //start.stream(blah,blah,blah);
    magic_function(i);
  }
  update_edges();
}

bool is_equal(int32_t a, int32_t b){
  if (a == b) return true;
  else return false;
}

bool converged(){
  int index_one, index_two, value_one, value_two;
  bool is_eq;
  int counter = 0;
  int max = 1000;
  for (int i = 0; i < max; i++) {
    index_one = rand() % (VERTEX_COUNT);
    index_two = rand() % (VERTEX_COUNT);
    value_one = vertex_list[index_one]->value;
    value_two = vertex_list[index_two]->value;
    
    is_eq = is_equal(value_one, value_two);
    if (is_eq) {
      //printf("PASS ---- %d == %d at indices %d and %d\n", value_one, value_two, index_one, index_two);
      counter++;
    } 
    //else printf("FAIL ---- %d != %d indices %d and %d\n", value_one, value_one, index_one, index_two);
  }
  if (counter == max) return true;
  else return false;
}

////////////
/////// MAIN
////////////

/*int main(int argc, char* argv[]) {
  srand(time(NULL));
  vertex_list = malloc(sizeof(Vertex*) * VERTEX_COUNT);

  init_vertices();

  init_arrays();
  
  int count = 0;
  do {
    iterate();
    count++;
  } while(!converged());
  printf("\nDone! Converged after %d iterations.\n", count);
  
  for (int i = 0; i < 10; i++) {
    printf("%d, %d, %d, %d, %d\n", edges[0][i], edges[1][i], edges[2][i], edges[3][i], edges[4][i]);
}

  for (int i = 0; i < VERTEX_COUNT; i++){
    free(vertex_list[i]->edges);
    free(vertex_list[i]);
  }
  for (int i = 0; i < EDGE_COUNT; i++) {
    free(edges[i]);
  }
  free(vertex_list);
  return 0;
}

*/
