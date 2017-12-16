function [ EER ]=Scoring(computeTestExe, computeTestConfig, GMM_Test,...
    GMM_Train)

% Extract the scores from a ALIZE score files
eval(['cd ' GMM_Test])
extractImpostorFile=importdata('impostor.res');
ImpostorScores=extractImpostorFile.data;
ImpostorFileID=fopen('extracted_scores_impos.txt', 'w+');
fprintf(ImpostorFileID, '%f \n', ImpostorScores);
impos = dlmread('extracted_scores_impos.txt','\n') ;

extractTargetFile=importdata('target.res'); 
TargetScores=extractTargetFile.data;
TargetFileID=fopen('extracted_scores_targ.txt', 'w+');
fprintf(TargetFileID,'%f \n', TargetScores);
user = dlmread('extracted_scores_targ.txt','\n') ;

% Plot DET Curve from extracted scores
% user = dlmread('extracted_scores_targ.txt','\n') ;
luser=length(user(:,1));
% impos = dlmread('extracted_scores_impos.txt','\n') ;
limpos=length(impos(:,1));
thresval=sort(user);
detc=zeros(length(thresval),2);
ind=1;


[farTMP,pdTMP] = perfcurve([ones(size(user(:,1))); zeros(size(impos(:,1)))],[user(:,1); impos(:,1)],1);

detc = [farTMP 1-pdTMP];
