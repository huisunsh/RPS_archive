global consts;

consts.ntrials = 100;
consts.npair = 47;

load('choicemat.mat');

%WIN STAY [a1]
%LOSE LEFT SHIFT: clockwise, PRS [a2]
%TIE RIGHT SHIFT: counterclockwise RPS [a3]

seed_size = 20;
initial_seed = rand(seed_size,3);

% temporary theta, nlnL and exitflag for winners
theta_wt = zeros(seed_size,3);
nlnL_wt = zeros(seed_size,1);
exitflag_wt = zeros(seed_size,1);

% temporary theta, nlnL and exitflag for losers
theta_lt = zeros(seed_size,3);
nlnL_lt = zeros(seed_size,1);
exitflag_lt = zeros(seed_size,1);

nlnLW = zeros(consts.npair,1);
nlnLL = zeros(consts.npair,1);
thetaW = zeros(consts.npair,3);
thetaL = zeros(consts.npair,3);
exitflagW = zeros(consts.npair,1);
exitflagL = zeros(consts.npair,1);

% model = best response (BR)

for ppt = 1:consts.npair
    W = winnerchoice(ppt,:);
    L = loserchoice(ppt,:);                
    LB = [0 0 0]; %parameter lower bound
    UB = [1 1 1]; %parameter upper bound

    for j = 1:seed_size % sample some starting points for algorithm
        % winner parameter estimation
        f = @(pars) BR(pars,W,L);
        [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
            fminsearchbnd(f,initial_seed(j,:),LB,UB);
        % loser parameter estimation
        f = @(pars) BR(pars,L,W);
        [theta_lt(j,:), nlnL_lt(j,:),exitflag_lt(j)]= ...
            fminsearchbnd(f,initial_seed(j,:),LB,UB);
    end

    [nlnLW(ppt,:),idx1] = min(nlnL_wt);
    [nlnLL(ppt,:),idx2] = min(nlnL_lt);

    thetaW(ppt,:) = theta_wt(idx1,:);
    thetaL(ppt,:) = theta_lt(idx2,:);

    exitflagW(ppt,:) = exitflag_wt(idx1,:);
    exitflagL(ppt,:) = exitflag_lt(idx2,:);
end


header = {'nlnL' 'a1_win' 'a2_lose' 'a3_tie','exitflag'};
paraW = horzcat(nlnLW, thetaW, exitflagW);
filename1 = sprintf('W%s.csv','BR');
fid1 = fopen(filename1,'w');
fprintf(fid1,'%s, %s, %s, %s, %s\n',header{1,:});
fclose(fid1);
dlmwrite(filename1,paraW(1:end,:),'-append'); 

paraL = horzcat(nlnLL, thetaL, exitflagL);
filename2 = sprintf('L%s.csv','BR');
fid2 = fopen(filename2,'w');
fprintf(fid2,'%s, %s, %s, %s, %s\n',header{1,:});
fclose(fid2);
dlmwrite(filename2,paraL(1:end,:),'-append'); 

figure(2);
label = {'loser BR', 'winner BR'};
boxplot([nlnLL, nlnLW], 'Labels', label);
hold on 
equal_baseline = -log(1/3) * consts.ntrials;
plot([0,3], [equal_baseline, equal_baseline],'r--');

savefig('BR.fig')
print('BR','-dpdf')

