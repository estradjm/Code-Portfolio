% function [EER2]=GMMUBM(workingFolder, folders)

EER=nan(length(folders),length(folders));

% Energy and dynamics study
if deltaTestEnable==1
    for deltaTest=1:3 
        if deltaTest==1 % First Derivative
            sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -D -m -v ';
            vectsize='32';
        elseif deltaTest==2 % First and Second Derivative
            sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -D -A -m -v ';
            vectsize='48';
        elseif deltaTest==3 % No derivatives
            sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -m -v ';
            vectsize='16';
        end
    end
else
    sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -D -m -v ';
    vectsize='32';
end


TrainUBM
%(UBM_Training,SPRO,SPROTxt, NormFeatExe,...
%    NormFeatConfig, NormFeatConfig2, EnergyDetectExe,...
%    EnergyDetectConfig, UBMExe, UBMConfig); 

for condition= 1:length(folders)
    for condition2= 1:length(folders)

        GMM_Test=[workingFolder folders{condition} '/'];
        GMM_Train=[workingFolder folders{condition2} '/'];
        
        TrainGMM
%         (UBM_Training,GMM_Train,...
%             SPRO, SPROTxt, NormFeatExe, NormFeatConfig,...
%             NormFeatConfig2, EnergyDetectExe, EnergyDetectConfig,...
%             GMMExe, GMMConfig)
        
        ExtractTargetFeatures
%         (UBM_Training, GMM_Test,...
%             SPRO, SPROTxt, NormFeatExe, NormFeatConfig,...
%             NormFeatConfig2, EnergyDetectExe, EnergyDetectConfig,...
%             GMMExe, GMMConfig)
        
        ComputeDecisionMetrics
%         (computeTestExe, computeTestConfig, GMM_Test,...
%             GMM_Train);
        
        [EER]=Scoring(computeTestExe, computeTestConfig, GMM_Test,...
            GMM_Train);

        GMM_EER(condition, condition2)=EER;
        
    end
end

fclose('all');

% end

% clc;
 
%function []=TrainUBM(UBM_Training,SPRO,SPROTxt, ...
%    NormFeatExe, NormFeatConfig, NormFeatConfig2, EnergyDetectExe,...
%    EnergyDetectConfig, UBMExe, UBMConfig)

eval(['cd ' UBM_Training ])

diary('TrainUBM.txt');
% Check and create folders for ALIZE
if isdir('feats')==1
    rmdir('feats','s')
    end
mkdir('feats');

if isdir('feats_txt')==1
    rmdir('feats_txt','s')
    end
mkdir('feats_txt');

if isdir('gmm')==1
    rmdir('gmm','s')
end
    mkdir('gmm');
    
if isdir('labels')==1
    rmdir('labels','s')
end
mkdir('labels');

filelist = dir('*.wav'); % Extract filenames from audio files
fileID1=fopen('world.ndx', 'w+'); % ndx file for TrainWorld
fileID2=fopen('world.lst', 'w+'); % TrainingFiles (NormFeat and EnergyDetector)
for i = 1:length(filelist)
    if ~strcmp(filelist(i).name(1:(end-4)),'20010') % Corrupt file??
    % eval(['fprintf(fileID ' numState ' , ''%s  '' , filelist(i).name(1:(end-4)));']) % Write file name
    eval(['fprintf(fileID1, ''%s  '' , filelist(i).name(1:(end-4)));']) % Write input file name
    eval(['fprintf(fileID1, ''%s\n'' , filelist(i).name(1:(end-4)));']) % Write model file name
    
    eval(['fprintf(fileID2, ''%s\n'' , filelist(i).name(1:(end-4)));']) % Writing feature file list (fileList)
    
    wavwrite(wavread([pwd '/' filelist(i).name]),8000,16,[pwd '/' filelist(i).name]);
%     sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -n 24 -b 512 -p 12 ';
%    sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -D -A -m -v ';
    % Run SPRO 4.0 to extract features
    eval(['! ' SPRO  sproParam  pwd '/' filelist(i).name ' ' pwd '/feats/' filelist(i).name(1:(end-4)) '.prm']);
    
    % Convert features to text file
    eval(['! ' SPROTxt ' -v -o ascii ' pwd '/feats/' filelist(i).name(1:(end-4)) '.prm ' pwd '/feats_txt/' filelist(i).name(1:(end-4)) '.txt']);
    end
end

listFile='world.lst';
ndxFile='world.ndx';
% Running NormFeat
eval(['! ' NormFeatExe ' --config ' NormFeatConfig ' --featureFilesPath ./feats/  --inputFeatureFilename ' listFile ' --vectsize ' vectsize ]);

%Running EnergyDetector
eval(['! ' EnergyDetectExe ' --config ' EnergyDetectConfig ' --featureFilesPath ./feats/ --labelFilesPath ./labels/ --inputFeatureFilename ' listFile ' --vectsize ' vectsize ]);

%Running NormFeat AGAIN
eval(['! ' NormFeatExe ' --config ' NormFeatConfig2 ' --labelFilesPath ./labels/ --featureFilesPath ./feats/ --inputFeatureFilename ' listFile  ' --vectsize ' vectsize]);

