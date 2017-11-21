#include <stdlib.h>
#include <stdio.h>
#include "vertex.c"

int count_lines(char* filename){
  int ch = 'a';
  int lines = 0;
  FILE* fp = fopen(filename, "r");

  while(!feof(fp)){
    ch = fgetc(fp);
    if(ch == '\n') {
      //printf("\n%d\n", lines);
      lines++;
    }
  }

  printf("%s  %d \n","OUT OF LOOP: ", lines);
  fclose(fp);

  return lines;
}

int count_children(FILE* fp, int parent_index) {
  int count = 1;
  int row_index = parent_index;
  int dummy = 0;
  while(!feof(fp)) {
    fscanf(fp, " %d %d", &row_index, &dummy);
    //printf("%d ",row_index);
    //printf("row index = %d, parent index = %d \n", row_index, parent_index);
    if (row_index != parent_index) {
      //printf("Count = %d and returning...\n",count);
      return count;
    }
    count++;
  }
  return count;
}

void add_vertex_children(Vertex** vertex_list, char* filename) {
  int first_id = 0;
  int prev_first_id = -1;
  int second_id = 0;
  int count = 0;

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
      //printf("After malloc...%d \n",count);
    }
    vertex_list[first_id]->children[--count] = second_id;
    printf("first id = %d\n", first_id);
    //printf("Count = %d...\n",count);
    prev_first_id = first_id;
      //printf("%d %d", first_id, second_id); //Prints pairs of ID's with edge between.
  }
  fclose(fp_global);
  fclose(fp_local);
}


/*
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
int file_to_row_count(char* row_count_file){
  return count_lines(row_count_file);
}

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

