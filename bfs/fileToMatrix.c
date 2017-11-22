#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include "vertex.c"
#include <string.h>

typedef struct Array {
  int index;
  struct Array* next;
} Array;

Array* create(int data, Array* next)
{
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

Array* prepend(Array* head, int data)
{
    Array* new_node = create(data,head);
    head = new_node;
    return head;
}


int count_lines(char* filename){
  //int ch = 'a';
  int lines = 0;
  char* line = NULL;
  size_t len = 0;
  ssize_t read;
  
  FILE* fp = fopen(filename, "r");
  /*
  while(!feof(fp)){
    ch = fgetc(fp);
    if(ch == '\n') {
      //printf("\n%d\n", lines);
      lines++;
    }
  }
  */
  while ((read = getline(&line, &len, fp)) != -1) {
    //printf("line %s", line);
    //printf("len %d\n", len);
    //add_vertex_from_line(line, vertex_list, vertex_count);
    lines++;
  }
  //printf("%s  %d \n","OUT OF LOOP: ", lines);
  fclose(fp);

  return lines;
}

int file_to_row_count(char* row_count_file){
  return count_lines(row_count_file);
}

/*
void create_vertex(int label, Vertex** vertex_list, int* vertex_count, int count) {
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parent_index = -1;
  vertex->children = malloc(sizeof(int)*count);
  vertex_list[(*vertex_count)++] = vertex; 
  }*/

Vertex* create_new_vertex(int label) {
  Vertex* vertex = malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parent_index = -1;
  vertex->children = NULL;
  return vertex;
}

void add_vertex_from_line(char* line, Vertex** vertex_list, int* vertex_count ) {
  const char space[2] = " ";
  printf("line %s \n", line);
  char* label = strtok(line, space);
  // printf("1.1\n");
  
  char* child_substring = strtok(NULL, space);
  //printf("first child sub  %s \n", child_substring);

  Vertex* new_vertex = create_new_vertex(atoi(label));
  // printf("3\n");
  Array* array = create(atoi(child_substring), NULL);
  Array* head = array;
 
  for(int i = 0; child_substring != NULL; i++) {
    child_substring = strtok(NULL, space);
    //printf("child sub %s\n", child_substring);
    if(child_substring) {
      array = prepend(array, atoi(child_substring));
    }

    //printf("4\n");
    /*
    if(!(new_vertex->children)) {
      //printf("5\n");

      new_vertex->children = malloc(sizeof(int));
      //printf("6\n");

      new_vertex->children[i] = atoi(child_substring);
      //printf("7\n");

    }
    else {
      
      child_substring = strtok(NULL, space);
      //printf("child sub %s\n", child_substring);
  
      if(child_substring) {
	//printf("9\n"); 
	new_vertex->children = realloc(new_vertex->children, sizeof(int)*i);//sizeof(new_vertex->children)+sizeof(int*));
	//printf("10\n");
	new_vertex->children[i] = atoi(child_substring);
	}
	} */
  }
  int count = 0;
  head = array;
  while(array->next != NULL) {
   
    //printf("count:  %d  array->index: %d\n", count, array->index);
    count++;
    array = array->next;
   
  }
  // printf("count:  %d  array->index: %d\n", count, array->index);
  array = head;

  
  //printf(" count %d array index:  %d\n", count, array->index);
  
  //printf("after printing count\n"); 
  new_vertex->children = malloc(sizeof(int) * count);
  //printf("beofre loop\n"); 
  for(int i = 0; i < count; i++) {
    printf("before %d\n", array->index); 
    new_vertex->children[i] = array->index;
    printf("array->index:  %d \n", array->index); 
    array = array->next;
  }


  //printf("adding new %d \n", *vertex_count);
  //for (int i = 0; i < sizeof(new_vertex->children)/sizeof(new_vertex->children[0]); i++){
  //  printf("i = %d, child = %d\n",i,new_vertex->children[i]);
  //}
  //printf("New_vertex size = %d\n",sizeof(new_vertex));
  vertex_list[(*vertex_count)++] = new_vertex;
  //vertex_list = realloc(vertex_list, sizeof(Vertex*)*(*vertex_count));
  printf("done adding\n");
}


void add_vertices(char* filename, Vertex** vertex_list, int* vertex_count) {
  char* line = NULL;
  size_t len = 0;
  ssize_t read;
  
  FILE* fp = fopen(filename, "r");

  while ((read = getline(&line, &len, fp)) != -1) {
    //printf("line %s", line);
    //printf("len %d\n", len);
    add_vertex_from_line(line, vertex_list, vertex_count);
    
  }
  
  //free(line);
  fclose(fp);
}

/*
void add_vertices(Vertex** vertex_list, int* vertex_count, char* filename) {
  int first_id = 0;
  int prev_first_id = -1;
  int second_id = 0;
  int count = 0;
  //Open two file pointers, fp_global to find unique id:s, fp_local to find all occurences of the id
  FILE* fp_global = fopen(filename, "r");
  FILE* fp_local = fopen(filename, "r");
  fscanf(fp_local,"%d %d", &first_id, &second_id);
  while(!feof(fp_global)){
    //printf("Count before fscanf == %d\n", count);
    printf("First = %d, Second = %d\n", first_id, second_id);
    //printf ("fp_global: %p\n", fp_global);
    //printf ("fp_local: %p\n", fp_local);
    printf("fscanf == %d\n",fscanf(fp_global,"%d %d", &first_id, &second_id));
    //printf("Count after fscanf == %d\n", count);
    if (first_id != prev_first_id && count == 0) {
      
      count = count_children(fp_local, first_id);
      create_vertex(first_id, vertex_list, vertex_count, count);
    }
    printf("Count BEFORE == %d\n", count);
    vertex_list[first_id]->children[--count] = second_id;
    printf("Count AFTER == %d\n", count);
    prev_first_id = first_id;
  }
  fclose(fp_global);
  fclose(fp_local);
}


*/

/*
int count_children(FILE* fp, int parent_index) {
  int count = 1;
  int row_index = parent_index;
  int dummy = 0;
  while(!feof(fp)) {
    fscanf(fp, "%d %d", &row_index, &dummy);
    //printf("%d ",row_index);
    //printf("row index = %d, parent index = %d \n", row_index, parent_index);
    if (row_index != parent_index) {
      //printf("Count = %d and returning...\n",count);
      return count;
    }
    count++;
  }
  return count;
  }*/


/*
void add_vertex_children(Vertex** vertex_list, char* filename) {
  int first_id = 0;
  int prev_first_id = -1;
  int second_id = 0;
  int count = 0;
  
  //Open two file pointers, fp_global to find unique id:s, fp_local to find all occurences of the id
  FILE* fp_global = fopen(filename, "r");
  FILE* fp_local = fopen(filename, "r");
  fscanf(fp_local," %d %d", &first_id, &second_id);
  while(!feof(fp_global)){ 
    fscanf(fp_global," %d %d", &first_id, &second_id);
    //printf("First = %d, Second = %d\n", first_id, second_id);
    //printf("Prev_id = %d...\n",prev_first_id);
    //printf("First_id = %d...\n",first_id);
    if (first_id != prev_first_id && count == 0) {
      count = count_children(fp_local, first_id);
      vertex_list[first_id]->children = malloc(sizeof(int)*count);
      if (!vertex_list[first_id]->children)
	perror("\n\n\n\n\nDin jävla idot\n\n\n\n\n");

      //printf("After malloc...%d \n",count);
    }
    vertex_list[first_id]->children[--count] = second_id;
    //printf("first id = %d\n", first_id);
    //printf("Count = %d...\n",count);
    prev_first_id = first_id;
      //printf("%d %d", first_id, second_id); //Prints pairs of ID's with edge between.
  }
  fclose(fp_global);
  fclose(fp_local);
}



// The matrix represents edges between the vertices. 0 = no edge, 1 = edge.
int** create_matrix(int lines, char* filename){
  int rows = lines;
  int columns = lines;

  int** matrix = (int**)calloc(rows, sizeof(int*));
  for(int i = 0; i < rows; i++) {
    printf("i = %d\n", i);// i = 1790506
    matrix[i] = (int*)calloc(columns, sizeof(int));
  }
  printf("\nLoop Malloc done!");
  
  int first_id =0;
  int second_id =0;

  FILE* fp_global = fopen(filename, "r");
  FILE* fp_local = fp_global;
  while(!feof(fp_)){
    fscanf(fp," %d %d", &first_id, &second_id);
    while()
    matrix[first_id][second_id]=1;
    //printf("%d %d", first_id, second_id); //Prints pairs of ID's with edge between.
  }
  fclose(fp);

  return matrix;
}

int** file_to_matrix(char* row_count_file, char *id_file){
  int lines = count_lines(row_count_file);
//int** matrix= create_matrix(lines, id_file);
  return matrix;
}
*/


/*
  int main(int argc, char *argv[]){
  int lines = countlines("../preprocessing/nameToID.txt");
  int** matrix= createMatrix(lines,"../preprocessing/idfile.txt");
  printf("Number of Lines %d \n", lines);
  printf("value %d \n",matrix[4591][4583]);
  for (int i = 0; i < lines; i++) {
    free(matrix[i]);
  }
  free(matrix);
  return 0;
  }*/

