mkdir ../data/topcats

wget https://snap.stanford.edu/data/wiki-topcats.txt.gz -P ../data/topcats
wget https://snap.stanford.edu/data/wiki-topcats-page-names.txt.gz -P ../data/topcats

gunzip ../data/topcats/wiki-topcats.txt.gz
gunzip ../data/topcats/wiki-topcats-page-names.txt.gz
