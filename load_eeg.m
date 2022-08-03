%OPEN BINARY OR NON-BINARY BVA FILES + EEGLAB BVA EXPORTS
% input: 'filename.dat'; output raw,srate

function [raw,srate] = load_eeg(filename)

filename_eeg = string(filename);
filename_eeg = strsplit(filename_eeg,'.');filename_eeg = filename_eeg{1,1};

    fid = fopen(sprintf('%s.vhdr',filename_eeg));
    istring = fscanf(fid,'%s');
    fclose(fid);   
    dataformat = strsplit(istring,'DataFormat=');
    dataformat = strsplit(dataformat{1,2},';');dataformat=string(dataformat{1,1});
    
    if dataformat == 'BINARY'
        chan_lkm = strsplit(istring,'NumberOfChannels=');
        sample_lkm = strsplit(istring,'DataPoints=');
        chan_lkm= strsplit(chan_lkm{1,2},'DataPoints');chan_lkm=str2num(chan_lkm{1,1});
        sample_lkm=strsplit(sample_lkm{1,2},';');sample_lkm=str2num(sample_lkm{1,1});

        orientation = strsplit(istring,'DataOrientation=');
        orientation = strsplit(orientation{1,2},'DataType');orientation=string(orientation{1,1});

        samplinginter = strsplit(istring,'SamplingInterval=');
        samplinginter = strsplit(samplinginter{1,2},'[');samplinginter=str2num(samplinginter{1,1});
        srate = 1000000 / samplinginter;

         if orientation == 'MULTIPLEXED'
         a = fopen(sprintf('%s.dat',filename_eeg));
         raw = fread(a,[chan_lkm sample_lkm],'float32');
         fclose(a);
         elseif orientation == 'VECTORIZED'
         a = fopen(sprintf('%s.dat',filename_eeg));
         raw = fread(a,[sample_lkm chan_lkm],'float32');
         raw = raw';
         fclose(a);
         else
         error('Data orientation not recognized')
         end
    
else
     raw = load(sprintf('%s.dat',filename_eeg));
end

end
