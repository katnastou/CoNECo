#!/bin/sh
# Do the counts for corpus statistics

## get the corpus from here: https://jensenlab.org/resources/s1000/
wget https://zenodo.org/api/records/10623629/files/CoNECo_corpus.tar.gz
tar -xzvf CoNECo_corpus.tar.gz
rm CoNECo_corpus.tar.gz

#calculate number of words
python3 brat_txt_stats.py --dir .

#calculate number of entities
for s in {train,dev,test}; do echo $s $(cat ${s}/*.ann | egrep '^T[0-9]+[[:space:]]Complex' | wc -l); done

#count unique instances per directory
for s in {train,dev,test}; do
    cat ${s}/*.ann | egrep '^T[0-9]+[[:space:]]Complex'  | awk -F"\t" '{print $3}' | sort -u | wc -l
done

#count unique names overall
cat train/*.ann dev/*.ann test/*.ann | egrep '^T[0-9]+[[:space:]]Complex'  | awk -F"\t" '{print $3}' | sort -u |wc -l

#count normalizations
for s in {train,dev,test}; do
cat ${s}/*.ann | egrep '^N[0-9]+[[:space:]]Reference[[:space:]]T'|  wc -l;
done

for s in {train,dev,test}; do
    cat ${s}/*.ann | egrep '^N[0-9]+[[:space:]]Reference[[:space:]]T[0-9]+[[:space:]](GO:[0-9]+)' | egrep -o 'GO:[0-9]+' | sort -u |wc -l;
done

cat train/*.ann dev/*.ann test/*.ann |egrep '^N[0-9]+[[:space:]]Reference[[:space:]]T[0-9]+[[:space:]](GO:[0-9]+)' | egrep -o 'GO:[0-9]+' | sort -u |wc -l;
