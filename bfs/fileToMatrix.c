#include <stdlib.h>
#include <stdio.h>

int count_lines(char* filename){
  int ch = 'a';
  int lines = 0;
  FILE *fp = fopen(filename, "r");

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

// The matrix represents edges between the vertices. 0 = no edge, 1 = edge.
int** create_matrix(int lines, char* filename){
  int rows = lines;
  int columns = lines;

  int **matrix = (int **)calloc(rows, sizeof(int*));
  for(int i = 0; i < rows; i++) {
    matrix[i] = (int *)calloc(columns, sizeof(int));
  }

  int first_id =0;
  int second_id =0;

  FILE *fp = fopen(filename, "r");
  while(!feof(fp)){ 
    // Searches for two doubles, changes the first_id and second_id pointers to these points
    // and updates the matrix at that row/column to indicate an edge.
    fscanf(fp," %d %d", &first_id, &second_id);
    matrix[first_id][second_id]=1;
    //printf("%d %d", first_id, second_id); //Prints pairs of ID's with edge between.
  }
  fclose(fp);

  return matrix;
}

int** file_to_matrix(char* row_count_file, char *id_file){
  int lines = count_lines(row_count_file);
  int** matrix= create_matrix(lines, id_file);
  return matrix;
}

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

