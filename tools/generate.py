import sys

from openai import OpenAI


MODEL='gpt-3.5-turbo-1106'

api_key = open('api-key').read()

client = OpenAI(api_key=api_key)

template = 'Write a paragraph of text in the style of a biomedical research article. Include the following protein complex name: {}. Use this name exactly as provided, avoiding any synonyms, aliases, abbreviated or expanded forms. Also avoid including any other names referring to a gene, protein, protein complex, protein part or component, or any other molecular entity containing amino acid residues. The text can include mentions of other biomedical entity types, such as chemical, organism, and disease names.'


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
    names = f.read().splitlines()


for i, n in enumerate(names):
    with open(f'output-{MODEL}-{i}.txt', 'w') as o:
        p = template.format(n)
        g = generate(p)
        print(f'model: {MODEL}', file=o)
        print(f'prompt: {p}', file=o)
        print(f'output: {g}', file=o)
        print(g, file=sys.stderr)
