# CoNECo

A Corpus for Named Entity Recognition and Normalization of Protein Complexes

* Annotation documentation: [https://katnastou.github.io/annodoc-CoNECo/](https://katnastou.github.io/annodoc-CoNECo/)
* Corpus on brat server: [http://ann.turkunlp.org:8088/index.xhtml#/CoNECo](http://ann.turkunlp.org:8088/index.xhtml#/CoNECo)

## Tasks before the hackathon

* Use the documents from ComplexTome corpus + extra from the RegulaTome where they will have: i) the latest set of NE annotations, ii) automatic addition of normalizations to GO-CC. Train/dev/test split remains the same (983 documents train/320 dev/318 test, 1621 documents in total). 
* Hold out a set of documents for IAA (make sure that manual check of normalization is done for these documents)
* Prepare annotation documentation for the corpus

## During/after the hackathon:

### Corpus

* Do IAA for i) NER, ii) NEN
* Calculate statistics on both tasks. If >90% finish with IAA.
* Split the documents in 800 Katerina/ 800 Mikaela and
  * Check already present annotations if rules are updated, ii) do/add missing normalizations for complexes.
  * For entities with no normalizations check other resources than GO
* Do a semi-automated check ([search.py](https://github.com/nlplab/brat/blob/master/server/src/search.py) -cm/ct) to see the consistency of matches/types + check consistency of normalizations

### Tagging

* Generate `extra_names.tsv` from Complex Portal for the dictionary (`GO:id Name`) 
* Use train/dev to run Jensenlab tagger on Puhti and update dictionary/blocklists according to results
* Use train/dev to run grid search with Transformer-based tagger on Mahti (`/scratch/project_2001426/katerina/CoNECo_ner_transformers`)
* Run final methods on the test set
* Do error analysis of results for NER (both methods) and NEN (dictionary-based only)
* Do large-scale tagging of complexes with both methods to provide results on the entire literature

### Publication
* Make Zenodo project to add all data/results and write paper
 
