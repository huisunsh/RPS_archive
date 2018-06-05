clear all
global consts;

consts.ntrials = 100;
consts.npair = 47;
consts.nrepeat = 5000;

load('choicemat.mat');

% temporary mat
rScoreMatP1 = zeros(consts.nrepeat, consts.ntrials);
rScoreMatP2 = zeros(consts.nrepeat, consts.ntrials);
rMoveMatP1 = zeros(consts.nrepeat, consts.ntrials);
rMoveMatP2 = zeros(consts.nrepeat, consts.ntrials);
WTLMatP1 = zeros(consts.nrepeat,3); %win-tie-lose mat for P1
WTLMatP2 = zeros(consts.nrepeat,3); %win-tie-lose mat for P2
rDiffMat = zeros(consts.nrepeat,consts.ntrials);
P1win = 0;
P1tie = 0;
P2win = 0;
P2tie = 0;
% saved mat
DecisionmatP1 = zeros(consts.npair,6);
DecisionmatP2 = zeros(consts.npair,6);
OutcomematP1 = zeros(consts.npair,3);
OutcomematP2 = zeros(consts.npair,3);
Diff = zeros(consts.npair, consts.ntrials);
DiffCI = zeros(2, consts.ntrials);%row 1 upperbound, row 2 lowerbound

% IDrank = zeros(npairs*2,3);

for model = {'DecayTDC','DecayTIC','DeltaTDC','DeltaTIC'}

