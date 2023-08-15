import os

def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes

def infotodict(seqinfo):
    t1w = create_key('sub-{subject}/anat/sub-{subject}_T1w')
    mag = create_key('sub-{subject}/fmap/sub-{subject}_acq-bold_run-{item:01d}_magnitude')
    phase = create_key('sub-{subject}/fmap/sub-{subject}_acq-bold_run-{item:01d}_phasediff')


    #me1
    mb1me1 =       create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb1me1_bold')
    mb3me1 =       create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me1_bold')
    mb3me1_sbref = create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me1_sbref')
    mb6me1 =       create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb6me1_bold')
    mb6me1_sbref = create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb6me1_sbref')

    #me4
    mb1me4 =            create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb1me4_bold')
    mb3me4 =            create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me4_bold')
    mb3me4_sbref =      create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me4_sbref')
    mb6me4 =            create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb6me4_bold')
    mb6me4_sbref =      create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb6me4_sbref')


    # sequence pilot 2.0 (all should be fa50, but only using that to differentiate from previous)
    mb3me3 =            create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me3_bold')
    mb3me3_sbref =      create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me3_sbref')
    mb3me3_ip0 =        create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me3ip0_bold')
    mb3me3_ip0_sbref =  create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me3ip0_sbref')
    mb3me4_fa50 =       create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me4fa50_bold')
    mb3me4_fa50_sbref = create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me4fa50_sbref')
    mb2me4 =            create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb2me4_bold')
    mb2me4_sbref =      create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb2me4_sbref')
    mb3me1_fa50 =       create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me1fa50_bold')
    mb3me1_fa50_sbref = create_key('sub-{subject}/func/sub-{subject}_task-sharedreward_acq-mb3me1fa50_sbref')


    info = {t1w: [], mag: [], phase: [],

            mb1me1: [],
            mb3me1: [],
            mb3me1_sbref: [],
            mb6me1: [],
            mb6me1_sbref: [],

            mb1me4: [],
            mb3me4: [],
            mb3me4_sbref: [],
            mb6me4: [],
            mb6me4_sbref: [],

            # sequence pilot 2.0
            mb3me3: [], mb3me3_sbref: [],
            mb3me3_ip0: [], mb3me3_ip0_sbref: [],
            mb3me4_fa50: [], mb3me4_fa50_sbref: [],
            mb2me4: [], mb2me4_sbref: [],
            mb3me1_fa50: [], mb3me1_fa50_sbref: [],

            }


    list_of_ids = [s.series_id for s in seqinfo]
    for s in seqinfo:
        if ('T1w-anat_mpg_07sag_iso' in s.protocol_name) and ('NORM' in s.image_type):
            info[t1w] = [s.series_id]
        if ('gre_field' in s.protocol_name) and ('NORM' in s.image_type):
            info[mag].append(s.series_id)
        if ('gre_field' in s.protocol_name) and ('P' in s.image_type):
            info[phase].append(s.series_id)

        # no multi-echo
        if (s.dim4 >= 100) and ('MB1_' in s.protocol_name) and ('_ME1' in s.protocol_name) and ('M' in s.image_type):
            info[mb1me1].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
        if (s.dim4 >= 100) and ('MB3_' in s.protocol_name) and ('_ME1' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me1].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me1_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB6_' in s.protocol_name) and ('_ME1' in s.protocol_name) and ('M' in s.image_type):
            info[mb6me1].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb6me1_sbref].append(list_of_ids[idx -1])

        # multi-echo standard
        if (s.dim4 >= 100) and ('MB1_' in s.protocol_name) and ('_ME4' in s.protocol_name) and ('M' in s.image_type):
            info[mb1me4].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
        if (s.dim4 >= 100) and ('MB3_' in s.protocol_name) and ('_ME4' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me4].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me4_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB6_' in s.protocol_name) and ('_ME4' in s.protocol_name) and ('M' in s.image_type):
            info[mb6me4].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb6me4_sbref].append(list_of_ids[idx -1])

        # sequence pilot 2.0
        if (s.dim4 >= 100) and ('MB3ME3_IP2_FA50' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me3].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me3_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB3ME3_IP0_FA50' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me3_ip0].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me3_ip0_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB3ME4_IP2_FA50' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me4_fa50].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me4_fa50_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB3ME4_IP2_FA20' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me4].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me4_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB3ME1_IP0_FA50' in s.protocol_name) and ('M' in s.image_type):
            info[mb3me1_fa50].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb3me1_fa50_sbref].append(list_of_ids[idx -1])
        if (s.dim4 >= 100) and ('MB2ME4_IP2_FA50' in s.protocol_name) and ('M' in s.image_type):
            info[mb2me4].append(s.series_id)
            idx = list_of_ids.index(s.series_id)
            info[mb2me4_sbref].append(list_of_ids[idx -1])



    return info

# this should match bold with fmap. we do not need to list the sbref images (per NeuroStars post that I can't paste in here)
POPULATE_INTENDED_FOR_OPTS = {
        'matching_parameters': ['ModalityAcquisitionLabel'],
        'criterion': 'Closest'
}
