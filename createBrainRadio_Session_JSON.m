function createBrainRadio_Session_JSON()
%% This function creats a JSON for brain radion session 
%  The purpose of this function is to create machine readable
%  directory walkers for Brain radion session. 
%  A session is defined as one continuos recording in a visit. 
%  Each patient may have multiple visits along multiple points of time. 
%  The function relies on searcing a root directory for patient and visit
%  JSON's. 
%  To create these see: 
%  createBrainRadioVisits_JSON() 
%  createBrainRadioSubject_JSON() 

% input - a list of JSON files of brain radio visits 

% output - a JSON is saved within each visit directory with details bout
% this visit 

rootdir  = '/Volumes/Starr_Lab_H/Starr_Lab/BR_raw_data'; 
% get subject json 
fnmsave = fullfile(rootdir, 'patients-^^^^-.json'); 
Patients = loadjson(fnmsave,'SimplifyCell',1); % this is how to read the data back in.
for p = 1:lengt     h(Patients)
    visitfnm = fullfile(rootdir, Patients(p).PatientFolderName,'visit-details-^^^^-.json'); 
    visits = loadjson(visitfnm,'SimplifyCell',1); % this is how to read the data back in.
    for v = 1:length(visits) % loop on each visit to find sesssions 
        
    end
end

% loop on each subject and get all the visits within this subject 
% find all the session within this subject 
end