% parameters setting
 for ppt = 1:consts.npair
     winner_par = sprintf('W%s.csv',model{:});
     loser_par = sprintf('L%s.csv',model{:});
     ParW = csvread(winner_par,1,0);
     ParL = csvread(loser_par,1,0);
     
    alpha1 = ParW(ppt,2);
    alpha2 = ParL(ppt,2);
    a1 = ParW(ppt,3); 
    a2 = ParL(ppt,3);
    c1 = ParW(ppt,4); 
    c2 = ParL(ppt,4);

    for CurrentRep = 1:consts.nrepeat
        
    ExpectancyP1R = 0;
    ExpectancyP1P = 0;
    ExpectancyP1S = 0;
    
    ExpectancyP2R = 0;
    ExpectancyP2P = 0;
    ExpectancyP2S = 0;
    
    ChoiceProbP1R = 0;
    ChoiceProbP1P = 0;
    ChoiceProbP1S = 0;
 
    ChoiceProbP2R = 0;
    ChoiceProbP2P = 0;
    ChoiceProbP2S = 0;

    for CurrentTrial=1:consts.ntrials

      % make choice       
        switch char(model)
            case 'DecayTDC'
                s1 = CalculateChoiceTDC(c1,CurrentTrial); %sensitivity1
                s2 = CalculateChoiceTDC(c2,CurrentTrial); %sensitivity2
            case 'DeltaTDC'
                s1 = CalculateChoiceTDC(c1,CurrentTrial);
                s2 = CalculateChoiceTDC(c2,CurrentTrial);
            case 'DecayTIC'
                s1 = CalculateChoiceTIC(c1);
                s2 = CalculateChoiceTIC(c2);
            case 'DeltaTIC'
                s1 = CalculateChoiceTIC(c1);
                s2 = CalculateChoiceTIC(c2);
            otherwise 
                error('Unknown model');
        end
        
        % make choice
        if CurrentTrial == 1 %first trial
            RandX = randi(3);
            RandY = randi(3);            
            P1DecisionC = RandX - 1;
            P2DecisionC = RandY - 1;   

        else %second trial
            % Compute choiceprob for this trial
            [ChoiceProbP1R,ChoiceProbP1P,ChoiceProbP1S] = CalculateChoiceProb(ExpectancyP1R, ExpectancyP1P, ExpectancyP1S, s1);
            [ChoiceProbP2R,ChoiceProbP2P,ChoiceProbP2S] = CalculateChoiceProb(ExpectancyP2R, ExpectancyP2P, ExpectancyP2S, s2);

            % Player1
            n = rand(1,2);    
            if n(1,1) < ChoiceProbP1R
                P1DecisionC = 0; %R
            elseif n(1,1) > 1-ChoiceProbP1S
                P1DecisionC = 2; %S
            elseif (n(1,1) > ChoiceProbP1R) && (n(1,1) < ChoiceProbP1R + ChoiceProbP1P)
                P1DecisionC = 1; %P
            end

            % Player2
            if n(1,2) < ChoiceProbP2R
                P2DecisionC = 0; %R
            elseif n(1,1) > 1-ChoiceProbP2S
                P2DecisionC = 2; %S
            elseif (n(1,1) > ChoiceProbP2R) && (n(1,1) < ChoiceProbP2R + ChoiceProbP2P)
                P2DecisionC = 1; %P
            end

        end
        
        % Update outcomes, utility and expectancy
        switch P1DecisionC
            case 0,
                switch P2DecisionC
                    case 0,
                        P1OutcomeC = 2; 
                        P2OutcomeC = 2;
                        P1tie = P1tie +1;
                        P2tie = P2tie +1;
                    case 1,
                        P1OutcomeC = 1;
                        P2OutcomeC = 3;
                        P2win = P2win+1;
                    case 2,
                        P1OutcomeC = 3;
                        P2OutcomeC = 1;
                        P1win = P1win +1;
                end;
            case 1,
                switch P2DecisionC
                    case 0,
                        P1OutcomeC = 3;
                        P2OutcomeC = 1;
                        P1win = P1win +1;
                    case 1,
                        P1OutcomeC = 2;
                        P2OutcomeC = 2;
                        P1tie = P1tie +1;
                        P2tie = P2tie +1;
                    case 2,
                        P1OutcomeC = 0;
                        P2OutcomeC = 4;
                        P2win = P2win +1;
                end;
            case 2,
                switch P2DecisionC
                    case 0,
                        P1OutcomeC = 1;
                        P2OutcomeC = 3;
                        P2win = P2win +1;
                    case 1,
                        P1OutcomeC = 4;
                        P2OutcomeC = 0;
                        P1win = P1win +1;
                    case 2,
                        P1OutcomeC = 2;
                        P2OutcomeC = 2;
                        P1tie = P1tie +1;
                        P2tie = P2tie +1;
                end;
        end;

        % Calculate Utility
        P1Utility = P1OutcomeC^alpha1;
        P2Utility = P2OutcomeC^alpha2;      

        % Update Expectancy
        switch char(model)
            case 'DecayTDC'
                f = @(exp,u,a) CalculateExpect_decay(exp,u,a);                
            case 'DecayTIC'
                f = @(exp,u,a) CalculateExpect_decay(exp,u,a);
            case 'DeltaTDC'
                f = @(exp,u,a) CalculateExpect_delta(exp,u,a);
            case 'DeltaTIC'
                f = @(exp,u,a) CalculateExpect_delta(exp,u,a);
            otherwise
                error('Unknown model');
        end
        
        
        switch P1DecisionC
            case 0,
                ExpectancyP1R = f(ExpectancyP1R,P1Utility,a1);
            case 1
                ExpectancyP1P = f(ExpectancyP1P,P1Utility,a1);
            case 2
                ExpectancyP1S = f(ExpectancyP1S,P1Utility,a1);
        end

        switch P2DecisionC
            case 0,
                ExpectancyP2R = f(ExpectancyP2R,P2Utility,a2);
            case 1
                ExpectancyP2P = f(ExpectancyP2P,P2Utility,a2);
            case 2
                ExpectancyP2S = f(ExpectancyP2S,P2Utility,a2);
        end    


    rMoveMatP1(CurrentRep, CurrentTrial) = P1DecisionC;
    rMoveMatP2(CurrentRep, CurrentTrial) = P2DecisionC;
    rScoreMatP1(CurrentRep, CurrentTrial) = P1OutcomeC;
    rScoreMatP2(CurrentRep, CurrentTrial) = P2OutcomeC;
    if CurrentTrial == 1
        rDiffMat(CurrentRep, CurrentTrial) = P1OutcomeC - P2OutcomeC;
    else
        rDiffMat(CurrentRep, CurrentTrial) = rDiffMat(CurrentRep, CurrentTrial-1)...
            + P1OutcomeC - P2OutcomeC;
    end

    end %end current trial
    
    WTLMatP1(CurrentRep,1) = P1win/consts.nrepeat*100;
    WTLMatP1(CurrentRep,2) = P1tie/consts.nrepeat*100;
    WTLMatP1(CurrentRep,3) = consts.ntrials - P1win - P1tie;

    WTLMatP2(CurrentRep,1) = P2win/consts.nrepeat*100;
    WTLMatP2(CurrentRep,2) = P2tie/consts.nrepeat*100;
    WTLMatP2(CurrentRep,3) = consts.ntrials - P2win - P2tie;
    
    end %end current rep

    % write in data 
    % temporary Decision summary for current P1: R%, P%, S%
    rDsumP1(:,1) = sum(rMoveMatP1 == 0,2); %R
    rDsumP1(:,2) = sum(rMoveMatP1 == 1,2); %P
    rDsumP1(:,3) = sum(rMoveMatP1 == 2,2); %S
    
    % sum statistics for P1's decision
    DecisionmatP1(ppt,1:3) = mean(rDsumP1,1); %R, P, S number in each rep
    DecisionmatP1(ppt,4:6) = std(rDsumP1,1); %R_sd, P_sd, S_sd

    % temporary Decision summary for current P2: R%, P%, S%
    rDsumP2(:,1) = sum(rMoveMatP2 == 0,2); %R
    rDsumP2(:,2) = sum(rMoveMatP2 == 1,2); %P
    rDsumP2(:,3) = sum(rMoveMatP2 == 2,2); %S
    
    % sum statistics for P2's decision
    DecisionmatP2(ppt,1:3) = mean(rDsumP2,1); %R, P, S number in each rep
    DecisionmatP2(ppt,4:6) = std(rDsumP2,1); %R_sd, P_sd, S_sd
    
    OutcomematP1(ppt,1:3) = mean(WTLMatP1,1); %average number of win, tie, lose for P1
    OutcomematP2(ppt,1:3) = mean(WTLMatP2,1); %average number of win, tie, lose for P2
    OutcomematP1(ppt,4:6) = std(WTLMatP1,1);
    OutcomematP2(ppt,4:6) = std(WTLMatP2,1);
    
    Diff(ppt,:) = mean(rDiffMat,1);
    DiffCI(1,:) = prctile(Diff,95,1); %diff value of 95%
    DiffCI(2,:) = prctile(Diff,5,1); %diff value of 5%
    