% Training World UBM:
eval(['! ' UBMExe ' --config ' UBMConfig ' --lstPath ./ --inputFeatureFilename ' listFile ' --featureFilesPath ./feats/ --outputWorldFilename TRAINED_WORLD --vectsize ' vectsize])

 
%function TrainGMM(UBM_Training, DataFolder,...
%    SPRO, SPROTxt, NormFeatExe, NormFeatConfig,...
%    NormFeatConfig2, EnergyDetectExe, EnergyDetectConfig,...
%    GMMExe, GMMConfig)

currDir=GMM_Train;
eval(['cd ' currDir])

diary('TrainGMMlogFile.txt');


% Check and create folders for ALIZE
if isdir('feats')==1
    rmdir('feats','s')
end
mkdir('feats');

if isdir('feats_txt')==1
    rmdir('feats_txt','s')
end
mkdir('feats_txt');

if isdir('gmm')==1
    rmdir('gmm','s')
end
mkdir('gmm');

if isdir('labels')==1
    rmdir('labels','s')
end
mkdir('labels');

eval(['copyfile(''' UBM_Training '/gmm/' ''',''' pwd '/gmm/' ''');'])

% End of directory manipulations


% Start SPRO for feature extraction and create index list files for ALIZE
filelist_targ= dir('*.wav'); % Extract filenames from audio files

fileID1=fopen('trainGMMs.lst', 'w+'); % list file for TrainTarget

for i = 1:length(filelist_targ)
    filelist_targ1=filelist_targ(i).name(1:(end-4));
    filelist_targ2=filelist_targ1(1:5);
    targID(i)=str2double(filelist_targ2);
    
    eval(['fprintf(fileID1 , ''%s\n'' , filelist_targ(i).name(1:(end-4)));']) % Writing feature file list (fileList)
    
    wavwrite(wavread([pwd '/' filelist_targ(i).name]),8000,16,[pwd '/' filelist_targ(i).name]);
    
    % Run SPRO 4.0 to extract features
    %sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -D -m -v ';
    
    eval(['! ' SPRO sproParam pwd '/' filelist_targ(i).name ' ' pwd '/feats/' filelist_targ(i).name(1:(end-4)) '.prm']);
    
    % Convert features to text file
    eval(['! ' SPROTxt ' -v -o ascii ' pwd '/feats/' filelist_targ(i).name(1:(end-4)) '.prm ' pwd '/feats_txt/' filelist_targ(i).name(1:(end-4)) '.txt']);
    
end

fileID7=fopen('trainGMMs.ndx', 'w+'); % ndx file for TrainTarget

for k = 1:length(unique(targID))
    spkrID=unique(targID);
    eval('fprintf(fileID7 , ''%d '' , spkrID(k));') % Speaker ID
    
    for j = 1:i
        if spkrID(k)==targID(j)
            eval('fprintf(fileID7 , '' %s '' , filelist_targ(j).name(1:(end-4)));') % Write target model filenames (spkr1 spkrseg1 spkrseg2)
        end
    end
    
    eval('fprintf(fileID7 , ''\n'' );') % new line and new speaker
end

% Start ALIZE
listFile='trainGMMs.lst';
ndxFile='trainGMMs.ndx';
% Running NormFeat
eval(['! ' NormFeatExe ' --config ' NormFeatConfig ' --featureFilesPath ./feats/  --inputFeatureFilename ' listFile ]);

% Running EnergyDetector
eval(['! ' EnergyDetectExe ' --config ' EnergyDetectConfig ' --featureFilesPath ./feats/ --labelFilesPath ./labels/ --inputFeatureFilename ' listFile ]);

% Running NormFeat AGAIN
eval(['! ' NormFeatExe ' --config ' NormFeatConfig2 ' --labelFilesPath ./labels/ --featureFilesPath ./feats/ --inputFeatureFilename ' listFile ]);

% Training GMM
eval(['! ' GMMExe ' --config ' GMMConfig ' --lstPath ./ --inputFeatureFilename ' ndxFile ' --targetIdList ' ndxFile ' --featureFilesPath ./feats/ --inputWorldFilename TRAINED_WORLD'])



 
% function ExtractTargetFeatures(UBM_Training, DataFolder,...
%     SPRO, SPROTxt, NormFeatExe, NormFeatConfig,...
%     NormFeatConfig2, EnergyDetectExe, EnergyDetectConfig,...
%     GMMExe, GMMConfig)

currDir=GMM_Test;
eval(['cd ' currDir])

diary('ExtractTargetFeaturesLogFile.txt');


% Check and create folders for ALIZE
if isdir('feats')==1
    rmdir('feats','s')
end
mkdir('feats');

if isdir('feats_txt')==1
    rmdir('feats_txt','s')
end
mkdir('feats_txt');

if isdir('labels')==1
    rmdir('labels','s')
end
mkdir('labels');


% End of directory manipulations


% Start SPRO for feature extraction and create index list files for ALIZE
filelist_targ= dir('*.wav'); % Extract filenames from audio files

fileID1=fopen('ExtractFeatures.lst', 'w+'); % list file for TrainTarget

for i = 1:length(filelist_targ)
    filelist_targ1=filelist_targ(i).name(1:(end-4));
    filelist_targ2=filelist_targ1(1:5);
    targID(i)=str2double(filelist_targ2);
    
    eval(['fprintf(fileID1 , ''%s\n'' , filelist_targ(i).name(1:(end-4)));']) % Writing feature file list (fileList)
    
    wavwrite(wavread([pwd '/' filelist_targ(i).name]),8000,16,[pwd '/' filelist_targ(i).name]);
    
    % Run SPRO 4.0 to extract features
    sproParam=' -F PCM16 -f 8000 -l 20 -d 10 -w Hamming -p 16 -D -m -v ';
    
    eval(['! ' SPRO sproParam pwd '/' filelist_targ(i).name ' ' pwd '/feats/' filelist_targ(i).name(1:(end-4)) '.prm']);
    
    % Convert features to text file
    eval(['! ' SPROTxt ' -v -o ascii ' pwd '/feats/' filelist_targ(i).name(1:(end-4)) '.prm ' pwd '/feats_txt/' filelist_targ(i).name(1:(end-4)) '.txt']);
    
end

% Start ALIZE
listFile='ExtractFeatures.lst';
% Running NormFeat
eval(['! ' NormFeatExe ' --config ' NormFeatConfig ' --featureFilesPath ./feats/  --inputFeatureFilename ' listFile ' --vectsize ' vectsize ]);

% Running EnergyDetector
eval(['! ' EnergyDetectExe ' --config ' EnergyDetectConfig ' --featureFilesPath ./feats/ --labelFilesPath ./labels/ --inputFeatureFilename ' listFile ' --vectsize ' vectsize ]);

% Running NormFeat AGAIN
eval(['! ' NormFeatExe ' --config ' NormFeatConfig2 ' --labelFilesPath ./labels/ --featureFilesPath ./feats/ --inputFeatureFilename ' listFile ' --vectsize ' vectsize ]);

 
% function ComputeDecisionMetrics(computeTestExe, ...
%     computeTestConfig, GMM_Test, GMM_Train)
clear modelID modelID1 modelID2 model_filelist filelist

eval(['cd ' GMM_Test ])
diary('Scoring.txt');

eval(['cd ' GMM_Train '/gmm'])
model_filelist = dir('10*.gmm'); % Extract filenames from gmms
eval(['cd ' GMM_Test])
filelist = dir('*.wav'); % Extract filenames from audio files

for it = 1:length(model_filelist)
%     model_filelist1=model_filelist(i).name(1:(end-4));
%     model_filelist2=model_filelist1(1:5);
    modelID1{it}=model_filelist(it).name(1:end-4);
end
modelID2=unique(modelID1);
modelID=str2double(modelID2);

%%%%% IMPOSTER LIST GENERATION

fileID8=fopen('Impostor.ndx', 'w+'); % ndx file foriTrainTarget

for k = 1:length(filelist) %39 files (test dir)
   eval('fprintf(fileID8 , ''%s '' , filelist(k).name(1:end-4));') % Write target model filenames (testfile model)
%     currfile=filelist(k).name(1:5);
    for j = 1:length(model_filelist) % 39 speakers (train dir)
        if ~strcmp(model_filelist(j).name(1:end-4),filelist(k).name(1:5))
            eval('fprintf(fileID8 , '' %s '' ,  model_filelist(j).name(1:end-4));') % Speaker ID
        end
    end
    eval('fprintf(fileID8 , ''\n'' );') % new line and new speaker
end
%%%%% GENUINE LIST GENERATION

fileID9=fopen('Target.ndx', 'w+'); % ndx file for TrainTarget

for k = 1:length(filelist) %304 files
    currfile=filelist(k).name(1:5);
    if ~isempty(find(modelID == str2num(currfile)))  % make sure we have a same-subject recording to test against
        
        eval('fprintf(fileID9 , ''%s '' , filelist(k).name(1:end-4));') % Write target model filenames (testfile model)
        
        targetInds = find(modelID == str2num(currfile));
        
        for j = 1:length(targetInds) % 51 speakers
                eval('fprintf(fileID9 , '' %s '' ,  model_filelist(targetInds(j)).name(1:end-4));') % Speaker ID
        end
        eval('fprintf(fileID9 , ''\n'' );') % new line and new speaker
    end
end

for i = 1:2 
    index={'Target.ndx','Impostor.ndx'};
    outputFile={'target.res','impostor.res'};
    eval(['! ' computeTestExe ' --config ' computeTestConfig ' --ndxFilename ' index{i} ' --featureFilesPath ./feats/ --worldModelName ' GMM_Train '/gmm/TRAINED_WORLD --mixtureFilesPath ' GMM_Train '/gmm/ --gender M --outputFilename ' outputFile{i}  ])
    
end

fclose('all');
