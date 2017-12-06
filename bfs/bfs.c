#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "fileToMatrix.c"
#define MAX 2500000

// gcc -std=c99 -Wall bfs.c -o bfs

// queue variables
int queue[MAX];
int rear = -1;
int front = 0;
int queue_item_count = 0;

// array of vertex pointers
Vertex** vertex_list;//[MAX];
//int** matrix;
int vertex_count = 0;
/*
  void add_vertex(int label) {
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parent_index = -1;
  vertex_list[vertex_count++] = vertex;
  }
*/
void display_index(int index) {
  printf("%d\n",vertex_list[index]->label); 
  for(int j = 0; j < vertex_list[index]->children_size; j++){
    printf("            %d\n",vertex_list[index]->children[j]); 
  }
// gcc -std=c99 -Wall bfs.c -o bfs



Vertex** vertex_list;              // array of vertex pointers
//int number_of_vertices = 0;      // Used as indexing in vertex_list

// vertex number = index in the four arrays below

int32_t* edge_count;               // Contains ints of how many edges each index has
int32_t* edge_start_indices;       // Contains number of edges UP TO THE SPECIFC INDEX

int32_t* data_r;                   // Contains data for the index to read ->[]
int32_t* data_w;                   // Contains data for the index to write  []->

int32_t* edge_array;               // Contains as many edges as can be found in edge_count (LARGE)


///////////////////////////////////////
///////////////////////////////////////


void init_arrays(int vertex_count, int* vertex_size){
  srand(time(NULL));
  int edge_counter = 0;
  int edge_index = 0;
  int edge_array_size = 0;

  *vertex_size = sizeof(int) * vertex_count;
  edge_count = malloc(*vertex_size);
  data_r = malloc(*vertex_size);
  data_w = malloc(*vertex_size);
  edge_start_indices = malloc(*vertex_size);
  for (int i = 0; i < vertex_count; i++) { 
    //edge_counter, edges, data
    edge_start_indices[i] = edge_counter;
    edge_counter += vertex_list[i]->children_size;
  }
  edge_array_size = sizeof(int) * edge_counter;
  edge_array = malloc(edge_array_size);
  
  for (int i = 0; i < vertex_count; i++) {
    edge_count[i] = vertex_list[i]->children_size;
    data_r[i] = rand() % 100001; // between 1 and 100000
    for (int j = 0; j < vertex_list[i]->children_size; j++, edge_index++) { 
      edge_array[edge_index] = vertex_list[i]->children[j];
    }
  }
}

void print_arrays(int vertex_count){
  int edge_index = 0;
  for (int i = 0; i < vertex_count; i++) {
    printf("edge_count[%d]: %d\n", i, edge_count[i]);
    printf("edge_start_indices[%i]: %d\n", i, edge_start_indices[i]);
    printf("data[%d]: %d\n", i, data_r[i]);
    for (int j = 0; j < edge_count[i]; j++, edge_index++) {
      printf("edge_array[%d] (corresponding to i = %d): %d\n", edge_index, i, edge_array[edge_index]);
    }
    printf("<===================================>\n");
  }
  
}

void magic_function(int index){
  int edges = edge_count[index];
  int edge_start_index = edge_start_indices[index];

  int32_t average = 0;
  int32_t sum = 0;
  for (int i = edge_start_index; i < (edge_start_index + edges); i++){
    sum += data_r[edge_array[i]];
  }
  average = sum / edges;
  data_w[index] = average;
}

void replace_read_array(int** read, int** write){
  int32_t* tmp = *read;
  *read = *write;
  *write = tmp;
}

void iterator(int vertex_count){
  for (int i = 0; i < vertex_count; i++){
    magic_function(i);
  }
  replace_read_array(&data_r, &data_w);
}

// Look at vertex
int get_unvisited_child(int vertex_index) {
  int index;
  for (int i = 0; i < vertex_list[vertex_index]->children_size; i++) {
    index = vertex_list[vertex_index]->children[i];
    if (vertex_list[index]->visited == false)
      return index;
  }
  return -1;
}

// Path from end to start
void get_path(int end){
  printf("Getting path %d\n", end);
  int cursor = end;
  int steps = 0;
  //printf("parent index %d",vertex_list[cursor]->parent_index);
  while (vertex_list[cursor]->parent_index != -1) {
    display_index(cursor);
    steps++;
    cursor = vertex_list[cursor]->parent_index;
  }
  printf("%d\nDone! It took %d steps.\n",cursor,steps);
}

void breadth_first_search(int start, int end) {
  printf("Start: %d --- End: %d\n", start, end);
  int i;
  int done = false;
  if (start == end) return;
  //mark first node as visited

  vertex_list[start]->visited = true;

  //insert vertex index in queue
  insert(start);

  int unvisited_vertex;

  while(!is_queue_empty() && !done) {
    //get the unvisited vertices of the first vertex in the queue
    int temp_vertex_index = remove_data();
    //no adjacent vertex found
    while((unvisited_vertex = get_unvisited_child(temp_vertex_index)) != -1 && !done) {    
      vertex_list[unvisited_vertex]->visited = true;
      vertex_list[unvisited_vertex]->parent_index = temp_vertex_index;
      insert(unvisited_vertex);  
      if (vertex_list[unvisited_vertex]->label == end) {
        done = true;
      }          
    }		
  }   

  //queue is empty, search is complete, reset the visited flag        
  for(i = 0; i < vertex_count; i++) {
    vertex_list[i]->visited = false;
  }    
bool check_pass_fail(int32_t a, int32_t b){
  if (a==b) return true;//(a % b <= 1 || b % a <= 1) return true;
  return false;
}

bool has_converged(int vertex_count){
  srand(time(NULL));
  int index_one, index_two;
  bool pass;
  int counter = 0;
  int max = 500;
  for (int i = 0; i < max; i++){
    index_one = rand() % (vertex_count + 1);
    index_two = rand() % (vertex_count + 1);
    //pass = check_pass_fail(data_r[index], data_w[index]);
    pass = check_pass_fail(data_r[index_one], data_r[index_two]);
    if (pass) {
      //printf("PASS ---- %d ~= %d\n", data_r[index_one], data_r[index_two]);
      counter++;
    }
    //else printf("FAIL ---- %d != %d \n", index_one, index_two);
  }
  if (counter == max) return true;
  else return false;
}

///////////////////////////////////////
///////////////////////////////////////


/*int main(int argc, char* argv[]) {
  if (argc != 3) {
    printf("Please input id file and name file");
  }

 
  char* id_file = argv[2];
  int start_id, end_id;
  start_id = 555;
  end_id = 555;
  
 
  int number_of_lines = count_lines(id_file);
  vertex_list = malloc(sizeof(Vertex*) * number_of_lines);
  add_vertices(id_file, vertex_list, &vertex_count);
  //printf("Size of Children_size: %d\n",sizeof(vertex_list[0]->children_size));
  //display_vertex();
  //printf("\nBreadth First Search: \n");
  breadth_first_search(start_id, end_id);
  //printf("\nDONE\n");

  get_path(end_id);

  //display_index(start_id);
  //printf("\n\nVERTEX COUNT = %d\n\n", vertex_count );
  for(int i = 0; i< number_of_lines; i++){
    //int children_size = vertex_list[i]->children_size; 
    //free(&(vertex_list[i]->children));
=======
int main(int argc, char* argv[]) {
  char* id_file = argv[2];
  int vertex_size = 0;
  //int edge_size = 0;
  
  // count lines
  int vertex_count = count_lines(id_file);
  
  // is difficult to fix
  vertex_list = malloc(sizeof(Vertex*) * vertex_count);
  add_vertices(id_file, vertex_list);//, &number_of_vertices);
  
  init_arrays(vertex_count, &vertex_size);

  //////// free vertex struct
  for(int i = 0; i< vertex_count; i++){
>>>>>>> origin/path_change
    free(vertex_list[i]->children);
    free(vertex_list[i]);
  }
  free(vertex_list);
  ////////

  //print_arrays(vertex_count);
  int count = 0;
  do {
    iterator(vertex_count);
    //printf("\n");
    count++;
  } while(!has_converged(vertex_count));
  printf("\nDone! Converged after %d iterations.\n", count);

  //print_arrays(vertex_count);
  //////// free rest
  free(edge_count);
  free(edge_array);    
  free(data_r); 
  free(data_w);   
  free(edge_start_indices);
  return 0;
}
*/
