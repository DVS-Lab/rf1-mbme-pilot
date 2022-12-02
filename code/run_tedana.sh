#scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
python my_tedana.py --fmriprepDir /data/projects/rf1-mbme-pilot/derivatives/fmriprep --bidsDir ../bids --cores 8
