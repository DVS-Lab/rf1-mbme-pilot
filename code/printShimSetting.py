#!/usr/bin/env python3

import json, sys

infile = sys.argv[1]

with open(infile, 'r') as f:
  data = json.load(f)['ShimSetting']
  print(infile, data)
  