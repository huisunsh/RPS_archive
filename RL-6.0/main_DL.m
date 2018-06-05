clear all
global consts;

consts.ntrials = 100;
consts.npair = 47;

load('choicemat.mat');

%TDC
%alpha in [0,1]
%A in [0,1]
%dependent c in [-5 5]
%independent c in [0 5]

seed_size = 20;
initial_seed = rand(seed_size,3);

% intialization for simplex algorithm, dependent C
initial_sampleD(:,1) = initial_seed(:,1); % 0~1 transform to 0~1
initial_sampleD(:,2) = initial_seed(:,2); % 0~1 transform to 0~1
initial_sampleD(:,3) = initial_seed(:,3)*6 - 5; % -5~1 transform to -1~1

% intialization for simplex algorithm, independent C
initial_sampleI(:,1) = initial_seed(:,1); % 0~1 transform to 0~1
initial_sampleI(:,2) = initial_seed(:,2); % 0~1 transform to 0~1
initial_sampleI(:,3) = initial_seed(:,3)*2; % 0~1 transform to 0~2

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


for modeltofit = {'DecayTDC','DecayTIC','DeltaTDC', 'DeltaTIC'};
    switch char(modeltofit)
        case char('DecayTDC')
            for ppt = 1:consts.npair
                W = winnerchoice(ppt,:);
                L = loserchoice(ppt,:);                
                LB = [0 0 -5]; %parameter lower bound
                UB = [1 1 1]; %parameter upper bound
                       
                for j = 1:seed_size % sample 10 starting point for algorithm
                    
                    % optfun = optimset('PlotFcns',@optimplotfval);
                    % f = @(pars) DecayTDC(pars,W,L);
