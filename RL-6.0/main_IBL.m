global consts;

consts.ntrials = 100;
consts.npair = 46;

load('choicemat.mat');

%TDC
%alpha in [0,1]
%A in [0,1]
%dependent c in [-5 5]
%independent c in [0 5]

seed_size = 20;
initial_seed = rand(seed_size,2);

% intialization for simplex algorithm, dependent C
initial_sample(:,1) = initial_seed(:,1); % 0~1 transform to 0~1
initial_sample(:,2) = initial_seed(:,2); % 0~1 transform to 0~1

% temporary theta, nlnL and exitflag for winners
theta_wt = zeros(seed_size,2);
MSD_wt = zeros(seed_size,1);
exitflag_wt = zeros(seed_size,1);

% temporary theta, nlnL and exitflag for losers
theta_lt = zeros(seed_size,2);
MSD_lt = zeros(seed_size,1);
exitflag_lt = zeros(seed_size,1);

MSDW = zeros(consts.npair,1);
MSDL = zeros(consts.npair,1);
thetaW = zeros(consts.npair,2);
thetaL = zeros(consts.npair,2);
exitflagW = zeros(consts.npair,1);
exitflagL = zeros(consts.npair,1);

modeltofit = {'IBL'};
for ppt = 1:consts.npair
    W = winnerchoice(ppt,:);
    L = loserchoice(ppt,:);                
    LB = [0 0]; %parameter lower bound
    UB = [1 1]; %parameter upper bound

    for j = 1:seed_size % sample 10 starting point for algorithm
        % winner parameter estimation
        f = @(pars) IBL(pars,W,L);
        [theta_wt(j,:), MSD_wt(j,:),exitflag_wt(j)]= ...
            fminsearchbnd(f,initial_sample(j,:),LB,UB);
        % loser parameter estimation
        f = @(pars) IBL(pars,L,W);
        [theta_lt(j,:), MSD_lt(j,:),exitflag_lt(j)]= ...
            fminsearchbnd(f,initial_sample(j,:),LB,UB);
    end

    [MSDW(ppt,:),idx1] = min(MSD_wt);
    [MSDL(ppt,:),idx2] = min(MSD_lt);

    thetaW(ppt,:) = theta_wt(idx1,:);
    thetaL(ppt,:) = theta_lt(idx2,:);

    exitflagW(ppt,:) = exitflag_wt(idx1,:);
    exitflagL(ppt,:) = exitflag_lt(idx2,:);
end


header = {'MSD' 'd' 's' ,'exitflag'};
paraW = horzcat(MSDW, thetaW, exitflagW);
filename1 = sprintf('W%s.csv',modeltofit{:});
fid = fopen(filename1,'w');
fprintf(fid,'%s, %s, %s, %s\n',header{1,:});
fclose(fid);
dlmwrite(filename1,paraW(1:end,:),'-append'); 

paraL = horzcat(MSDL, thetaL, exitflagL);
filename2 = sprintf('L%s.csv',modeltofit{:});
fid = fopen(filename2,'w');
fprintf(fid,'%s, %s, %s, %s\n',header{1,:});
fclose(fid);
dlmwrite(filename2,paraL(1:end,:),'-append'); 
            

