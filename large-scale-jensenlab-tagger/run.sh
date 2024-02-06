#!/bin/sh

# you need to set up tagger first in case you haven't already
# uncomment the next lines to do so
# git clone https://github.com/larsjuhljensen/tagger tagger
# cd tagger
# make
# cd ..

#the dictionary files and the corpus can be downloaded from https://jensenlab.org/resources/S1000
wget https://zenodo.org/api/records/10623629/files/tagger_dictionary_complex.tar.gz
wget https://a3s.fi/Jan-2024-documents/PubMed_2024_Jan.tar.gz
wget https://a3s.fi/Jan-2024-documents/PMC_Nov_23.tar.gz
tar -xzvf tagger_dictionary_complex.tar.gz
tar -xzvf PubMed_2024_Jan.tar.gz
tar -xzvf PMC_Nov_23.tar.gz

rm *tar.gz

gzip -cd `ls -1 pmc/*.en.merged.filtered.tsv.gz` `ls -1r pubmed/*.tsv.gz` | \
	cat excluded_documents.txt - \
	| tagger/tagcorpus --threads=40 \
	--types=go_types.tsv \
	--entities=all_entities-complex.tsv \
	--names=all_names-complex.tsv \
	--groups=all_groups-complex.tsv \
	--stopwords=all_global_bl.tsv \
	--local-stopwords=all_local.tsv \
	--out-matches=large_scale_jensen_matches.tsv \
	--out-segments=large_scale_jensen_segments.tsv 

