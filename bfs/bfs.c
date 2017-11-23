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

  printf("===============\n");
  
}

void display_vertex() {
  for(int i = 0; i < vertex_count; i++){
    printf("%d\n",vertex_list[i]->label); 
    for(int j = 0; j < vertex_list[i]->children_size; j++){
      printf("            %d\n",vertex_list[i]->children[j]); 
    }

    printf("===============\n");
  }
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

}

int main(int argc, char* argv[]) {
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
    free(vertex_list[i]->children);
    free(vertex_list[i]);
  }
  free(vertex_list);
  return 0;
}
