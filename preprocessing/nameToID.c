#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int getFileID(char* first_name){
    char name_check[100];
    int name_id = -1;
    char* filename = "nameToID.txt";
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
int main(int argc, char *argv[]){
    char* from_name = "Sweden";
    char* to_name = "The_Simpsons";
    int from_id = getFileID(from_name);
    int to_id = getFileID(to_name);
    printf("value %d  %d \n",from_id,to_id);
     return 0;
}
