%function [EER]=SVM(mainDir)

%Support Vector Machine with Linear Kernel

%[~, folders, ~, ~,~,...
%    ~, ~, ~,...
%    ~, ~, ~, ~, ~,...
%    ~, ~, ~,...
%    ~, SvmExe, SVMtrainConfig, ...
%    SVMtestConfig, ~, ~]=getALIZEpath(mainDir);

mainDir='/home/jenniffer/Desktop/data/Comb_Room_Mic/';
eval(['cd ' mainDir '/'])

for TrainCond= 1:length(folders)
    for TestCond= 1:length(folders)
        if segEnable==1
            SVM_Train=[mainDir folders{TrainCond} '/seg' trainnum '/' ];
            SVM_Test=[mainDir folders{TestCond} '/seg' testnum '/'];
        else
            SVM_Train=[mainDir folders{TrainCond} '/' ];
            SVM_Test=[mainDir folders{TestCond} '/'];
        end
        
        trainSVM(SvmExe, SVMtrainConfig, SVM_Train)
        
        testSVM(SvmExe, SVMtestConfig, SVM_Train, SVM_Test)
        
        [EER1, detc]=scoreSVM(SVM_Train, SVM_Test, folders);
        
        SVM_EER(TrainCond,TestCond)=EER1;
              
    end
end


 
function []=trainSVM(SvmExe, SVMtrainConfig, SVM_Train)

eval(['cd ' SVM_Train]);

if isdir('svm')==0 || isdir('svm')==1
    mkdir('svm')
% elseif isdir()==1
%     rmdir('svm')
%     mkdir('svm')
end

bckFilesPath=[SVM_Train 'sv/'];
vectorFilesPath=[SVM_Train 'sv/'];
modelFilesPath=[SVM_Train 'svm/'];

genuines=fopen('TrainSVM.ndx', 'w+');
impostors=fopen('blacklistSVM.ndx', 'w+');

eval(['cd ' vectorFilesPath]);
filelist=dir('1*.kl');
eval(['cd ' SVM_Train]);

% Create genuine and impostor training file
for numFile=1:length(filelist)
    eval('fprintf(genuines , ''%s '' , filelist(numFile).name(1:5) );')
    eval('fprintf(genuines , ''%s \n'' , filelist(numFile).name(1:5) );')
end

for numFile=1:length(filelist)
%     eval('fprintf(impostors , ''%s '' , filelist(numFile).name(1:5) );')
    for imposNumFile=1:length(filelist)
        if strcmp(num2str(filelist(imposNumFile).name(1:5)),num2str(filelist(numFile).name(1:5)))==0
            eval('fprintf(impostors , '' %s '' , filelist(imposNumFile).name(1:5) );')
        end
    end
    eval('fprintf(impostors , '' \n'' );')
end
fclose('all');

 
eval(['cd ' SVM_Train '/sv/']);
supVect=dir('*.mat');
supVect=supVect(1).name;
eval(['load ' supVect]);
vsize=length(V);
svsize=num2str(vsize);
eval(['cd ' SVM_Train '/']);

% Train svms
eval(['! ' SvmExe ' --config ' SVMtrainConfig ' --vsize ' num2str(svsize) ' --inputFilename TrainSVM.ndx --inputBckList blacklistSVM.ndx  --bckFilesPath ' bckFilesPath ' --vectorFilesPath ' vectorFilesPath ' --modelFilesPath ' modelFilesPath])


function testSVM(SvmExe, SVMtestConfig, SVM_Train, SVM_Test)

modelFilesPath=[SVM_Train 'svm/'];
bckFilesPath=[SVM_Test 'sv/'];
vectorFilesPath=[SVM_Test 'sv/'];

eval(['cd ' SVM_Train]);
modelList=dir('*.wav');
eval('cd ./sv/');
supVect=dir('*.mat');
supVect=supVect(1).name;
eval(['load ' supVect]);
vsize=length(V);
svsize=num2str(vsize);

eval(['cd ' SVM_Test]);
testList=dir('*.wav');

genuines=fopen('TargetSVM.ndx','w+');
impostors=fopen('ImpostorSVM.ndx','w+');

% Create genuine test files
for numFile=1:length(modelList)
    for testNumFile=1:length(testList)
        if strcmp(num2str(modelList(numFile).name(1:5)), num2str(testList(testNumFile).name(1:5))) ==1% Files in both train model directory and test sv directory
            eval('fprintf(genuines , ''%s '' , modelList(numFile).name(1:5) );')
            eval('fprintf(genuines , ''%s \n'' , modelList(numFile).name(1:5) );')
        end
    end
end

% Create impostor test file 
for numFile=1:length(modelList)
    for testNumFile=1:length(testList)
        if strcmp(num2str(modelList(numFile).name(1:5)), num2str(testList(testNumFile).name(1:5))) ==1% Files are in both train model directory and test sv directory
            eval('fprintf(impostors , ''%s '' , modelList(numFile).name(1:5) );') % UNCOMMENTED
            for iter=1:length(testList)
                if strcmp(num2str(modelList(numFile).name(1:5)), num2str(testList(iter).name(1:5))) ==0 && strcmp(num2str(modelList(numFile).name(1:5)), num2str(testList(iter).name(1:5))) ==0
                    % Files are not the same in model directory and test sv directory
                    eval('fprintf(impostors , ''%s '' , testList(iter).name(1:5) );')
                end
            end
            eval('fprintf(impostors ,  '' \n'');')
        end
    end
end

fclose('all');

for i = 1:2
    index={'TargetSVM.ndx','ImpostorSVM.ndx'};
    outputFile={'targetSVM.res','impostorSVM.res'};
    eval(['! ' SvmExe ' --config ' SVMtestConfig ' --inputFilename ' index{i} ' --outputFilename ' outputFile{i} ' --vsize  ' svsize ' --modelFilesPath ' modelFilesPath ' --bckFilesPath ' bckFilesPath ' --vectorFilesPath ' vectorFilesPath ])
end


function [EER, detc]=scoreSVM(SVM_Train, SVM_Test, folders)

eval(['cd ' SVM_Test]);

extracttargetfile=importdata('targetSVM.res');
targetscores=extracttargetfile.data(:,4);
targetfileid=fopen('extracted_scores_svm_targ.txt', 'w+');
fprintf(targetfileid,'%f \n', targetscores);
user = dlmread('extracted_scores_svm_targ.txt','\n') ;
%     user=user(end-(numtarg-1):end,:);


extractimpostorfile=importdata('impostorSVM.res');
impostorscores=extractimpostorfile.data(:,4);
impostorfileid=fopen('extracted_scores_svm_impos.txt', 'w+');
fprintf(impostorfileid, '%f \n', impostorscores);
impos = dlmread('extracted_scores_svm_impos.txt','\n') ;
%     impos=impos(end-((numimpos*(numimpos-1))-1):end,:);

            
% plot DET curve from extracted scores
luser=length(user(:,1));
limpos=length(impos(:,1));
thresval=sort(user);
detc=zeros(length(thresval),2);
ind=1;

[fartmp,pdtmp] = perfcurve([ones(size(user(:,1))); zeros(size(impos(:,1)))],[user(:,1); impos(:,1)],1);

detc = [fartmp 1-pdtmp];

[EER]=calculateEER(detc);
