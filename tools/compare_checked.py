#!/usr/bin/env python3

import sys


with(open(sys.argv[1])) as f:
    lines = f.read().splitlines()


target_lines = [l for l in lines if l.startswith('target: ')]
assert len(target_lines) == 1
target = target_lines[0][len('target: '):]

output_line_idx = [i for i, l in enumerate(lines) if l.startswith('output: ')]
assert len(output_line_idx) == 2
output_lines = lines[output_line_idx[1]:]
output_lines[0] = output_lines[0][len('output: '):]
output_lines = [l.strip() for l in output_lines]

if len(output_lines) > 1:
    print(f'mismatch\ttarget: {target}\toutput: {output_lines}')
    sys.exit(1)
output = output_lines[0]

if output.startswith('-') and not target.startswith('-'):
    output = output[1:].strip()

if (target.lower() == output.lower() or
    target.lower() + ' complex' == output.lower() or
    target.lower() + ' protein complex' == output.lower()):
    print(f'match\ttarget: {target}\toutput: {output}')
else:
    print(f'mismatch\ttarget: {target}\toutput: {output}')
