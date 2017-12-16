clear all; close all; clc;
% --------------------------------------------------------------------
%                           Run-Time Options
% --------------------------------------------------------------------
%
% User Configurable Options:
clean_setup=1; % Clean out all folders
deltaTestEnable=0; % Energy Derivative Study
optimizationEnable=0; % Parameter Optimization with GA
% segEnable=1; % Segment files (De-session)

emailMe=1; % Send me email when completed run
%
% Algorithms:
%
% Baseline Algorithms:
runGMM=1;
runSV=1;
runSVM=1;
%
% Standard Practice Algorithms
runJFA=0;
runNAP=0;
runPLDA=0;
runANN=0; 
runRBM=0;
%
% Algorithms
runSVMrbf=1;
runCDS=0;
runPLS=1;
runRF=0;
%
% Set-up:
getALIZEpath; % Set all paths and folder structure
clean_folders; % Clean out all folders
segmentFiles; % Segment Files (De-session)
eval(['cd ' workingFolder])


% Run Experiments

if runGMM==1
    GMM_Setup; % Run UBM training only once for all tests
    for trainSeg=1:2
        segEnable=1;
        if trainSeg==1
            testSeg=2;
            trainnum=num2str(trainSeg);
            testnum=num2str(testSeg);
            GMMUBM % Works
            eval(['cd ' workingFolder '/Results/'])
            eval(['save(''GMM_Segmented_' trainnum '_' testnum ''')'])
            eval(['cd ' workingFolder])
        elseif trainSeg==2
            testSeg=1;
            trainnum=num2str(trainSeg);
            testnum=num2str(testSeg);
            GMMUBM % Works
            eval(['cd ' workingFolder '/Results/'])
            eval(['save(''GMM_Segmented_' trainnum '_' testnum ''')'])
            eval(['cd ' workingFolder])
        end
    end
    segEnable=0;
    GMMUBM % Works
    eval(['cd ' workingFolder '/Results/'])
    save('GMM_Unsegmented')
    eval(['cd ' workingFolder])
end


if runSV==1
    segEnable=1;
    eval(['cd ' workingFolder])
    SupVect % Works
    eval(['cd ' workingFolder '/Results/'])
    save('SuperVectors_Segmented')
    eval(['cd ' workingFolder])
    segEnable=0;
    eval(['cd ' workingFolder])
    SupVect % Works
    eval(['cd ' workingFolder '/Results/'])
    save('SuperVectors_Unsegmented')
    eval(['cd ' workingFolder])
end

if runSVM==1
    for trainSeg=1:2
        segEnable=1;
        if trainSeg==1
            testSeg=2;
            trainnum=num2str(trainSeg);
            testnum=num2str(testSeg);
            eval(['cd ' workingFolder])
            SVM % Works
            eval(['cd ' workingFolder '/Results/'])
            eval(['save(''SVM_Segmented_' trainnum '_' testnum ''')'])
            eval(['cd ' workingFolder])
        elseif trainSeg==2
            testSeg=1;
            trainnum=num2str(trainSeg);
            testnum=num2str(testSeg);
            eval(['cd ' workingFolder])
            SVM % Works
            eval(['cd ' workingFolder '/Results/'])
            eval(['save(''SVM_Segmented_' trainnum '_' testnum ''')'])
            eval(['cd ' workingFolder])
        end
    end
    segEnable=0;
    eval(['cd ' workingFolder])
    SVM % Works
    eval(['cd ' workingFolder '/Results/'])
    save('SVM_Unsegmented')
    eval(['cd ' workingFolder])
end

% Clean out all folders to contain only data and results

if clean_setup==1
    warning('OFF')
    for iter=1:length(allDataFiles)
        eval(['cd /home/jenniffer/Desktop/data/' allDataFiles(iter).name])
        contents=dir;
        for iter1=1:length(contents)
            if contents(iter1).isdir && ~strcmpi(contents(iter1).name, '.') && ~strcmpi(contents(iter1).name, '..')
                eval(['cd ' contents(iter1).name])
                try
                    rmdir('labels','s')
                end
                try
                    rmdir('gmm','s')
                end
                try
                    rmdir('feats_txt','s')
                end
                try
                    rmdir('feats','s')
                end
                try
                    rmdir('svm','s')
                end
                try
                    rmdir('sv','s')
                end
                try
                    rmdir('plda','s')
                end
                try
                    rmdir('seg1','s')
                end
                try
                    rmdir('seg2','s')
                end
                
                delete *.txt
                delete *.ndx
                delete *.lst
                delete *.res
                delete *~
                
                cd ../
            end
        end
        cd ../
    end
    
end
warning('ON')

 
% function [SPRO, SPROTxt,NormFeatExe,...
%    NormFeatConfig, NormFeatConfig2, EnergyDetectExe,...
%    EnergyDetectConfig, UBMExe, UBMConfig, GMMExe, GMMConfig,...
%    computeTestExe, computeTestConfig, modelToSvExe,...
%    modelToSvConfig, SvmExe, SVMtrainConfig, ...
%    SVMtestConfig, NapExe, NapConfig]=getALIZEpath(binaryDir)

% Returns all the file directories for SPRO, ALIZE and configuration files
% used in Masters Thesis

% Folder to run
% clc;
% disp('')
% disp('1: Room-Microphone Combinations')
% disp('2: Microphone Distances')
% disp('3: Microphone Types')
% disp('4: Recording_Mediums')
% disp('5: Room Size')
% iter=input('Select folder to run: ');
% clc;
iter=1;

% Files and paths
workingFolder='/home/jenniffer/Desktop/data/'; % Data file path
config='/home/jenniffer/Desktop/ALIZEconfigs/';
% scripts='/home/jenniffer/Desktop/MATLAB_Scripts/'; changed for testing
% july 10
scripts='/home/jenniffer/Desktop/MATLAB_Scripts/';


addpath(genpath(scripts))
addpath(genpath(config));
addpath(genpath(workingFolder));

eval(['cd ' workingFolder])

allDataFiles=dir('*_*');

workingFolder=[workingFolder allDataFiles(iter).name '/'];

if strcmp(allDataFiles(iter).name,'Comb_Room_Mic')    
    UBM_Training='/home/jenniffer/Desktop/data/Comb_Room_Mic/Development/';
    
    folders={'Lg_dir_3ft', 'Lg_omni_far', ...
        'Med_dir_3ft', 'Med_omni_close', 'Med_omni_mid',...
        'Sm_dir_3ft', 'Sm_dir_5ft', 'Sm_omni_far', 'Sm_omni_mid'};
    
elseif strcmp(allDataFiles(iter).name,'Microphone_Distances')
    UBM_Training='/home/jenniffer/Desktop/data/Microphone_Distances/Development/';
    
    folders={'dir_3ft','dir_5ft','omni_close','omni_mid','omni_far'};
    
elseif strcmp(allDataFiles(iter).name,'Microphone_Types')
    UBM_Training='/home/jenniffer/Desktop/data/Microphone_Types/Development/';
    
    folders={'Directional_Mic','Omnidirectional_Mic'};
    
elseif strcmp(allDataFiles(iter).name,'Recording_Mediums')
    UBM_Training='/home/jenniffer/Desktop/data/Recording_Mediums/Development/';
    
    folders={'CDMA','C01U','Directional_Mic','GSM',...
        'Landline','Omnidirectional_Mic','PTT'};
    
elseif strcmp(allDataFiles(iter).name,'Room_Size')
    UBM_Training='/home/jenniffer/Desktop/data/Room_Size/Development/';
    
    folders={'Lg','Med','Sm','OasisConf'};
end


% [SPRO, SPROTxt,NormFeatExe,...
%    NormFeatConfig, NormFeatConfig2, EnergyDetectExe,...
%    EnergyDetectConfig, UBMExe, UBMConfig, GMMExe, GMMConfig,...
%    computeTestExe, computeTestConfig, modelToSvExe,...
%    modelToSvConfig, SvmExe, SVMtrainConfig, ...
%    SVMtestConfig, NapExe, NapConfig]=getALIZEpath(config);
binaryDir=config;
configDir=binaryDir;

%SPRO Directory Paths:
SPRO=[binaryDir 'sfbcep'];
SPROTxt=[binaryDir 'scopy'];

% NormFeat Directory Paths:
NormFeatExe=[binaryDir 'NormFeat.exe'];
NormFeatConfig=[configDir 'NormFeat.cfg'];
NormFeatConfig2=[configDir 'NormFeat_energy.cfg'];

% EnergyDetector Directory Paths:
EnergyDetectExe=[binaryDir 'EnergyDetector.exe'];
EnergyDetectConfig=[configDir 'EnergyDetector.cfg'];

% UBM and GMM Training Directory Paths:
UBMExe=[binaryDir 'TrainWorld.exe'];
UBMConfig=[configDir 'TrainWorld.cfg'];

GMMExe=[binaryDir 'TrainTarget.exe'];
GMMConfig=[configDir 'TrainTarget.cfg'];

computeTestExe=[binaryDir 'ComputeTest.exe'];
computeTestConfig=[configDir 'ComputeTest.cfg'];

modelToSvExe=[binaryDir 'modelToSv.exe'];
modelToSvConfig=[configDir 'modelToSv.cfg'];

SvmExe=[binaryDir 'Svm.exe'];
SVMtrainConfig=[configDir 'Svm_train.cfg'];
SVMtestConfig=[configDir 'Svm_test.cfg'];

NapExe=[binaryDir 'NAPSV'];
NapConfig=[configDir 'NAPSv.cfg'];

% binaryDir_true='/home/jenniffer/Desktop/ALIZEconfigs/';
% configDir_true='/home/jenniffer/Desktop/ALIZEconfigs/';
% 
% binaryDir2='/home/jenniffer/my_SPRO_ALIZE_files/';
% configDir2='/home/jenniffer/my_SPRO_ALIZE_files/';
% 
% binaryDir3='/media/SeaGate/Masters_Work/my_SPRO_ALIZE_files/';
% configDir3='/media/SeaGate/Masters_Work/my_SPRO_ALIZE_files/';

%folders={'/home/jenniffer/Desktop/Biometrics/spkrRecog_GUI/spkr_database/
%train','/home/jenniffer/Desktop/Biometrics/spkrRecog_GUI/spkr_database/train'};

% binaryDir='/home/jenniffer/Desktop/ALIZEconfigs/';
% configDir='/home/jenniffer/Desktop/ALIZEconfigs/';
% UBM_Training=[main '/Development/'];
 
% Break each session recording into two equal segments for testing and
% training

top_level=1;
segment_level=1;

for cond = 1:length(folders)
    
    eval(['cd ' workingFolder folders{cond}]);
    
    if segment_level==1 && top_level==0
        eval('!mkdir seg1')
        eval('!mkdir seg2')
        for seg=1:2
            if seg==1
                segFilename='/seg1/';
            else
                segFilename='/seg2/';
            end
            
            eval(['cd ' workingFolder folders{cond} segFilename]);
            
            eval('!mkdir feats')
            eval('!mkdir feats_txt')
            eval('!mkdir gmm')
            eval('!mkdir labels')
            eval('!mkdir sv')
            eval('!mkdir svm')
            eval('!mkdir plda')
        end
        
    elseif segment_level==1 && top_level==1
        eval('!mkdir seg1')
        eval('!mkdir seg2')
        eval('!mkdir feats')
        eval('!mkdir feats_txt')
        eval('!mkdir gmm')
        eval('!mkdir labels')
        eval('!mkdir sv')
        eval('!mkdir svm')
        eval('!mkdir plda')
        for seg=1:2
            if seg==1
                segFilename='/seg1/';
            else
                segFilename='/seg2/';
            end
            
            eval(['cd ' workingFolder folders{cond} segFilename]);
            
            eval('!mkdir feats')
            eval('!mkdir feats_txt')
            eval('!mkdir gmm')
            eval('!mkdir labels')
            eval('!mkdir sv')
            eval('!mkdir svm')
            eval('!mkdir plda')
        end
        
    else % Assume only top level populates (default)
        eval('!mkdir feats')
        eval('!mkdir feats_txt')
        eval('!mkdir gmm')
        eval('!mkdir labels')
        eval('!mkdir sv')
        eval('!mkdir svm')
        eval('!mkdir plda')
    end
    
    if segment_level==1
        eval(['cd ' workingFolder folders{cond} ]);
        filelist = dir('*.wav');
%         eval(['cd ' workingFolder folders{cond} segFilename]);
        for i = 1:length(filelist)
            
            % read
            y = wavread(filelist(i).name);
            % split
            y1 = y(1:floor(length(y)/2));
            y2 = y(ceil(length(y)/2):end);
            
            % write
            wavwrite(y1,8000,16,[workingFolder folders{cond} '/seg1/' filelist(i).name]);
            wavwrite(y2,8000,16,[workingFolder folders{cond} '/seg2/' filelist(i).name]);
            
            
        end
    end
end

eval(['cd ' UBM_Training])
eval('!mkdir feats')
eval('!mkdir feats_txt')
eval('!mkdir gmm')
eval('!mkdir labels')

 
% % Interpolation of DET curves for EER
function [EER]=calculateEER(detc)
[a,b]=size(detc);
step=1;
x=0:step:a;
 x=x';
y=0:step:a;
 y=y';
chance=[x y];
[x0,y0] = intersections(detc(:,1),detc(:,2),chance(:,1),chance(:,2),0);

EERinds=[find(x0~=50),find(y0~=50)];

if isempty(EERinds)==1
    EER=50;
elseif isempty(EERinds)==0
    EER=x0(EERinds(1,1)); y0(EERinds(1,2));
end
 
