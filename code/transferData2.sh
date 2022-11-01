#!/bin/bash

SUB=$1

python3 downloadXNAT.py https://xnat.cla.temple.edu Smith-RF1pilot /data/sourcedata/rf1-sequence-pilot/ $SUB

mv /data/sourcedata/rf1-sequence-pilot/Smith-SRA-$SUB/*/scans/ /data/sourcedata/rf1-sequence-pilot/MB_ME_test_sub-$SUB/dicoms
