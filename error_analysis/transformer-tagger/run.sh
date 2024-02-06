#!/bin/sh

# CoNECo test set eval tagger

## Process to generate evaluation results on entire test set

### get the CoNECo corpus and the jensenlab tagger results on CoNECo test set 
wget https://zenodo.org/api/records/10623629/files/CoNECo_corpus.tar.gz
wget https://zenodo.org/api/records/10623629/files/CoNECo_test_Transformer_tagger.tar.gz

tar -xzvf CoNECo_corpus.tar.gz
mkdir transformer-test
tar -xf CoNECo_test_Transformer_tagger.tar.gz -C transformer-test

rm *tar.gz

# because of an issue with the tagger, one needs to run without the paragraph numbers. I have created a directory with the same files, and paragraph numbers removed.
SOURCE_DIR="test"
DEST_DIR="test-no_par_num"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Loop through the files in the source directory
for file in "$SOURCE_DIR"/*.{txt,ann}; do
    # Extract the filename without the path and extension.
    filename=$(basename "$file")
    # Check if the filename matches the "_XX" pattern
    if [[ $filename =~ _([0-9]+)\.(txt|ann)$ ]]; then
        # Use parameter expansion to remove the "_XX" pattern from the filename
        new_filename="${filename%_*}"
        # Add ".txt" or ".ann" to the new filename based on the original file extension
        new_filename="${DEST_DIR}/${new_filename}.${BASH_REMATCH[2]}"
        # Copy the content of the source file to the destination file
        cp "$file" "$new_filename"
        echo "Updated filename and copied content: $file -> $new_filename"
    else
        # If the filename doesn't match the pattern, just copy it without modification
        cp "$file" "$DEST_DIR/$filename"
        echo "Copied unchanged: $file -> $DEST_DIR/$filename"
    fi
done


#generate list of FPs, FNs with docids to go through
python ./evalso.py -d -v test-no_par_num transformer-test --filtertypes OOS --overlap
