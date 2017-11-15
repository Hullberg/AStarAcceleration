from collections import defaultdict
#-*- coding: utf-8 -*-
def preprocessLine(filename):
	with open(filename) as f:
		unique_links = defaultdict(set)
		word_set= set()
		id_dict = {}
		prev_word = ""
		id_count = 0
   		for line in f:
   			word_links = line.split()
   			unique_links[word_links[0]].add(word_links[1])
   			word_set.add(word_links[0]);
   			word_set.add(word_links[1]);
   		i = 0;
   		for word in sorted(word_set):
			id_dict[word]= i
			i+=1
   	print id_dict
   	print ""
   	print ""
   	makeIdLinkFile(unique_links,id_dict)
   	makeIdTranslationFile(id_dict)
   	makeIdToTextTranslationFile(id_dict)
	print len(id_dict)

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

def makeIdLinkFile(links,ids):
	
	filename = "idfile.txt"
	text_written = ""
	for from_el in sorted(links):
		from_id = ids[from_el]
		for to_el in sorted(links[from_el]):
			text_written += str(from_id) + " " + str(ids[to_el]) + '\n'
	f = open(filename, 'w')
	f.write(text_written)
	
	f.close()
   		
def makeIdTranslationFile(ids):
	text_written = ""
	max_string = "";
	filename = "nameToID.txt"
	for text_el in sorted(ids):
		text_written += text_el + " " + str(ids[text_el]) + '\n'
		if (len(text_el) > len(max_string)):
				max_string = text_el
	f = open(filename, 'w')
	f.write(text_written)
	print "maximum " + max_string
	f.close()


def makeIdToTextTranslationFile(ids):
	text_written = ""
	filename = "IDToName.txt"
	for text_el in sorted(ids):
		text_written +=  str(ids[text_el])  + " " +  text_el + '\n'
	f = open(filename, 'w')
	f.write(text_written)
	f.close()

if __name__ == "__main__":
	filename = "../data/links.tsv"
	preprocessLine(filename)