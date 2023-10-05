#!/bin/bash

wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fcomplex-formation-batch-01%2F&include_conf=1&protocol=1' -O complex-formation-batch-01.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fcomplex-formation-batch-02%2F&include_conf=1&protocol=1' -O complex-formation-batch-02.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fgenetic-interaction-dbs-abstracts-01%2F&include_conf=1&protocol=1' -O genetic-interaction-dbs-abstracts-01.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fphysical-interaction-dbs-abstracts-01%2F&include_conf=1&protocol=1' -O physical-interaction-dbs-abstracts-01.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fphysical-interaction-dbs-abstracts-02%2F&include_conf=1&protocol=1' -O physical-interaction-dbs-abstracts-02.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fphysical-interaction-dbs-full-texts-01%2F&include_conf=1&protocol=1' -O physical-interaction-dbs-full-texts-01.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fphysical-interaction-dbs-full-texts-02%2F&include_conf=1&protocol=1' -O physical-interaction-dbs-full-texts-02.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fregulatory-interactions-reactome-abstracts-01%2F&include_conf=1&protocol=1' -O regulatory-interactions-reactome-abstracts-01.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fexhaustive-ptm-corpus-for-re%2F&include_conf=1&protocol=1' -O  exhaustive-ptm-corpus-for-re.tar.gz
wget 'http://ann.turkunlp.org:8088/ajax.cgi?action=downloadCollection&collection=%2Fstring-relation-corpus%2Fptm-triaged-abstracts-01%2F&include_conf=1&protocol=1' -O  ptm-triaged-abstracts-01.tar.gz

# #generate the train-dev-test split lists to put files in the proper directories later
# awk -F"\t" '{if($3==1){printf("%s\t%s\n",$1, $2) >> "CoNECo_train-ids-with-dirs.txt"}}{if($4==1){printf("%s\t%s\n",$1, $2) >> "CoNECo_dev-ids-with-dirs.txt"}}{if($5==1){printf("%s\t%s\n",$1, $2) >> "CoNECo_test-ids-with-dirs.txt"}}' data_split_CoNECo_dirs.tsv

#untar all directories
for i in *.tar.gz; do 
    tar -xzvf $i
done

rm *.tar.gz

#directory list
values=(
    "complex-formation-batch-01" 
    "complex-formation-batch-02" 
    "genetic-interaction-dbs-abstracts-01" 
    "physical-interaction-dbs-abstracts-01" 
    "physical-interaction-dbs-abstracts-02" 
    "physical-interaction-dbs-full-texts-01" 
    "physical-interaction-dbs-full-texts-02" 
    "regulatory-interactions-reactome-abstracts-01" 
    "ptm-triaged-abstracts-01" 
    "exhaustive-ptm-corpus-for-re"
)



#generate the same but with all entity types for reference

for dir in "${values[@]}"; do
    find "$dir" -type f -name "*.ann" -exec perl -ni -e 'print unless /^#/ or /^R/' {} +
done


#Split the directories in train/dev/test

#put all files in one directory
mkdir all-files-all-nes
for dir in "${values[@]}"; do
    cp ${dir}/* all-files-all-nes/
done

#split in train/dev/test
arr=("train" "dev" "test")
for i in "${arr[@]}"; do
    rsync -a all-files-all-nes --files-from=CoNECo_${i}-ids.txt ${i}-set-all-nes
done

#tar everything in one file

#put files in the proper directories
for i in "${arr[@]}"; do
    mkdir -p splits-all-nes
    cp -r ${i}-set-all-nes splits-all-nes
done

cd splits-all-nes
for i in "${arr[@]}"; do
    tar -czvf ${i}-set-all-nes.tar.gz ${i}-set-all-nes
done

for i in "${arr[@]}"; do
    rm -rf ${i}-set-all-nes
done

cd ..

mkdir -p CoNECo-all-nes
cp -r splits-all-nes *.conf CoNECo-all-nes
tar -czvf CoNECo-corpus-all-nes.tar.gz CoNECo-all-nes
