clear;
global consts;

consts.ntrials = 100;
consts.npair = 47;
consts.seed = 173;

load('choicemat.mat');
% model = basleine

nlnLW_empirical_window = zeros(50, consts.npair,1);
nlnLL_empirical_window = zeros(50, consts.npair,1);

for windowsize = 1:50
    for ppt = 1:consts.npair
        W = winnerchoice(ppt,:);
        L = loserchoice(ppt,:); 
        nlnLW_empirical_window(windowsize, ppt,:) = track_opponent(W, L, windowsize, 0.05);
    end
    
    for ppt = 1:consts.npair
        L = loserchoice(ppt,:); 
        W = winnerchoice(ppt,:);
        nlnLL_empirical_window(windowsize, ppt,:) = track_opponent(L, W, windowsize, 0.05);
    end
end
equal_baseline = -log(1/3) * consts.ntrials;

figure(1); hold on;
boxplot(nlnLW_empirical_window');
plot([0,50], [equal_baseline, equal_baseline], 'r--');    
xlabel('Window size')
ylabel('NLL')
title('Winner')

figure(2); hold on;
boxplot(nlnLL_empirical_window');
plot([0,50], [equal_baseline, equal_baseline], 'r--');    
xlabel('Window size')
ylabel('NLL')
title('Loser')

%figure(1); hold on;
%label = {'loser empirical', 'winner empirical', 'loser nash', 'winner nash'};
%boxplot([nlnLL_empirical, nlnLW_empirical,nlnLL_ne, nlnLW_ne], 'Labels', label);

%plot([0,5], [equal_baseline, equal_baseline], 'r--');     
%legend('equal probability baseline', 'Location', 'northwest');
%ylabel('Negative log likelihood');

%savefig('baseline.fig')
%print('baseline','-dpdf')

%header = {'nlnL'};
%paraW = nlnLW_empirical;
%filename1 = sprintf('W%s.csv','baseline');
%fid1 = fopen(filename1,'w');
%fprintf(fid1,'%s\n',header{1,:});
%fclose(fid1);
%dlmwrite(filename1,paraW(1:end,:),'-append'); 

%paraL = nlnLL_empirical;
%filename2 = sprintf('L%s.csv', 'baseline');
%fid2 = fopen(filename2,'w');
%fprintf(fid2,'%s\n',header{1,:});
%fclose(fid2);
%dlmwrite(filename2,paraL(1:end,:),'-append'); 


