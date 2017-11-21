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

// array of vertices
Vertex** vertex_list;//[MAX];
int** matrix;
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

void display_vertex() {
  for(int i = 0; i < vertex_count; i++){
    int size_child_list = sizeof(vertex_list[i]->children)/sizeof(int);
    printf("===============\n");
    printf("%d\n", vertex_list[i]->label);
    for(int j = 0; j < size_child_list; j++){
      printf("%d %d\n",vertex_list[i]->label, vertex_list[i]->children[j]); 
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

int main(int argc, char* argv[]) {
  if (argc != 3) {
    printf("Please input id file and name file");
  }

 
  char* id_file = argv[2];
  int start_id, end_id;
  start_id = 10;
  end_id = 90;
  
 
  
  vertex_list = malloc(sizeof(Vertex**));
  printf("\n\n\ndfawAWDADGSEGEGEdawdawwdaw\n\n");
  add_vertices(id_file,vertex_list, &vertex_count);
  printf("\n\n\ndfawdawdawwdaw\n\n");
  //display_vertex();
  printf("\nBreadth First Search: \n");
  breadth_first_search(start_id, end_id);
  printf("\nDONE\n");

  get_path(end_id);
  printf("\n\nVERTEX COUNT = %d\n\n", vertex_count );
  for (int i = 0; i < vertex_count; i++){
 
  }
  
  return 0;
}
