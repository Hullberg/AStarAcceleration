#define _GNU_SOURCE

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "fileToMatrix.c"
#define MAX 10000000
#define DEBUG 0
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

int get_name_to_id(char* file_name, char* first_name){
  char name_check[100];
  int name_id = -1;
  char* filename = file_name;
  FILE *fp = fopen(filename,"r");
  int i =0;
  while(!feof(fp) || name_id == -1){
    i++;
    fscanf(fp," %s %d",name_check,&name_id);
    if(strcmp(first_name,name_check) == 0){
      break;
    }
  }
  fclose(fp);
  return name_id;
}


char* get_id_to_name(char* file_name, int id_name){
  char * name_check = malloc(sizeof(char)*100);
  int id_compare = -1;
  char* filename = file_name;
  FILE *fp = fopen(filename,"r");
  int i =0;
  while(!feof(fp)){
    i++;
    fscanf(fp," %d %s",&id_compare,name_check);
    if(id_compare == id_name){
      return name_check;
    }
  }
  return "";
}

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

// Look at vertex
int get_unvisited_child(int vertex_index, int* child_index) {
  int index;
  for (int i = *child_index; i < vertex_list[vertex_index]->children_size; i++) {
    //printf("vertex_index: %d\n",vertex_index);
    //printf("children[%d]: %d\n",i,vertex_list[vertex_index]->children[i]);
    //printf("children_size: %d\n",vertex_list[vertex_index]->children_size);
    index = vertex_list[vertex_index]->children[i];
    //printf("AFTER indexing: index = %d\n", index);
    //printf("visited == %d\n",vertex_list[index]->visited);
    if (vertex_list[index]->visited == false){
      //printf("WILL return index %d\n",index);
      *child_index = i;
      return index;
    }
    //printf("AFTER return IF statement\n");
  }
  return -1;
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
  int finished_index = -1;
  int unvisited_vertex;
  int temp_vertex_index;
  int child_index;
  while(!is_queue_empty() && !done) {
    //get the unvisited vertices of the first vertex in the queue
    temp_vertex_index = remove_data();
    child_index = 0;
    //printf("Visited node: %d\n", temp_vertex_index);
    //no adjacent vertex found
    while((unvisited_vertex = get_unvisited_child(temp_vertex_index, &child_index)) != -1 && !done) {
      //printf("after get_unvisited_child\n");
      vertex_list[unvisited_vertex]->visited = true;
      vertex_list[unvisited_vertex]->parent_index = temp_vertex_index;
      //printf("Before insert\n");
      insert(unvisited_vertex);  
      //printf("After insert\n");
      if (vertex_list[unvisited_vertex]->label == end) {
	finished_index = unvisited_vertex;
        done = true;
      }          
    }		
  }   
  if (finished_index == -1) {
    printf("Unable to reach end.\n");
    exit(1);
  }
  //queue is empty, search is complete, reset the visited flag        
  for(i = 0; i < vertex_count; i++) {
    vertex_list[i]->visited = false;
  }    

}

int main(int argc, char* argv[]) {
 
  
 
  char* id_file = argv[2];
  int start_id, end_id;
  if(argc == 3){
    start_id = 1;
    end_id = 46;
  }
  else if(argc == 5){
    start_id = atoi(argv[3]);
    end_id = atoi(argv[4]);
  }
  else{
    printf("Arguments not correct");
  }
 

 
 
  int number_of_lines = count_lines(id_file);

  if (start_id >= number_of_lines || end_id >= number_of_lines) {
    printf("Too large index.\n");
    exit(1);
  }
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
