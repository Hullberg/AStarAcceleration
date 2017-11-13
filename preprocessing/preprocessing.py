from collections import defaultdict
#-*- coding: utf-8 -*-
def preprocessLine(filename):
	with open(filename) as f:
		unique_links = defaultdict(set)
		first_word = set()
		second_word = set()
		id_dict = {}
		prev_word = ""
		id_count = 0
   		for line in f:
   			word_links = line.split()
   			unique_links[word_links[0]].add(word_links[1])
   			first_word.add(word_links[0]);
   			second_word.add(word_links[1]);
   		i = 1;
   		for word in sorted(first_word):
   			if word  not in id_dict:
   				id_dict[word]= i
   				i+=1
   		for word in sorted(second_word):
   			if word  not in id_dict:
   				id_dict[word]= i
   	print id_dict
   	print ""
   	print ""
   	for el in sorted(unique_links):
   		print el, unique_links[el]
   		print id_dict[el]
   		break;

def textInFile(filename):
	textfile = open(filename,'r')
	return textfile.read()
def textToLowerList(text):
	return text.split()

def uniqueLinks(m_list):
	m_dict ={};
	m_id =0;
	for el in m_list:
		if el  not in m_dict:
			m_id +=1
			m_dict[el] = m_id
	return m_dict 
def preprocess(filename):
	m_dict = uniqueLinks(textToLowerList(textInFile(filename)))
	for key in sorted(m_dict):
		print(key,m_dict[key])





if __name__ == "__main__":
	filename = "../data/links.tsv"
	preprocessLine(filename)