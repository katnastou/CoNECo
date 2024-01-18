#!/usr/bin/env python3

import sys
import os
import re

from openai import OpenAI


MODEL='gpt-3.5-turbo-1106'
#MODEL='gpt-4-1106-preview'

# Regex for parsing target protein complex name from prompt
NAME_RE = re.compile(r'Include the following protein complex name: (.*?)\. Use this name exactly as provided')

api_key = open('api-key').read()

client = OpenAI(api_key=api_key)

template = '''List all of the specific names of protein-containing complexes mentioned in the following text. Do not list general (non-name) references to protein complexes, or the names of entities of other types such as chemicals, organisms, or diseases. Only answer with a list of names, one per line, including the full form of each name in the exact form in which it appears in the text.

{}'''


def generate(prompt):
    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt },
        ]
    )
    return response.choices[0].message.content


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

    p = template.format(output)
    g = generate(p)

    print(f'model: {MODEL}')
    print(f'prompt: {p}')
    print(f'target: {name}')
    print(f'output: {g}')
