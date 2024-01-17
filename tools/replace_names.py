#!/usr/bin/env python3

import sys
import os
import re

from copy import copy
from itertools import tee
from dataclasses import dataclass
from argparse import ArgumentParser


SPAN_RE = re.compile(r'^(T[0-9]+)\t(\S+) (\d+) (\d+)\t(.*)$')


@dataclass
class Span:
    id_: str
    type_: str
    start: int
    end: int
    text: str


def argparser():
    ap = ArgumentParser()
    ap.add_argument('outdir')
    ap.add_argument('names')
    ap.add_argument('ann', nargs='+')
    return ap


def load_ann(fn):
    spans = []

    with open(fn) as f:
        for ln, l in enumerate(f, start=1):
            l = l.rstrip('\n')
            if l.startswith('T'):
                m = SPAN_RE.match(l)
                id_, type_, start, end, text = m.groups()
                start, end = int(start), int(end)
                spans.append(Span(id_, type_, start, end, text))
            elif l.startswith('N'):
                pass    # ignore normalization
            else:
                raise ValueError(f'failed to parse line: {l}')

    return spans


def pairwise(iterable):
    # https://docs.python.org/3/library/itertools.html#itertools.pairwise
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)


def segment_text(text, anns):
    # segment text into ann spans and strings around them
    anns.sort(key=lambda s: s.start)

    for a, b in pairwise(anns):
        assert a.end <= b.start, 'overlapping annotations'

    segments, prev = [], None
    for a in anns:
        s = prev.end if prev is not None else 0
        segments.append(Span(None, None, s, a.start, text[s:a.start]))
        segments.append(copy(a))
        prev = a
    segments.append(Span(None, None, a.end, len(text), text[a.end:]))

    assert ''.join(s.text for s in segments) == text

    return segments


def replace_names(text, anns, replacements):
    segments = segment_text(text, anns)

    offset = 0
    for s in segments:
        if s.type_ is not None:
            r = replacements.get(s.text, s.text)
            s.text = r
        s.start, s.end = offset, offset+len(s.text)
        offset += len(s.text)

    text = ''.join(s.text for s in segments)
    return text, [s for s in segments if s.type_ is not None]


def main(argv):
    args = argparser().parse_args(argv[1:])

    with open(args.names) as f:
        names = f.read().splitlines()

    texts_and_anns = []
    for annfn in args.ann:
        anns = load_ann(annfn)
        txtfn = annfn.replace('.ann', '.txt')
        with open(txtfn) as f:
            text = f.read()
        texts_and_anns.append((text, anns))

    n_idx, d_idx, o_idx = 0, 0, 0
    while n_idx < len(names):
        text, anns = texts_and_anns[d_idx]
        d_idx = (d_idx+1) % len(texts_and_anns)    # cycle

        ann_names = set(a.text for a in anns)
        replacements = {}
        for n in ann_names:
            replacements[n] = names[n_idx]
            n_idx += 1
            if n_idx >= len(names):
                break

        text, anns = replace_names(text, anns, replacements)

        with open(f'{args.outdir}/{o_idx}.txt', 'w') as o:
            print(text, file=o, end='')

        with open(f'{args.outdir}/{o_idx}.ann', 'w') as o:
            for a in anns:
                print(f'{a.id_}\t{a.type_} {a.start} {a.end}\t{a.text}', file=o)

        o_idx += 1


if __name__ == '__main__':
    sys.exit(main(sys.argv))
