% function []=SupVect(mainDir)

% Create Super Vectors
% [~, folders, ~, ~, ~,...
%     ~, ~, ~,...
%     ~, ~, ~, ~, ~,...
%     ~, ~, modelToSvExe,...
%     modelToSvConfig, ~, ~, ...
%     ~,~,~]=getALIZEpath(mainDir);

mainDir=workingFolder;
for segment=1:3
    for num=1:length(folders)
        if segment==1
            segmentFilename='/seg1';
            filedir=[mainDir folders{num} '/' segmentFilename ];
        elseif segment==2
            segmentFilename='/seg2';
            filedir=[mainDir folders{num} '/' segmentFilename ];
        else 
            filedir=[mainDir folders{num} '/' ];
        end
        eval(['cd ' filedir]);
        mkdir('sv');
        model_filelist = dir('10*.wav'); % Extract filenames from gmms
        fileID8=fopen('SuperVectors.ndx','w+');
        
        for k = 1:length(model_filelist)
            eval('fprintf(fileID8 , ''%s \n'' ,model_filelist(k).name(1:5)); ') % Write SV filenames
           % eval('fprintf(fileID8 , '' %s \n '' ,  model_filelist(k).name(1:5));') % Write SV filenames
        end
        
        
        eval(['cd ' filedir]);
        eval(['! ' modelToSvExe ' --config ' modelToSvConfig])
        eval(['cd ' filedir]);
    end
end

fclose('all');

% Convert SV to .mat files for reading

eval(['cd ' workingFolder])


for segment=1:3
    for num=1:length(folders)
        if segment==1
            segmentFilename='/seg1';
            filedir=[mainDir folders{num} '/' segmentFilename '/sv/'];
        elseif segment==2
            segmentFilename='/seg2';
            filedir=[mainDir folders{num} '/' segmentFilename '/sv/' ];
        else 
            filedir=[mainDir folders{num} '/sv/' ];
        end
        eval(['cd ' filedir]);
        filenames=dir('10*.kl');
        spkrs=length(filenames);
        for currSpkr=1:spkrs
            currfile=filenames(currSpkr).name(1:5);
            fid = fopen([currfile '.kl'],'rb');
            if(fid == -1)
                error('Cannot open file %s',currfile);
            end
            
            prec='ulong';
            M = fread(fid,1,prec);
            N = fread(fid,1,prec);
            
            precision = 'double';
            V = fread(fid,[M,N],precision);
            
            fclose(fid);
            
            save(['' currfile ''],'V')
        end
    end
end 


eval(['cd ' mainDir]);

