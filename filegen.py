#! /usr/bin/env python3

import random
import string
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('size', type=int, nargs='?', default=1000000)
parser.add_argument('--seed', type=int, default=None)
args = parser.parse_args()

random.seed(args.seed)

for i in range(args.size):
    x = ''
    letter = random.choice(string.ascii_lowercase + '\n')
    if letter == '\n':
        x += letter
    else:
        for i in range(int(random.random() * 20) + 1):
            x += letter
    print(x, end='')
