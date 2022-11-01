#!/usr/bin/env python
# coding: utf-8

# In[16]:


from scipy.io import loadmat
import pandas as pd
import os
import re

subs=[num for num in os.listdir('../stimuli/logs/')]
partner_codes = {1:'computer',2:'stranger',3:'friend'}
Button_codes = {2:'rightButton', 7:'leftButton'}
feedback_codes = {1:'punish',2:'neutral',3:'reward'}

for sub in subs:
    
    eventfiles = ['../stimuli/logs/%s/%s'%(sub,file) for file in os.listdir('../stimuli/logs/%s'%(sub)) if file.endswith('raw.csv')]
    if sub=='10198':
        print("running sub-%s"%(sub))
        for file in eventfiles:
            #try:
            x=pd.read_csv(file)
        
            scan_start=float(x['InitFixOnset'][0])
            x['Partner'] = x['Partner'].map(partner_codes).astype('str')
            x['Feedback'] = x['Feedback'].map(feedback_codes).astype('str')
            x['resp'] = x['resp'].map(Button_codes).astype('str')
            x['feed_type'] = x[['Feedback','Partner']].agg('_'.join, axis=1)
            x['resp'] = x[['resp','Partner']].agg('_'.join, axis=1)

            data=[]
            print('made it here')
            for index, row in x.iterrows(): #seperating out 2 kinds of events per file
                feedback_info=[float(row['outcome_onset'])-scan_start,
                             float(row['outcome_offset'])-float(row['outcome_onset']),
                             row['feed_type'],
                             row['rt']]
                feedback_info['feed_type']='outcome_'+feedback_info['feed_type']

                button_info=[row['decision_onset'],
                               row['rt'],
                               row['resp'],
                               'n/a']
                button_info['resp']='guess_'+button_info['resp']
                        
            data.append(button_info)
            
            data.append(feedback_info)
            #print(data)

            df=pd.DataFrame(columns=[['onset','duration','trial_type','response_time']],data=data)
            print(df.head())
            outdir = '../bids/sub-%s/func'%(sub)
        
            if not os.path.exists(outdir):
                os.makedirs(outdir)
            acq=re.search('acq-(.*)_raw',file).group(1)
            fullname = os.path.join(outdir,'sub-%s_task-sharedreward_acq-%s_events.tsv'%(sub,acq)

            print(fullname)
            df.to_csv(fullname,sep='\t',index=False)
                
            #except:
                #print("Something went wrong for sub-%s file: %s"%(sub,file))

