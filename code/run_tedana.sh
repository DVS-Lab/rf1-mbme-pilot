scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
python ${scriptdir}/my_tedana.py --fmriprepDir /data/projects/rf1-sequence-pilot/derivatives/fmriprep --bidsDir ../bids --cores 4
