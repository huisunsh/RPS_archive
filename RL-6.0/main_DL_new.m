clear all
global consts;

consts.ntrials = 100;
consts.npair = 47;

load('choicemat.mat');

for ppt = 1:consts.npair
    ppt
    seed_size = 10;
    W = winnerchoice(ppt,:);
    L = loserchoice(ppt,:);                
    LB = [0 0 -5]; %parameter lower bound
    UB = [1 1 1]; %parameter upper bound

    initial_sampleD(:,1) = rand(seed_size,1); % 0~1 transform to 0~1
    initial_sampleD(:,2) = rand(seed_size,1); % 0~1 transform to 0~1
    initial_sampleD(:,3) = rand(seed_size,1)*6 - 5; % -5~1 transform to -1~1

    for j = 1:seed_size % sample 10 starting point for algorithm

        % winner parameter estimation
        f = @(pars) DecayTDC_new(pars,W,L);
        [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
            fminsearchbnd(f,initial_sampleD(j,:),LB,UB);
        % loser parameter estimation
        f = @(pars) DecayTDC_new(pars,L,W);
        [theta_lt(j,:), nlnL_lt(j,:),exitflag_lt(j)]= ...
            fminsearchbnd(f,initial_sampleD(j,:),LB,UB);
    end

    [nlnLW(ppt,:),idx1] = min(nlnL_wt);
    [nlnLL(ppt,:),idx2] = min(nlnL_lt);

    thetaW(ppt,:) = theta_wt(idx1,:);
    thetaL(ppt,:) = theta_lt(idx2,:);

end

boxplot([nlnLW, nlnLL])