# CoNECo: a Corpus for Named Entity recognition and normalization of protein Complexes

This repository contains scripts to support different steps of the analyses performed in the CoNECo paper. 

There is a [Zenodo project](https://doi.org/10.5281/zenodo.10623629) associated with this repository.

Annotation documentation is available through Zenodo and this page: [https://katnastou.github.io/annodoc-CoNECo/](https://katnastou.github.io/annodoc-CoNECo/)

## Corpus statistics

There are three scripts in this directory to replicate the process of calculating corpus statistics as described in the Results and Discussion section of the manuscript. You only need to invoke the shell script in the directory.

```shell
./corpus_stats/run.sh
```
For word counting of the documents, BERT basic tokenization is used, with the implementation found [here](https://github.com/spyysalo/bert-vocab-eval).

## CoNECo corpus

This directory has the documents in BRAT and conll format. 

## Error analysis 

For the error analysis the evaluation script `evalso.py` is used to detect False Positives and False Negatives in each document of the test set. To invoke the command in the entire Jensenlab tagged CoNECo test set using the CoNECo annotated test set as a gold standard a shell script is provided.

```shell
./error_analysis/jensenlab-tagger/run.sh
```

Similarly, for the Transformer-based tagger, you should run:

```shell
./error_analysis/transformer-tagger/run.sh
```

## Large-scale tagging for Jensenlab tagger

For large-scale tagging, the [tagger](https://github.com/larsjuhljensen/tagger) needs to be set up first. Instructions on how to set it up can be found [here](https://github.com/larsjuhljensen/tagger). Then one needs to execute the shell script and the results that are also available in [Zenodo](https://doi.org/10.5281/zenodo.10623629) can be obtained. 

```shell
./large-scale-jensenlab-tagger/run.sh
```

## CoNECo transformer ner

Please refer to the [original repo](https://github.com/katnastou/CoNECo-transformer-ner.git) on how to train an NER model on CoNECo.

## CoNECo transformer tagger

Please refer to the [original repo](https://github.com/katnastou/CoNECo-transformer-tagger.git) on how to do a large-scale run using the model trained on CoNECo.
