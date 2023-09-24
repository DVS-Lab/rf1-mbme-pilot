#!/bin/bash

sub=$1
python tedana-multi.py \
--fmriprepDir /ZPOOL/data/projects/rf1-mbme-pilot/derivatives/fmriprep/sub-${sub} \
--bidsDir /ZPOOL/data/projects/rf1-mbme-pilot/bids/sub-${sub} \
--sub $sub
