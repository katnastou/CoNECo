#!/usr/bin/env python3

import sys
import os
import re


# Regex for parsing target protein complex name from prompt
NAME_RE = re.compile(r'Include the following protein complex name: (.*?)\. Use this name exactly as provided')


with open(sys.argv[1]) as f:
    model_line = f.readline()
    assert model_line.startswith('model: ')

    prompt_line = f.readline()
    assert prompt_line.startswith('prompt: ')

    output = f.read()
    assert output.startswith('output: ')
    text = output[len('output: '):].rstrip('\n')
    
    m = NAME_RE.search(prompt_line)
    assert m
    name = m.group(1)

    name_re = re.compile(r'\b'+re.escape(name)+r'\b', re.IGNORECASE)
    matches = list(name_re.finditer(text))

    bn = os.path.splitext(os.path.basename(sys.argv[1]))[0]

    with open(f'ann/{bn}.txt', 'w') as o:
        print(text, file=o)
    
    with open(f'ann/{bn}.ann', 'w') as o:
        for i, m in enumerate(matches, start=1):
            start, end, text = m.start(), m.end(), m.group(0)
            print(f'T{i+1}\tComplex {start} {end}\t{text}', file=o)
