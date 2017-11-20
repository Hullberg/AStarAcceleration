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
// BREAK OUT
int queue_item_count = 0;

// array of vertices
Vertex** vertex_list;//[MAX];
int** matrix;
int vertex_count = 0;

//////////////////////
//////////// BREAK OUT
//////////////////////

void add_vertex(int label) {
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parent_index = -1;
  vertex_list[vertex_count++] = vertex;
}

//////////////////////
////////////// STAY IN
//////////////////////
void display_vertex(int vertex_index) {
  printf("===============\n");
  printf("%d\n", vertex_list[vertex_index]->label);
  printf("%d\n", vertex_list[vertex_index]->parent_index);
  printf("===============\n");
}

bool is_queue_empty() {
  return queue_item_count == 0;
}

void insert(int data) {
  queue[++rear] = data;
  queue_item_count++;
}

int remove_data() {
  queue_item_count--;
  return queue[front++];
}

// Look at vertex
int get_unvisited_child(int vertex_index) {
  int size_child_list = sizeof(vertex_list[vertex_index]->children)/sizeof(int);
  int index;
  for (int i = 0; i < size_child_list; i++) {
    index = vertex_list[vertex_index]->children[i];
    if (vertex_list[index]->visited == false)
      return index;
  }
  /*	
  for(i = 0; i < vertex_count; i++) {
    if (matrix[vertex_index][i] == 1 && vertex_list[i]->visited == false)
      return i;
      }*/
  return -1;
}

// Path from end to start
void get_path(int end){
  printf("Getting path %d\n",end);
  int cursor = end;
  printf("parent index %d",vertex_list[cursor]->parent_index);
  while (vertex_list[cursor]->parent_index != -1) {
     printf("path loop\n");
    printf("%d\n", cursor);
    cursor = vertex_list[cursor]->parent_index;
  }
  printf("%d\nDone!\n",cursor);
}

void breadth_first_search(int start, int end) {
  printf("Test 0:");

  int i;
  int done = false;

  //mark first node as visited
  printf("Test 1:");

  vertex_list[start]->visited = true;
  printf("Test 2:");

  //insert vertex index in queue
  insert(start);
  printf("Test 3:");

  int unvisited_vertex;
  while(!is_queue_empty() && !done) {
    
    //get the unvisited vertices of the first vertex in the queue
    int temp_vertex_index = remove_data();   
    
    //no adjacent vertex found
    while((unvisited_vertex = get_unvisited_child(temp_vertex_index)) != -1 && !done) {    
      vertex_list[unvisited_vertex]->visited = true;
      vertex_list[unvisited_vertex]->parent_index = temp_vertex_index;
      
      if (vertex_list[unvisited_vertex]->label == end) {
        done = true;
      }
      insert(unvisited_vertex);               
    }		
  }   
  printf("Test 4:");

  //queue is empty, search is complete, reset the visited flag        
  for(i = 0; i < vertex_count; i++) {
    vertex_list[i]->visited = false;
  }    
  printf("Test 5:");

}
char* hello_world(){
  char* bajs = "hello world";
  printf("bajsa");
  return bajs;
}

int main(int argc, char* argv[]) {
  printf("\nRunning ... With argv[1] = %s argv[2] = %s \n\n", argv[1], argv[2]);
  if (argc != 3) {
    printf("Please input id file and name file");
  }

  char* name_to_id = argv[1];
  char* id_file = argv[2];
  int start_id, end_id;
  start_id = 1;
  end_id = 6;
  
  //matrix = file_to_matrix(name_to_id, id_file);
  printf("\nDone with file_to_matrix... starting file_to_row\n");
  int number_of_lines = file_to_row_count(name_to_id);
  printf("\nDone with file_to_row_count ... Starting add_vertex with number_of_lines %d\n", number_of_lines);
  
  vertex_list = malloc(sizeof(Vertex**));
  for(int i = 0; i < number_of_lines; i++) {
    add_vertex(i); // ID's
  }  

  // printf("\nRunning file_to_matrix \n");
  printf("\nAdding children to vertices...\n");
  add_vertex_children(vertex_list, id_file);
  
  hello_world();

  printf("\nBreadth First Search: \n");
  breadth_first_search(start_id, end_id);
  printf("\nDONE\n");

  get_path(end_id);
  printf("\n\n\n\n\n\n\n0\n\n\n\n\n\n\n");
  for (int i = 0; i < vertex_count; i++){
    //printf("\n\n\n\n\n\n\n1\n\n\n\n\n\n\n");
    free(vertex_list[i]->children);
    //printf("\n\n\n\n\n\n\n2\n\n\n\n\n\n\n");    
    free(vertex_list[i]);
    //printf("\n\n\n\n\n\n\n3\n\n\n\n\n\n\n");   
    //free(matrix[i]);
  }
  free(vertex_list);
  //free(matrix);
  return 0;
}
