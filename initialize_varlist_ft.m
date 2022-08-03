function data = initialize_varlist_ft(raw,srate,fname)


    restoredefaultpath
    addpath '/home/tvayryne/fieldtrip-20200423/'
    ft_defaults  

    data=raw;
    if size(data,1)==264
        labels = load('/home/tvayryne/CARBON_PROJEKTI/labels_carbon.mat')
    elseif size(data,1)==258
       labels = load('labels_ft_258.mat')
    elseif size(data,1)==256
       labels = load('labels_ft_258.mat')
       data([257,258],:)=zeros(2,size(data,2)); 
    elseif size(data,1)==257
       labels = load('labels_ft_258.mat')
       data(258,:)=zeros(1,size(data,2));
    elseif size(data,1)==32
        labels = load('labels_ft_33.mat') % Add reference null-channel
        data(33,:)=data(32,:);data(32,:)=0; % Ref 32 ecg 33
    else
        error('Unregognized data dimensions!')

    end
    
    datafile{1,1} = data;
    times{1,1} = [1:1:size(data,2)]/srate;
    clear data;
    data.label = labels.labels.chanlabels      % cell-array containing strings, Nchan*1
    data.fsample = srate     % sampling frequency in Hz, single number
    data.trial = datafile;   % cell-array containing a data matrix for each
    % trial (1*Ntrial), each data matrix is a Nchan*Nsamples matrix
    data.time  = times;      % cell-array containing a time axis for each
    data.eeginds = find(~strcmp(data.label,'ECG'));
    data.eeginds = find(~contains(data.label(data.eeginds),'CW'));

    fname = strsplit(fname,'.dat');fname=fname{1}
    data.fname = fname;
    %data.trialinfo % this field is optional, but can be used to store
    % trial-specific information, such as condition numbers,
    % reaction times, correct responses etc. The dimensionality
    % is Ntrial*M, where M is an arbitrary number of columns.
    %data.sampleinfo% optional array (Ntrial*2) containing the start and end
    % sample of each trial

end


