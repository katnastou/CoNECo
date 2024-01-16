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