end 
    H_decision = {'R%''P%','S%','SD_R','SD_P','SD_S'};
    H_outcome = {'win%','tie%','lose%','SD_win','SD_tie','SD_lose'};
  
     % save data to csv
     for file = {'DecisionP1.csv', 'DecisionP2.csv', 'OutcomeP1.csv',...
            'OutcomeP2.csv', 'Diff.csv', 'Diff_CI.csv'}
        
        fileID = strcat(model,file);
        fid = fopen(fileID{:}, 'w');
        switch char(file)
            case 'DecisionP1.csv'
                fprintf(fid,'%s,',H_decision{1,1:end-1});
                fprintf(fid,'%s\n',H_decision{1,end});
                fclose(fid);
                dlmwrite(fileID{:}, DecisionmatP1(1:end,:),'-append');
            
            case 'DecisionP2.csv'
                fprintf(fid,'%s,',H_decision{1,1:end-1});
                fprintf(fid,'%s\n',H_decision{1,end});
                fclose(fid);
                dlmwrite(fileID{:},DecisionmatP2(1:end,:),'-append');
                
            case 'OutcomeP1.csv'
                fprintf(fid,'%s,',H_outcome{1,1:end-1});
                fprintf(fid,'%s\n',H_outcome{1,end});
                fclose(fid);
                dlmwrite(fileID{:},OutcomematP1(1:end,:),'-append');
                
            case 'OutcomeP2.csv'
                fprintf(fid,'%s,',H_outcome{1,1:end-1});
                fprintf(fid,'%s\n',H_outcome{1,end});
                fclose(fid);
                dlmwrite(fileID{:},OutcomematP2(1:end,:),'-append');
          
            case 'Diff.csv'
                dlmwrite(fileID{:},Diff);
            case 'Diff_CI.csv'
                dlmwrite(fileID{:},DiffCI);
             
        end
     end

f = figure();       
xx = 1:consts.ntrials;
hold on
plot_ci(xx,[mean(Diff,1)',DiffCI(1,:)',DiffCI(2,:)'],'PatchColor', 'k', 'PatchAlpha', 0.1, ...
    'MainLineWidth', 2, 'MainLineStyle', '-', 'MainLineColor', 'b',...
    'LineWidth', 1.5, 'LineStyle','--', 'LineColor', 'k');
plot(xx,mean(winnerloser_mean_diff,1),'r')
hold off
saveas(f,model{:},'png');

end
