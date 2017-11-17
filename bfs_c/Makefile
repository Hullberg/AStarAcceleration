CC = gcc 
FLAGS = -Wall -ggdb -std=c99
FILES = bfs.c
run: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs
	./bfs "../preprocessing/nameToID.txt" "../preprocessing/idfile.txt"

run_topcats: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs
	./bfs "../data/topcats/topcats-NameToID.txt" "../data/topcats/wiki-topcats.txt"

clean: 
	rm -f *.o *o d *.~ callgrind.out.* *\~


.PHONY: clean
