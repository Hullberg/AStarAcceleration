#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "fileToMatrix.c"


#define MAX 5000

// gcc -std=c99 -Wall bfs.c -o bfs

typedef struct Vertex {
  int label;
  bool visited;
  int parentIndex;
} Vertex;

// queue variables

int queue[MAX];
int rear = -1;
int front = 0;
// BREAK OUT
int queueItemCount = 0;

// array of vertices
Vertex* lstVertices[MAX];
int** matrix;
//int adjMatrix[MAX][MAX];
int vertexCount = 0;

//////////////////////
//////////// BREAK OUT
//////////////////////

void addVertex(int label) {
  Vertex* vertex = (Vertex*) malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->parentIndex = -1;
  lstVertices[vertexCount++] = vertex;
}

/*
void addEdge(int start,int end) {
  adjMatrix[start][end] = 1;
  adjMatrix[end][start] = 1;
}
*/

//////////////////////
////////////// STAY IN
//////////////////////
void displayVertex(int vertexIndex) {

  printf("===============\n");
  printf("%d\n",lstVertices[vertexIndex]->label);
  printf("%d\n",lstVertices[vertexIndex]->parentIndex);
  printf("===============\n");
}

bool isQueueEmpty() {
  return queueItemCount == 0;
}

void insert(int data) {
  queue[++rear] = data;
  queueItemCount++;
}

int removeData() {
  queueItemCount--;
  return queue[front++];
}

int getUnvisitedChild(int vertexIndex) {
  int i;
	
  for(i = 0; i<vertexCount; i++) {
    if(matrix[vertexIndex][i] == 1 && lstVertices[i]->visited == false)
      return i;
  }
  return -1;
}

void getPath(int end){
  int cursor = end;
  while (lstVertices[cursor]->parentIndex != -1) {
    printf("%d\n",cursor);
    cursor = lstVertices[cursor]->parentIndex;
  }
  printf("%d\nDone!\n",cursor);
}

void breadthFirstSearch(int start, int end) {
  int i;
  int done = false;

  //mark first node as visited
  lstVertices[start]->visited = true;

  //display the vertex
  //displayVertex(start);

  //insert vertex index in queue

  insert(start);
  int unvisitedVertex;
  while(!isQueueEmpty() && !done) {
    //get the unvisited vertices of the first vertex in the queue
    int tempVertex = removeData();   
    
    //no adjacent vertex found
    while((unvisitedVertex = getUnvisitedChild(tempVertex)) != -1 && !done) {    
      lstVertices[unvisitedVertex]->visited = true;
      lstVertices[unvisitedVertex]->parentIndex = tempVertex;
      //displayVertex(unvisitedVertex);
      if (lstVertices[unvisitedVertex]->label == end) {
	done = true;
      }
      insert(unvisitedVertex);               
  
    }		
  }   

  //queue is empty, search is complete, reset the visited flag        
  for(i = 0;i<vertexCount;i++) {
    lstVertices[i]->visited = false;
  }    
}

int main(int argc, char* argv[]) {
  // ./bfs.c startedge endedge
  // argc == 3
  //char* start = argv[1];
  //char* end = argv[2];
  int startID, endID;
  startID = 1;
  endID = 3333;
  /*for(i = 0; i<MAX; i++){  // adjacency
    for(j = 0; j<MAX; j++) // matrix to 0
      adjMatrix[i][j] = 0;
  }*/
  
  matrix = fileToMatrix();
  int numberOfLines = fileToRowCount();
  
//
  // fileToMatrix() returns int** matrix
  // one row for each id, and columns 
  // (0 if no edge, 1 if edge) (4500,4500 ish)
  //  

  for(int i = 0; i < numberOfLines; i++) {
    addVertex(i); // ID's
    //displayVertex(i);
  }  

  printf("\nBreadth First Search: \n");

  breadthFirstSearch(startID,endID);
  //printf("DONE");

  getPath(endID);

  for (int i = 0; i < numberOfLines; i++){
    free(lstVertices[i]);
    free(matrix[i]);
  }
  free(matrix);
  return 0;
}
