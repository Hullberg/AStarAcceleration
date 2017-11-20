#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "fileToMatrix.c"


#define MAX 2500000

// gcc -std=c99 -Wall bfs.c -o bfs

typedef struct Vertex {
  int label;
  bool visited;
  int parent_index;
} Vertex;

// queue variables
int queue[MAX];
int rear = -1;
int front = 0;
// BREAK OUT
int queue_item_count = 0;

// array of vertices
Vertex* lst_vertices[MAX];
int** matrix;
int vertex_count = 0;

//////////////////////
//////////// BREAK OUT
//////////////////////

void add_vertex(int label) {
  Vertex* vertex = (Vertex*) malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parent_index = -1;
  lst_vertices[vertex_count++] = vertex;
}

//////////////////////
////////////// STAY IN
//////////////////////
void display_vertex(int vertex_index) {
  printf("===============\n");
  printf("%d\n", lst_vertices[vertex_index]->label);
  printf("%d\n", lst_vertices[vertex_index]->parent_index);
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
  int i;
	
  for(i = 0; i < vertex_count; i++) {
    if (matrix[vertex_index][i] == 1 && lst_vertices[i]->visited == false)
      return i;
  }
  return -1;
}

// Path from end to start
void get_path(int end){
  int cursor = end;
  while (lst_vertices[cursor]->parent_index != -1) {
    printf("%d\n", cursor);
    cursor = lst_vertices[cursor]->parent_index;
  }
  printf("%d\nDone!\n",cursor);
}

void breadth_first_search(int start, int end) {
  int i;
  int done = false;

  //mark first node as visited
  lst_vertices[start]->visited = true;

  //insert vertex index in queue
  insert(start);

  int unvisited_vertex;
  while(!is_queue_empty() && !done) {
    
    //get the unvisited vertices of the first vertex in the queue
    int temp_vertex = remove_data();   
    
    //no adjacent vertex found
    while((unvisited_vertex = get_unvisited_child(temp_vertex)) != -1 && !done) {    
      lst_vertices[unvisited_vertex]->visited = true;
      lst_vertices[unvisited_vertex]->parent_index = temp_vertex;
      
      if (lst_vertices[unvisited_vertex]->label == end) {
        done = true;
      }
      insert(unvisited_vertex);               
    }		
  }   

  //queue is empty, search is complete, reset the visited flag        
  for(i = 0; i < vertex_count; i++) {
    lst_vertices[i]->visited = false;
  }    
}

int main(int argc, char* argv[]) {
  printf("%s %s \n\n\n\n\n", argv[1], argv[2]);
  if (argc != 3) {
    printf("Please input id file and name file");
  }

  char* name_to_id = argv[1];
  char* id_file = argv[2];
  int start_id, end_id;
  start_id = 1;
  end_id = 3333;
  
  matrix = file_to_matrix(name_to_id, id_file);
  int number_of_lines = file_to_row_count(name_to_id);
  

  for(int i = 0; i < number_of_lines; i++) {
    add_vertex(i); // ID's
  }  

  printf("\nBreadth First Search: \n");

  breadth_first_search(start_id, end_id);
  //printf("DONE");

  get_path(end_id);

  for (int i = 0; i < number_of_lines; i++){
    free(lst_vertices[i]);
    free(matrix[i]);
  }
  free(matrix);
  return 0;
}
