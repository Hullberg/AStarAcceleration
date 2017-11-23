mkdir ../data/topcats

wget https://snap.stanford.edu/data/wiki-topcats.txt.gz -P ../data/topcats

gunzip ../data/topcats/wiki-topcats.txt.gz

mv ../data/topcats/wiki-topcats.txt ../data/topcats/topcats_id_links_raw.txt