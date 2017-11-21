CC = gcc 
FLAGS = -Wall -ggdb -std=c99 -O0
FILES = bfs.c

run: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs.o
	 ./bfs.o "../preprocessing/nameToID.txt" "../preprocessing/idfile.txt"

run_topcats: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs.o
	./bfs.o "../data/topcats/topcats_name_id.txt" "../data/topcats/topcats_id_links.txt"
run_wiki: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs.o
	./bfs.o "../data/wiki/wiki_name_id.txt" "../data/wiki/wiki_id_links.txt"
run_google: $(FILES)
	$(CC) $(FLAGS) bfs.c -o bfs.o
	./bfs.o "../data/google/google_id_list.txt" "../data/google/small.txt"

run_test: bfs_test.c
	$(CC) $(FLAGS) bfs_test.c -o bfs_test.o
	./bfs_test.o

clean: 
	rm -f *.o *o d *.~ callgrind.out.* *\~


.PHONY: clean
