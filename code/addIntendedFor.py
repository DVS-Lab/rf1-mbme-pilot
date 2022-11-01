#imports libraries
import json
import os
import subprocess
import re

#gets current working directory If your bids is in the same folder as this file this should work for everyone
cwd = dir_path = os.path.dirname(os.path.realpath(__file__)) 
bidsdir = os.path.join('%s/../bids'%(cwd))

files = os.listdir(bidsdir)
subs=[x for x in files if x.startswith('sub')]
print(subs)


for subj in subs:
    print("Running subject: %s"%(subj))

    #makes list of the json files to edit
    files=[os.path.join('%s/%s/fmap'%(bidsdir,subj), f) for f in os.listdir('%s/%s/fmap'%(bidsdir,subj))]
    files_json = [i for i in files if i.endswith('.json')]
    #makes list of the func files to add into the intended for field
    files = ["func/%s"%(file) for file in os.listdir('%s/%s/func'%(bidsdir,subj))]
    files_txt = [i for i in files if i.endswith('.nii.gz')]
    if not all(['run' in str for str in files_json]):

        #This could be done better but we open the json files ('r' for read only) as a dictionary add the Intended for key 
        #and add the func files to the key value
        #The f.close is a duplication. f can only be used inside the with "loop"# we open the file again to write only and dump the dictionary to the files
        for i in range(len(files_json)):
            with open(files_json[i],'r')as f:
                data=json.load(f)
                data["IntendedFor"]=files_txt
                f.close
            with open(files_json[i],'w')as f:
                json.dump(data,f,indent=4,sort_keys=True)
                f.close
    
    #IF ALL of the json's have the "run" key we then try 
    #to seperate out which functional files belong to which fmaps
    if all(['run' in str for str in files_json]):
        
        import pandas as pd
        from natsort import natsorted

        # USE heudiconv data to find the scans taken after 1 fmap but before the next
        df=pd.read_csv('%s/../bids/.heudiconv/%s/info/dicominfo.tsv'%(cwd,subj[4:]),
                    sep='\t')
        fmaps=df.series_id.str.contains('fmap').values
        breaks=[i for i in range(len(fmaps)) if ((fmaps[i]==False) & (fmaps[i-1]==True))|((fmaps[i]==True) & (fmaps[i-1]==False))]
        
        #find the series ID for those files
        groups=[]
        for i in range(len(breaks)):
            if i==len(breaks)-1:
                groups.append(list(df.iloc[breaks[i]:].series_id.values)) #all of the scans taken after the last fmap
            elif i%2:
                groups.append(list(df.iloc[breaks[i]:breaks[i+1]].series_id.values))# all of the scans taken inbetween
        print("We found %s runs groups of functional runs for each fmap to be intended for"%(len(groups)))

        file_groups=[]
        #Data frame to make it easier to ID filenames
        cheap_df = pd.DataFrame(files_txt)
        
        #count the unique run values for the json files
        fmap_runs=natsorted(set(
            [re.search("run-(.*)_",item).group(0) for item in files_json]))
        print(fmap_runs)
        # Read the acquisition from the series ID
        for i,group in enumerate(groups):
            acqs=[]
            for item in group:
                if "CMRR" in item:
                    #print("item is %s"%(item))
                    ME=re.search('ME(.*)_TR',item).group(1)
                    MB=re.search('MB(.*)_IP',item).group(1)
                    acqs.append('mb%sme%s'%(MB,ME))
                
            #Find files with that contain the acquistions listed
            file_groups=list(cheap_df[cheap_df[0].str.contains('|'.join(acqs))][0].values)

            #pull out the json files with the current Run in it
            run_jsons=[x for x in files_json if fmap_runs[i] in x]
            
            print("Files %s are intended for: \n\n acquisition %s \n\n files  %s \n \n"%(run_jsons,acqs,file_groups))


            for i in range(len(run_jsons)):
                with open(run_jsons[i],'r')as f:
                    data=json.load(f)
                    data["IntendedFor"]=file_groups
                    f.close
                with open(run_jsons[i],'w')as f:
                    json.dump(data,f,indent=4,sort_keys=True)
                    f.close
    #This could be done better but we open the json files ('r' for read only) as a dictionary add the Intended for key 
#and add the func files to the key value
#The f.close is a duplication. f can only be used inside the with "loop"# we open the file again to write only and dump the dictionary to the files


