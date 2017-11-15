#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX 5

typedef struct Vertex {
  int label;
  bool visited;
} Vertex;

// queue variables

int queue[MAX];
int rear = -1;
int front = 0;
// BREAK OUT
int queueItemCount = 0;

// array of vertices
Vertex* lstVertices[MAX];
int adjMatrix[MAX][MAX];
int vertexCount = 0;

//////////////////////
//////////// BREAK OUT
//////////////////////

void addVertex(char label) {
  Vertex* vertex = (Vertex*) malloc(sizeof(Vertex));
  vertex->label = label;  
  vertex->visited = false;     
  lstVertices[vertexCount++] = vertex;
}

void addEdge(int start,int end) {
  adjMatrix[start][end] = 1;
  adjMatrix[end][start] = 1;
}

//////////////////////
////////////// STAY IN
//////////////////////
void displayVertex(int vertexIndex) {
  printf("%c \n",lstVertices[vertexIndex]->label);
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

int getAdjUnvisitedVertex(int vertexIndex) {
  int i;
	
  for(i = 0; i<vertexCount; i++) {
    if(adjMatrix[vertexIndex][i] == 1 && lstVertices[i]->visited == false)
      return i;
  }
  return -1;
}

void breadthFirstSearch() {
  int i;

  //mark first node as visited
  lstVertices[0]->visited = true;

  //display the vertex
  displayVertex(0);   

  //insert vertex index in queue
  insert(0);
  int unvisitedVertex;

  while(!isQueueEmpty()) {
    //get the unvisited vertex of the first vertex in the queue
    int tempVertex = removeData();   

    //no adjacent vertex found
    while((unvisitedVertex = getAdjUnvisitedVertex(tempVertex)) != -1) {    
      lstVertices[unvisitedVertex]->visited = true;
      displayVertex(unvisitedVertex);
      if (lstVertices[unvisitedVertex]->label == 'B') printf("FOUND YOU FUCK");
      insert(unvisitedVertex);               
    }		
  }   

  //queue is empty, search is complete, reset the visited flag        
  for(i = 0;i<vertexCount;i++) {
    lstVertices[i]->visited = false;
  }    
}

int main() {
  int i, j;

  for(i = 0; i<MAX; i++){  // adjacency
    for(j = 0; j<MAX; j++) // matrix to 0
      adjMatrix[i][j] = 0;
  }

  addVertex('S');   // 0
  addVertex('A');   // 1
  addVertex('B');   // 2
  addVertex('C');   // 3
  addVertex('D');   // 4
  
  addEdge(0, 1);    // S - A
  addEdge(0, 2);    // S - B
  addEdge(0, 3);    // S - C
  addEdge(1, 4);    // A - D
  addEdge(2, 4);    // B - D
  addEdge(3, 4);    // C - D
  
  
  printf("\nBreadth First Search: \n");
  
  breadthFirstSearch();
  
  return 0;
}
