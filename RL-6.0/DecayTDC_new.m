%clear;
%load choicemat
%tic

function [nlnL1] = DecayTDC_new (theta, winnerchoice, loserchoice)
global consts;
 
alpha = theta(1); %shape
a = theta(2); %recency
c = theta(3); %consistency
winnerchoice = winnerchoice(1,:);
loserchoice = loserchoice(1,:);
indicator  = zeros(3,consts.ntrials);
expectancy = zeros(3,consts.ntrials);
for i = 1:3
    indicator(i,winnerchoice == i-1) = 1;
end

RewardP1 = [2,1,3,3,2,0,1,4,2];
reward = RewardP1(winnerchoice * 3 + loserchoice + 1); 
% it is equivalent to using loop, but faster
%for i = 1:100
%    reward(i) = RewardP1(winnerchoice(i) + 1, loserchoice(i)+1);
%end
utility = reward .^ alpha;
utility_indicator = repmat(utility, [3,1]) .* indicator;

for i = 2:consts.ntrials
    expectancy(:,i) = expectancy(:,i-1) * alpha + utility_indicator(:,i-1);
    %I am not sure to use utility_indicator(:,i-1) or utility_indicator(:,i)
    % according to readme it should be i, but I think it should be i-1
end

expectancy = expectancy .* repmat(((1:consts.ntrials) / 10 ) .^ c, [3,1]);
expectancy = expectancy - repmat(max(expectancy), [3,1]);
p = exp(expectancy) ./ repmat(sum(exp(expectancy),1), [3,1]);


ll = 0;
for i = 1:consts.ntrials
    ll = ll + log(p(winnerchoice(i) + 1, i) + 1e-20);
end

%toc

nlnL1 = -ll;

end