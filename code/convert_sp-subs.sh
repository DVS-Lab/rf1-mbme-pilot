#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
logdir=${basedir}/stimuli/logs

task=sharedreward

for sub in 10589 10590 10603 10606 10608 10644 10690 10691 10723 10741 10777 10803; do
	for run in 1 2 3 4 5 6; do
		mv ${logdir}/${sub}99/sub-${sub}sp_task-${task}_run-${run}_acq-mb3me4_raw.csv	${logdir}/${sub}99/sub-${sub}99_task-${task}_run-${run}_acq-mb3me4_raw.csv 2>/dev/null
		mv ${logdir}/${sub}99/sub-${sub}sp_task-${task}_run-${run}_acq-mb2me4_raw.csv	${logdir}/${sub}99/sub-${sub}99_task-${task}_run-${run}_acq-mb2me4_raw.csv 2>/dev/null
		mv ${logdir}/${sub}99/sub-${sub}sp_task-${task}_run-${run}_acq-mb3me1_raw.csv	${logdir}/${sub}99/sub-${sub}99_task-${task}_run-${run}_acq-mb3me1_raw.csv 2>/dev/null
		mv ${logdir}/${sub}99/sub-${sub}sp_task-${task}_run-${run}_acq-mb3me3_raw.csv	${logdir}/${sub}99/sub-${sub}99_task-${task}_run-${run}_acq-mb3me3_raw.csv 2>/dev/null
	done
done