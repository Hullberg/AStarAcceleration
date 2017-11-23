#-*- coding: utf-8 -*-
from collections import defaultdict
import time


def read_name_links_file(filename):
	with open(filename) as f:
		name_links = defaultdict(set)
		name_set= set()
		name_id_dict = {}
		id_name_dict = {}
		m_id = 0;
   		for line in f:
   			name_link = line.split()
			from_name = name_link[0]
			to_name = name_link[1]
   			name_links[from_name].add(to_name)
   			name_set.add(from_name)
   			name_set.add(to_name)
   		
   		for name in sorted(name_set):
			name_id_dict[name] = m_id
			id_name_dict[str(m_id)] = name
			if name not in name_links:
				name_links[name].add(name)

			m_id += 1
			
	return name_links, name_id_dict, id_name_dict


def space_to_underscore_dicts(filename):
	with open(filename) as f:
		name_to_id_dict = {}
		id_to_name_dict = {}
		name_set= set()
		id_dict = {}
		prev_word = ""
		id_count = 0
		noname_count =0
		copy_count =0
		for line in f:
			split_arr = line.split()
			merged_name= words_to_join(split_arr,1)
			if(len(merged_name) > 1 ):
				#id_to_name_dict[word_links[0]]= word_links[1]
				if merged_name in name_to_id_dict:
					copy_count +=1
					merged_name += "_copy_" + str(copy_count) 
					#print merged_name  + " merged copy \n"
				name_to_id_dict[merged_name] = split_arr[0]
				id_to_name_dict[split_arr[0]] = merged_name
			else:
				noname_count +=1
				noname_string = "noname_" + str(noname_count) + "_" + split_arr[0]
				name_to_id_dict[noname_string] = split_arr[0]
				id_to_name_dict[split_arr[0]] =noname_string
	#print str(noname_count) + " noname count\n"
	#print str(copy_count) + " copy count\n"
	return name_to_id_dict, id_to_name_dict

def modify_id_links_file(filename):
	id_links, name_id_dict, id_name_dict = read_name_links_file(filename)
	return id_links


def make_id_link_text(name_links,name_id_dict):
	id_links_text = ""
	for from_el in sorted(name_links):
		new_from_id = name_id_dict[from_el]
		id_links_text += str(new_from_id)
		for to_el in sorted(name_links[from_el]):
			new_to_id = name_id_dict[to_el]
			id_links_text += " " + str(new_to_id)
		id_links_text += "\n"
	return id_links_text


def make_id_list_text(length):
	id_list_text = ""
	for i in range(length):
		id_list_text += str(i) + '\n'
	return id_list_text


def name_id_dict_to_text(name_id_dict):
	name_id_text= ""
	id_name_text = ""
	for name in sorted(name_id_dict):
		name_id_text += name + " " + str(name_id_dict[name]) + "\n"
		
	return name_id_text


def id_name_dict_to_text(id_name_dict):
	id_name_text = ""
	for i in range(len(id_name_dict)):
		id_name_text += str(i) + " " + id_name_dict[str(i)] + "\n"
	
	return id_name_text


def write_text_to_file(text_written,name_to_id_filename):
	f = open(name_to_id_filename, 'w')
	f.write(text_written)
	f.close()


def words_to_join(m_array,join_from_index):
	return "_".join(m_array[join_from_index:])


def createMetaFile():
	print("TODO")

def id_links_to_text(id_links,num_of_id):
	text_string =""
	for i in range(num_of_id):
		text_string += str(i)
   		for j in sorted(map(int,list(id_links[str(i)]))):
			   text_string += " " + str(j)
		text_string += "\n"
	return text_string
def preprocess_wiki(wiki_filename, id_links_filename,name_id_filename, id_name_filename,):
	name_links, name_id_dict, id_name_dict = read_name_links_file(wiki_filename)
	id_link_text = make_id_link_text(name_links,name_id_dict)
	name_id_text = name_id_dict_to_text(name_id_dict)
	id_name_text = id_name_dict_to_text(id_name_dict)
	write_text_to_file(name_id_text,name_id_filename)
	write_text_to_file(id_name_text,id_name_filename)
	write_text_to_file(id_link_text,id_links_filename)

def preprocess_google(google_filename,id_links_filename,id_list_filename):
	name_links, name_id_dict, id_name_dict = read_name_links_file(google_filename)
	id_links_text = make_id_link_text(name_links,name_id_dict)
	id_list_text = make_id_list_text(len(name_id_dict))
	write_text_to_file(id_links_text,id_links_filename)
	write_text_to_file(id_list_text,id_list_filename)

def preprocess_topcats(topcats_filename,name_id_filename,id_name_filename,topcats_id_links_raw_file,topcats_id_links_file):
	start_time = time.time()
	name_id_dict,id_name_dict = space_to_underscore_dicts(topcats_filename)
	print("--- space to underscore:  %s seconds ---\n" % (time.time() - start_time))
	start_time = time.time()
	name_id_text = name_id_dict_to_text(name_id_dict)
	print("--- name id dict to text: %s seconds --- \n" % (time.time() - start_time))
	start_time = time.time()
	id_name_text = id_name_dict_to_text(id_name_dict)
	print("--- id name dict to text: %s seconds --- \n" % (time.time() - start_time))
	start_time = time.time()
	id_links = modify_id_links_file(topcats_id_links_raw_file);
	print("--- modify id links: %s seconds --- \n" % (time.time() - start_time))
	start_time = time.time()
	id_links_text = id_links_to_text(id_links,len(id_name_dict));
	print("--- id links to text: %s seconds --- \n" % (time.time() - start_time))
	start_time = time.time()
	write_text_to_file(name_id_text,name_id_filename)
	print("--- write name id to fille t: %s seconds --- \n" % (time.time() - start_time))
	start_time = time.time()
	write_text_to_file(id_name_text,id_name_filename)
	print("--- write id name to file : %s seconds --- \n" % (time.time() - start_time))
	start_time = time.time()
	write_text_to_file(id_links_text,topcats_id_links_file)
	print("--- write id links to file : %s seconds --- \n" % (time.time() - start_time))


if __name__ == "__main__":
	wiki_file = "../data/wiki/wiki_name_links_raw.txt"
	wiki_id_links_file = "../data/wiki/wiki_id_links.txt"
	wiki_name_id_file = "../data/wiki/wiki_name_id.txt"
	wiki_id_name_file = "../data/wiki/wiki_id_name.txt"

	google_file = "../data/google/google_id_links_raw.txt"
	google_id_list_file = "../data/google/google_id_list.txt"
	google_id_links_file = "../data/google/google_id_links.txt"

	topcats_file = "../data/topcats/topcats_id_name_raw.txt"
	topcats_id_links_raw_file ="../data/topcats/topcats_id_links_raw.txt"
	topcats_id_links_file ="../data/topcats/topcats_id_links.txt"
	topcats_name_id_file = "../data/topcats/topcats_name_id.txt"
	topcats_id_name_file = "../data/topcats/topcats_id_name.txt"



	#preprocess_wiki(wiki_file,wiki_id_links_file, wiki_name_id_file,wiki_id_name_file)
	print "Wiki DONE"
	#preprocess_google(google_file,google_id_links_file,google_id_list_file)
	print "Google DONE"
	preprocess_topcats(topcats_file,topcats_name_id_file,topcats_id_name_file,topcats_id_links_raw_file,topcats_id_links_file)
	print "Topcats DONE"
	print(" Preprocessing DONE")