%                     [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
%                         fminsearchbnd(f,initial_sampleD(j,:),LB,UB,optfun);

                    % winner parameter estimation
                    f = @(pars) DecayTDC(pars,W,L);
                    [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
                        fminsearchbnd(f,initial_sampleD(j,:),LB,UB);
                    % loser parameter estimation
                    f = @(pars) DecayTDC(pars,L,W);
                    [theta_lt(j,:), nlnL_lt(j,:),exitflag_lt(j)]= ...
                        fminsearchbnd(f,initial_sampleD(j,:),LB,UB);
                end
                
                
                [nlnLW(ppt,:),idx1] = min(nlnL_wt);
                [nlnLL(ppt,:),idx2] = min(nlnL_lt);

                thetaW(ppt,:) = theta_wt(idx1,:);
                thetaL(ppt,:) = theta_lt(idx2,:);

                exitflagW(ppt,:) = exitflag_wt(idx1,:);
                exitflagL(ppt,:) = exitflag_lt(idx2,:);
            end
            
            
            header = {'nlnL' 'alpha' 'a' 'c','exitflag'};
            paraW = horzcat(nlnLW, thetaW, exitflagW);
            filename1 = sprintf('W%s.csv',modeltofit{:});
            fid = fopen(filename1,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename1,paraW(1:end,:),'-append'); 

            paraL = horzcat(nlnLL, thetaL, exitflagL);
            filename2 = sprintf('L%s.csv',modeltofit{:});
            fid = fopen(filename2,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename2,paraL(1:end,:),'-append'); 
            
            case char('DecayTIC')
                for ppt = 1:consts.npair
                W = winnerchoice(ppt,:);
                L = loserchoice(ppt,:);
                
                LB = [0 0 0];
                UB = [1 1 2];
                
                for j = 1:seed_size % sample 10 starting point for algorithm
                    % winner parameter estimation
                    
                    f = @(pars) DecayTIC(pars,W,L);
                    [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
                        fminsearchbnd(f,initial_sampleI(j,:),LB,UB);
                    % loser parameter estimation
                    f = @(pars) DecayTIC(pars,L,W);
                    [theta_lt(j,:), nlnL_lt(j,:),exitflag_lt(j)]= ...
                        fminsearchbnd(f,initial_sampleI(j,:),LB,UB);
                end
                
                [nlnLW(ppt,:),idx1] = min(nlnL_wt);
                [nlnLL(ppt,:),idx2] = min(nlnL_lt);

                thetaW(ppt,:) = theta_wt(idx1,:);
                thetaL(ppt,:) = theta_lt(idx2,:);

                exitflagW(ppt,:) = exitflag_wt(idx1,:);
                exitflagL(ppt,:) = exitflag_lt(idx2,:);
                end

            header = {'nlnL' 'alpha' 'a' 'c','exitflag'};
            paraW = horzcat(nlnLW, thetaW, exitflagW);
            filename1 = sprintf('W%s.csv',modeltofit{:});
            fid = fopen(filename1,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename1,paraW(1:end,:),'-append'); 

            paraL = horzcat(nlnLL, thetaL, exitflagL);
            filename2 = sprintf('L%s.csv',modeltofit{:});
            fid = fopen(filename2,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename2,paraL(1:end,:),'-append'); 
            
            case char('DeltaTDC')
            for ppt = 1:consts.npair
                W = winnerchoice(ppt,:);
                L = loserchoice(ppt,:);                
                LB = [0 0 -5]; %parameter lower bound
                UB = [1 1 1]; %parameter upper bound
                
                for j = 1:seed_size % sample 10 starting point for algorithm
                    % winner parameter estimation
                   
                    f = @(pars) DeltaTDC(pars,W,L);
                    [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
                        fminsearchbnd(f,initial_sampleD(j,:),LB,UB);
                    % loser parameter estimation
                    f = @(pars) DeltaTDC(pars,L,W);
                    [theta_lt(j,:), nlnL_lt(j,:),exitflag_lt(j)]= ...
                        fminsearchbnd(f,initial_sampleD(j,:),LB,UB);
                end
                
                [nlnLW(ppt,:),idx1] = min(nlnL_wt);
                [nlnLL(ppt,:),idx2] = min(nlnL_lt);

                thetaW(ppt,:) = theta_wt(idx1,:);
                thetaL(ppt,:) = theta_lt(idx2,:);

                exitflagW(ppt,:) = exitflag_wt(idx1,:);
                exitflagL(ppt,:) = exitflag_lt(idx2,:);
            end
            
            
            header = {'nlnL' 'alpha' 'a' 'c','exitflag'};
            paraW = horzcat(nlnLW, thetaW, exitflagW);
            filename1 = sprintf('W%s.csv',modeltofit{:});
            fid = fopen(filename1,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename1,paraW(1:end,:),'-append'); 

            paraL = horzcat(nlnLL, thetaL, exitflagL);
            filename2 = sprintf('L%s.csv',modeltofit{:});
            fid = fopen(filename2,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename2,paraL(1:end,:),'-append'); 
%             
            case char('DeltaTIC')
                for ppt = 1:consts.npair
                W = winnerchoice(ppt,:);
                L = loserchoice(ppt,:);
                
                LB = [0 0 0];
                UB = [1 1 2];
                
                for j = 1:seed_size % sample 10 starting point for algorithm
                    % winner parameter estimation
                   
                    f = @(pars) DeltaTIC(pars,W,L);
                    [theta_wt(j,:), nlnL_wt(j,:),exitflag_wt(j)]= ...
                        fminsearchbnd(f,initial_sampleI(j,:),LB,UB);
                    % loser parameter estimation
                    f = @(pars) DeltaTIC(pars,L,W);
                    [theta_lt(j,:), nlnL_lt(j,:),exitflag_lt(j)]= ...
                        fminsearchbnd(f,initial_sampleI(j,:),LB,UB);
                end
                
                [nlnLW(ppt,:),idx1] = min(nlnL_wt);
                [nlnLL(ppt,:),idx2] = min(nlnL_lt);

                thetaW(ppt,:) = theta_wt(idx1,:);
                thetaL(ppt,:) = theta_lt(idx2,:);

                exitflagW(ppt,:) = exitflag_wt(idx1,:);
                exitflagL(ppt,:) = exitflag_lt(idx2,:);
                end

            header = {'nlnL' 'alpha' 'a' 'c','exitflag'};
            paraW = horzcat(nlnLW, thetaW, exitflagW);
            filename1 = sprintf('W%s.csv',modeltofit{:});
            fid = fopen(filename1,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename1,paraW(1:end,:),'-append'); 

            paraL = horzcat(nlnLL, thetaL, exitflagL);
            filename2 = sprintf('L%s.csv',modeltofit{:});
            fid = fopen(filename2,'w');
            fprintf(fid,'%s, %s, %s, %s, %s\n',header{1,:});
            fclose(fid);
            dlmwrite(filename2,paraL(1:end,:),'-append'); 

    end
end

