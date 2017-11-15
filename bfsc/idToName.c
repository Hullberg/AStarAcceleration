#include <stdlib.h>
#include <stdio.h>
#include <string.h>

char* getFileName(int id_name){
    char name_check[100];
    int id_compare = -1;
    char* filename = "../preprocessing/IDToName.txt";
  FILE *fp = fopen(filename,"r");
   int i =0;
while(!feof(fp)){
    i++;
  fscanf(fp," %d %s",id_compare,name_check);
     if(id_compare == id_name){
         break;
   }
}
fclose(fp);
return name_check;
}
int main(int argc, char *argv[]){
    int from_id = 7;
    int to_id= 8;
    char* from_name = getFileID(from_name);
    char* to_name = getFileID(to_name);
    printf("value %s  %s \n",from_name,to_name);
     return 0;
}