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
   	#print id_dict
   	print ""
   	print ""
   	makeIdLinkFile(unique_links,id_dict,"idfile.txt")
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
		
def makeIdLinkFile(links,ids,filename):
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

def sortIDs(filename,sorted_filename,id_filename):
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
   	#print id_dict
   	#print ""
   	#print ""'
	print("LINK")
   	makeIdLinkFile(unique_links,id_dict,sorted_filename);
	makeToIDFile(len(id_dict),id_filename)
	#print len(id_dict)
def makeToIDFile(length, id_filename):
	text_written = ""
	for i in range(length):
		text_written += str(i) + '\n'
	print("Writing file")
	f = open(id_filename, 'w')
	f.write(text_written)
	f.close()
	

def makeIdToTextTranslationFile(ids):
	text_written = ""
	filename = "IDToName.txt"
	for text_el in sorted(ids):
		text_written +=  str(ids[text_el])  + " " +  text_el + '\n'
	f = open(filename, 'w')
	f.write(text_written)
	f.close()
def replaceSpaceToUnderScore(filename,id_to_name_filename,name_to_id_filename):
	with open(filename) as f:
		name_to_id_dict = {}
		id_to_name_dict = {}
		word_set= set()
		id_dict = {}
		prev_word = ""
		id_count = 0
   		for line in f:
   			split_arr = line.split()
			word_links = spaceToUnderScore(split_arr)
			if(len(word_links) ==2 ):
				id_to_name_dict[word_links[0]]= word_links[1]
				name_to_id_dict[word_links[1]] = word_links[0]
			
   			
   	makeTranslationFile(id_to_name_dict,id_to_name_filename)
   	makeTranslationFile(name_to_id_dict,name_to_id_filename)

def spaceToUnderScore(m_array):
	return (m_array[0] + " " + "_".join(m_array[1:])).split()
def makeTranslationFile(m_dict,filename):
	text_written = ""
	for m_name in sorted(m_dict):
		text_written += m_name + " " + m_dict[m_name] + "\n"
	f = open(filename, 'w')
	f.write(text_written)
	f.close()

if __name__ == "__main__":
	filename = "../data/links.tsv"
	#preprocessLine(filename)
	#sortIDs("../data/web-google.txt","googleidfile.txt","googleIDs.txt")
	replaceSpaceToUnderScore("../data/topcats/wiki-topcats-names.txt","topcats-IDToName.txt","topcats-NameToID.txt")
	print("DONE")