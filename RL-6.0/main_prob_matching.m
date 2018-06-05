clear;
global consts;

consts.ntrials = 100;
consts.npair = 47;
consts.seed = 173;

load('choicemat.mat');
% model = probability matching
% parameters: P1lag, P2lag

% temporary theta and nlnL for winners
lag_wt = zeros(consts.ntrials,1);
nlnL_wt = zeros(consts.ntrials-1,1);

% temporary theta and nlnL for losers
lag_lt = zeros(consts.ntrials,1);
nlnL_lt = zeros(consts.ntrials-1,1);

nlnLW = zeros(consts.npair,1);
nlnLL = zeros(consts.npair,1);
lagW = zeros(consts.npair,1);
lagL = zeros(consts.npair,1);
        
for P1lag = 1:(consts.ntrials-1)
    for ppt = 1:consts.npair
        W = winnerchoice(ppt,:);
        [nlnL_wt(P1lag)] = probability_matching(P1lag,W);
        [nlnLW(ppt,:),idx1] = min(nlnL_wt);
        lagW(ppt,:) = idx1;
    end
end


for P2lag = 1:(consts.ntrials-1)
    for ppt = 1:consts.npair
        L = loserchoice(ppt,:); 
        [nlnL_lt(P2lag)] = probability_matching(P2lag,L);
        [nlnLL(ppt,:),idx2] = min(nlnL_lt);
        lagL(ppt,:) = idx2;
    end
end
    
figure(1); hold on;

equal_baseline = -log(1/3) * consts.ntrials;
boxplot([nlnLL, nlnLW], 'Labels', {'loser prob matching', 'winner prob matching'});
plot([0,3], [equal_baseline, equal_baseline], 'r--');     
legend('equal probability baseline', 'Location', 'southwest');
ylabel('Negative log likelihood');

savefig('prob_matching.fig')
print('prob_matching','-dpdf')



header = {'nlnL' 'Lag'};
paraW = horzcat(nlnLW, lagW);
filename1 = sprintf('W%s.csv','MT');
fid1 = fopen(filename1,'w');
fprintf(fid1,'%s, %s \n',header{1,:});
fclose(fid1);
dlmwrite(filename1,paraW(1:end,:),'-append'); 

paraL = horzcat(nlnLL, lagL);
filename2 = sprintf('L%s.csv', 'MT');
fid2 = fopen(filename2,'w');
fprintf(fid2,'%s, %s\n',header{1,:});
fclose(fid2);
dlmwrite(filename2,paraL(1:end,:),'-append'); 


