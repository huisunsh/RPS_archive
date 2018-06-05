global consts;

consts.ntrials = 100;
consts.npair = 47;
consts.seed = 173;

load('choicemat.mat');
% model = probability matching
% parameters: P1lag, P2lag

% temporary theta and nlnL for winners
lag_wt = zeros(consts.ntrials,1);
MSD_wt = zeros(consts.ntrials-1,1);

% temporary theta and nlnL for losers
lag_lt = zeros(consts.ntrials,1);
MSD_lt = zeros(consts.ntrials-1,1);

MSDW = zeros(consts.npair,1);
MSDL = zeros(consts.npair,1);
lagW = zeros(consts.npair,1);
lagL = zeros(consts.npair,1);


for ppt = 1:consts.npair
    for P1lag = 1:(consts.ntrials-1)
        W = winnerchoice(ppt,:);
        [MSD_wt(P1lag,1)] = probability_matching_MSD(P1lag,W);
        [MSDW(ppt,:),idx1] = min(MSD_wt);
        lagW(ppt,:) = idx1;
    end


    for P2lag = 1:(consts.ntrials-1)
        L = loserchoice(ppt,:); 
        [MSD_lt(P2lag,1)] = probability_matching_MSD(P2lag,L);
        [MSDL(ppt,:),idx2] = min(MSD_lt);
        lagL(ppt,:) = idx2;
    end
end



header = {'MSD' 'Lag'};
paraW = horzcat(MSDW, lagW);
filename1 = sprintf('W%s.csv','MT_MSD');
fid1 = fopen(filename1,'w');
fprintf(fid1,'%s, %s \n',header{1,:});
fclose(fid1);
dlmwrite(filename1,paraW(1:end,:),'-append'); 

paraL = horzcat(MSDL, lagL);
filename2 = sprintf('L%s.csv', 'MT_MSD');
fid2 = fopen(filename2,'w');
fprintf(fid2,'%s, %s\n',header{1,:});
fclose(fid2);
dlmwrite(filename2,paraL(1:end,:),'-append'); 


