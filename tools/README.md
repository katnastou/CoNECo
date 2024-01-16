## Miscellaneous tools

### `query_pubmed.py`

The script `query_pubmed.py` queries PubMed for exact hits for each
line in a given file. Example:

```
$ echo -e 'p53\nNF-kB' > names.txt
$ python3 query_pubmed.py names.txt
p53	106443
NF-kB	7593
```

### `generate.py`

The script `generate.py` takes a file with a protein complex name on
each line and for each name prompts a generative model to produce text
in the style of a scientific article that mentions that name but not
other protein complex (or related) names. Example:

```
$ echo 'NF-kB' > names.txt
$ python3 generate.py names.txt
$ cat output-gpt-3.5-turbo-1106-0.txt
model: gpt-3.5-turbo-1106
prompt: Write a paragraph of text in the style of a biomedical research article. Include the following protein complex name: NF-kB. Use this name exactly as provided, avoiding any synonyms, aliases, abbreviated or expanded forms. Also avoid including any other names referring to a gene, protein, protein complex, protein part or component, or any other molecular entity containing amino acid residues. The text can include mentions of other biomedical entity types, such as chemical, organism, and disease names.
output: Activation of the NF-kB protein complex is implicated in the pathogenesis of various inflammatory disorders and cancer. Dysregulated NF-kB signaling has been linked to the development and progression of rheumatoid arthritis, inflammatory bowel disease, and multiple myeloma. Furthermore, aberrant NF-kB activity has been associated with resistance to chemotherapy and targeted therapy in various malignancies. Given its central role in these pathological processes, targeting NF-kB has emerged as a promising therapeutic strategy. Small molecule inhibitors of NF-kB have shown potential in preclinical studies and clinical trials, highlighting the therapeutic relevance of this protein complex in managing inflammatory and neoplastic conditions. Further research into the regulation and modulation of the NF-kB complex may uncover new avenues for the development of targeted therapies for a wide range of diseases.
```

Note: `generate.py` requires a valid api key to be found in the file
`api-key`.

### `generated_to_ann.py`

The script `generated_to_ann.py` takes a file output by generate.py
and writes a `.txt` file with the generated text and a standoff
annotation `.ann` file with `Complex` annotations for the name
mentioned in the prompt. Example:

```
$ python3 generated_to_ann.py output-gpt-3.5-turbo-1106-0.txt
$ cat ann/output-gpt-3.5-turbo-1106-0.txt
Activation of the NF-kB protein complex is implicated in the pathogenesis of various inflammatory disorders and cancer. Dysregulated NF-kB signaling has been linked to the development and progression of rheumatoid arthritis, inflammatory bowel disease, and multiple myeloma. Furthermore, aberrant NF-kB activity has been associated with resistance to chemotherapy and targeted therapy in various malignancies. Given its central role in these pathological processes, targeting NF-kB has emerged as a promising therapeutic strategy. Small molecule inhibitors of NF-kB have shown potential in preclinical studies and clinical trials, highlighting the therapeutic relevance of this protein complex in managing inflammatory and neoplastic conditions. Further research into the regulation and modulation of the NF-kB complex may uncover new avenues for the development of targeted therapies for a wide range of diseases.
$ cat ann/output-gpt-3.5-turbo-1106-0.ann
T2	Complex 18 23	NF-kB
T3	Complex 133 138	NF-kB
T4	Complex 297 302	NF-kB
T5	Complex 476 481	NF-kB
T6	Complex 560 565	NF-kB
T7	Complex 805 810	NF-kB
```
