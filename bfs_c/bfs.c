#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "../bfsc/filetomatrix.c"

#define MAX 5000

typedef struct Vertex {
  int label;
  bool visited;
  int* pathParent;
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

void addVertex(char label) {
  Vertex* vertex = (Vertex*) malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;
  vertex->pathParent = NULL;
  lstVertices[vertexCount++] = vertex;
}

/*void addEdge(int start,int end) {
  adjMatrix[start][end] = 1;
  adjMatrix[end][start] = 1;
}*/

//////////////////////
////////////// STAY IN
//////////////////////
void displayVertex(int vertexIndex) {
  printf("%d\n",lstVertices[vertexIndex]->label);
}  

bool isQueueEmpty() {
  return queueItemCount == 0;
}

void insert(int data) {
  //printf("%d\n",data);
  queue[++rear] = data;
  //printf("%d\n",rear);
  //printf("%d\n",queueItemCount);
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

void breadthFirstSearch(int start, int end) {
  int i;
  
  //mark first node as visited
  lstVertices[start]->visited = true;

  //display the vertex
  displayVertex(start);

  //insert vertex index in queue

  insert(start);
  int unvisitedVertex;

  while(!isQueueEmpty()) {
    //get the unvisited vertex of the first vertex in the queue
    int tempVertex = removeData();   
    //displayVertex(tempVertex);

    //no adjacent vertex found
    while((unvisitedVertex = getUnvisitedChild(tempVertex)) != -1) {    
      lstVertices[unvisitedVertex]->visited = true;
      //displayVertex(unvisitedVertex);
      if (lstVertices[unvisitedVertex]->label == end) printf("Found...\n");
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
  char* start = argv[1];
  char* end = argv[2];
  int startID, endID;
  startID = 7;
  endID = 260;

  /*for(i = 0; i<MAX; i++){  // adjacency
    for(j = 0; j<MAX; j++) // matrix to 0
      adjMatrix[i][j] = 0;
  }*/

  matrix = fileToMatrix();
  int numberOfLines = fileToRowCount();

  // fileToMatrix() returns int** matrix, one row for each id, and columns (0 if no edge, 1 if edge) (4500,4500 ish)
  printf("%d\n",numberOfLines);
  for(int i = 0; i < numberOfLines; i++) {
    addVertex(i); // ID's
  }  

  printf("\nBreadth First Search: \n");
  
  breadthFirstSearch(startID,endID);
  
  return 0;
}
