#!/usr/bin/env python3

# Provide basic corpus statistics for standoff text format for texts in one directory

import sys
import os
import glob
from argparse import ArgumentParser

from berttokenizer import basic_tokenize


def argparser():
    parser = ArgumentParser()
    parser.add_argument("--dir", required=True, type=str)
    
    return parser

def get_txt_stats(text):
    docs, words, chars = 0, 0, 0
    docs += 1
    words += len(basic_tokenize(text))
    chars += len(text)
    return docs, words, chars


def main(argv):
    '''example call: python3 brat_txt_stats.py --dir brat-annotation-standoff-txts'''
    args = argparser().parse_args()
    docs, words, chars = 0, 0, 0
    #directory structure entire-corpus/{test,dev,train} --> '*'
    for filename in glob.glob(os.path.join(args.dir, '*', '*.txt')):
        with open(os.path.join(os.getcwd(), filename), 'r') as fn:
            text = fn.read()
            file_docs, file_words, file_chars = get_txt_stats(text)
            docs += file_docs
            words += file_words
            chars += file_chars

    print('|docs|words|chars|')
    print('|----|-----|-----|')
    print(f'|{docs}|{words}|{chars}|')


if __name__ == '__main__':
    sys.exit(main(sys.argv))
