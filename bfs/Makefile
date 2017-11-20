CC = gcc 
FLAGS = -Wall -ggdb -std=c99
FILES = bfs.c

run: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs.o
	./bfs.o "../preprocessing/nameToID.txt" "../preprocessing/idfile.txt"

run_topcats: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs.o
	./bfs.o "../data/topcats/topcats-NameToID.txt" "../data/topcats/wiki-topcats.txt"

run_test: bfs_test.c
	$(CC) $(FLAGS) bfs_test.c -o bfs_test.o
	./bfs_test.o

clean: 
	rm -f *.o *o d *.~ callgrind.out.* *\~


.PHONY: clean
