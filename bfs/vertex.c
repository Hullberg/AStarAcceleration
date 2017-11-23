#include <stdbool.h>

typedef struct Vertex {
  int label;
  bool visited;
  int parent_index;
  int children_size;
  int* children;
} Vertex;
