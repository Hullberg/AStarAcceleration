#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

#include "vertex.c"

#define EDGE_COUNT 4
#define VERTEX_COUNT  2048 * 10000	

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

double iterate(){
  clock_t start_simulation_time = clock();
  for (int i = 0; i < VERTEX_COUNT; i++) {
    //start.stream(blah,blah,blah);
    magic_function(i);
  }
  clock_t end_simulation_time = clock();
  double total_time = (double)end_simulation_time-start_simulation_time;
  update_edges();
  return total_time;
	
	
}

bool is_equal(int32_t a, int32_t b){
  if (a == b) return true;
  else return false;
}

bool converged(){
  int index_one, index_two, value_one, value_two;
  bool is_eq;
  int counter = 0;
  int max = VERTEX_COUNT/1000;
  for (int i = 0; i < max; i++) {
    index_one = rand() % (VERTEX_COUNT);
    index_two = rand() % (VERTEX_COUNT);
    value_one = vertex_list[index_one]->value;
    value_two = vertex_list[index_two]->value;
    
    is_eq = is_equal(value_one, value_two);
    if (!is_eq) {
	printf("FAIL in random ---- %d != %d indices %d and %d\n", value_one, value_two, index_one, index_two);
      
      return false;
    }
	counter++; 
    
  }
  if (counter == max){
	int first_val = vertex_list[0]->value;
	for (int i =1; i <VERTEX_COUNT; i++){
		if (!is_equal(first_val, vertex_list[i]->value)){
			printf("FAIL in loop ---- %d", i);
			return false;
		}
	
	}
	return true;
  }
  else return false;
}

////////////
/////// MAIN
////////////

int main(int argc, char* argv[]) {
  clock_t start_simulation_time = clock();
  srand(time(NULL));
  vertex_list = malloc(sizeof(Vertex*) * VERTEX_COUNT);
  double tot_time =0;

  init_vertices();

  init_arrays();

  int iteration_count = 100;

  int count = 0;
  do {
    tot_time +=iterate();
    count++;
  } while(count < iteration_count);
  double average_time = tot_time/(double)count;
  printf("\nDone! Converged after %d iterations.\n", count);
  printf("Average time in C: %f \n",average_time/CLOCKS_PER_SEC);
  
  for (int i = 0; i < 10; i++) {
    //printf("%d, %d, %d, %d, %d\n", edges[0][i], edges[1][i], edges[2][i], edges[3][i], [i]);
}

  for (int i = 0; i < VERTEX_COUNT; i++){
    free(vertex_list[i]->edges);
    free(vertex_list[i]);
  }
  for (int i = 0; i < EDGE_COUNT; i++) {
    free(edges[i]);
  }
  free(vertex_list);
  clock_t end_simulation_time = clock();
  printf("Graph iteration Total time: %f s\n", ((double)end_simulation_time-start_simulation_time)/CLOCKS_PER_SEC);
  return 0;
}


