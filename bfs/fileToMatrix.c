#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include "vertex.c"
#include <string.h>

typedef struct Array {
  int index;
  struct Array* next;
} Array;

Array* create(int data, Array* next){
    Array* new_array = malloc(sizeof(Array));
    if(new_array == NULL)
    {
        printf("Error creating a new node.\n");
        exit(0);
    }
    new_array->index = data;
    new_array->next = next;
 
    return new_array;
}

Array* prepend(Array* head, int data){
    Array* new_node = create(data,head);
    head = new_node;
    return head;
}

int count_lines(char* filename){
  int lines = 0;
  char* line = NULL;
  size_t len = 0;
  ssize_t read;

  FILE* fp = fopen(filename, "r");
  while ((read = getline(&line, &len, fp)) != -1) {
    lines++;
  }
  fclose(fp);
  free(line);
  return lines;
}

Vertex* create_new_vertex(int label) {
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parent_index = -1;
  vertex->children = NULL;
  return vertex;
}

void add_vertex_from_line(char* line, Vertex** vertex_list, int vertex_index) {
  const char space[2] = " ";
  char* label = strtok(line, space);
  char* child_substring = strtok(NULL, space);

  Vertex* new_vertex = create_new_vertex(atoi(label));
  Array* array = create(atoi(child_substring), NULL);
  Array* head = array;
 
  for(int i = 0; child_substring != NULL; i++) {
    child_substring = strtok(NULL, space);
    if(child_substring) {
      array = prepend(array, atoi(child_substring));
    }
  }
  int count = 1;
  head = array;
  while(array->next != NULL) {
    count++;
    array = array->next;
  }
  array = head;
  //printf("Count: %d\n", count);
  new_vertex->children_size = count;
  new_vertex->children = malloc(sizeof(int) * count);
  //printf("Sizeof: %d\n",sizeof(new_vertex->children));
  for(int i = 0; i < count; i++) {
    new_vertex->children[i] = array->index;
    Array* temp_free = array;
    array = array->next;
    free(temp_free);
  }
  vertex_list[vertex_index] = new_vertex;
}


void add_vertices(char* filename, Vertex** vertex_list){//, int* vertex_count) {
  char* line = NULL;
  size_t len = 0;
  ssize_t read;
  
  FILE* fp = fopen(filename, "r");
  int vertex_index = 0;
  while ((read = getline(&line, &len, fp)) != -1) {
    add_vertex_from_line(line, vertex_list, vertex_index);
    vertex_index++;
  }
  free(line);
  fclose(fp);
}
