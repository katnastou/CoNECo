import sys

from Bio import Entrez


Entrez.email = 'sampo.pyysalo@utu.fi'


with open(sys.argv[1]) as f:
    phrases = f.read().splitlines()


for p in phrases:
    query = f'"{p}"[tiab:~0]'  # exact match: https://pubmed.ncbi.nlm.nih.gov/help/#phrase-index
    handle = Entrez.esearch(db='pubmed', term=query, retmax=1)
    record = Entrez.read(handle)
    handle.close()
    print(f'{p}\t{record["Count"]}', flush=True)
