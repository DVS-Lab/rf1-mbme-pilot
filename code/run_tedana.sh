#scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sub=$1
python tedana-multi.py \
--fmriprepDir /data/projects/rf1-mbme-pilot/derivatives/fmriprep/sub-${sub} \
--bidsDir /data/projects/rf1-mbme-pilot/bids/sub-${sub} \
--sub $sub
