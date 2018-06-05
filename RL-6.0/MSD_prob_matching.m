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
rDiffMat = zeros(consts.nrepeat,consts.ntrials);
WTLMatP1 = zeros(consts.nrepeat,3); %win-tie-lose mat for P1
WTLMatP2 = zeros(consts.nrepeat,3); %win-tie-lose mat for P2
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

% parameters setting
 for ppt = 1:consts.npair
     winner_par = sprintf('W%s.csv','MT_MSD');
     loser_par = sprintf('L%s.csv','MT_MSD');
     ParW = csvread(winner_par,1,0);
     ParL = csvread(loser_par,1,0);
     
    P1lag = ParW(ppt,2);
    P2lag = ParL(ppt,2);

    for CurrentRep = 1:consts.nrepeat

    ChoiceProbP1R = 1/3;
    ChoiceProbP1P = 1/3;
    ChoiceProbP1S = 1/3;
 
    ChoiceProbP2R = 1/3;
    ChoiceProbP1P = 1/3;
    ChoiceProbP2S = 1/3;

    for CurrentTrial=1:consts.ntrials
    % make choice
        if CurrentTrial == 1 %first trial
            initial1 = randi(3);
            initial2 = randi(3);
            P1DecisionS = initial1 - 1; %S- simulated decision
            P2DecisionS = initial2 - 1; 
            
        else %second trial
            % Compute choiceprob for this trial
            if P1lag < CurrentTrial
                P1sumR = sum(rMoveMatP1(CurrentRep,CurrentTrial-P1lag:CurrentTrial-1)==0);
                P1sumP = sum(rMoveMatP1(CurrentRep,CurrentTrial-P1lag:CurrentTrial-1)==1);
                P1sumS = sum(rMoveMatP1(CurrentRep,CurrentTrial-P1lag:CurrentTrial-1)==2);
            else
                P1sumR = sum(rMoveMatP1(CurrentRep,1:CurrentTrial-1)==0);
                P1sumP = sum(rMoveMatP1(CurrentRep,1:CurrentTrial-1)==1);
                P1sumS = sum(rMoveMatP1(CurrentRep,1:CurrentTrial-1)==2);
            end

            if P2lag < CurrentTrial
                P2sumR = sum(rMoveMatP2(CurrentRep,CurrentTrial-P2lag:CurrentTrial-1)==0);
                P2sumP = sum(rMoveMatP2(CurrentRep,CurrentTrial-P2lag:CurrentTrial-1)==1);
                P2sumS = sum(rMoveMatP2(CurrentRep,CurrentTrial-P2lag:CurrentTrial-1)==2);
            else
                P2sumR = sum(rMoveMatP2(CurrentRep,1:CurrentTrial-1)==0);
                P2sumP = sum(rMoveMatP2(CurrentRep,1:CurrentTrial-1)==1);
                P2sumS = sum(rMoveMatP2(CurrentRep,1:CurrentTrial-1)==2);
            end
            [ChoiceProbP1R,ChoiceProbP1P,ChoiceProbP1S] = CalculateChoiceProbMT(P1sumR, P1sumP, P1sumS);
            [ChoiceProbP2R,ChoiceProbP2P,ChoiceProbP2S] = CalculateChoiceProbMT(P2sumR, P2sumP, P2sumS);
            
            xx = rand(1,2);
            if rand(1,1) < ChoiceProbP1R
                P1DecisionS = 0;
            elseif rand(1,1) > 1-ChoiceProbP1S
                P1DecisionS = 1;
            elseif (rand(1,1) > ChoiceProbP1R) & (rand(1,1) < ChoiceProbP1R + ChoiceProbP1P)
                P1DecisionS = 2;
            end
            
            if rand(1,2) < ChoiceProbP2R
                P2DecisionS = 0;
            elseif rand(1,2) > 1-ChoiceProbP2S
                P2DecisionS = 1;
            elseif (rand(1,2) > ChoiceProbP2R) & (rand(1,2) < ChoiceProbP2R + ChoiceProbP2P)
                P2DecisionS = 2;
            end
        end
        
        % Update outcomes, utility and expectancy
        switch P1DecisionS
            case 0,
                switch P2DecisionS
                    case 0,
                        P1OutcomeS = 2; 
                        P2OutcomeS = 2;
                        P1tie = P1tie +1;
                        P2tie = P2tie +1;
                        P1WLT = 3;
                        P2WLT = 3;
                    case 1,
                        P1OutcomeS = 1;
                        P2OutcomeS = 3;
                        P2win = P2win+1;
                        P1WLT = 2;
                        P2WLT = 1;
                    case 2,
                        P1OutcomeS = 3;
                        P2OutcomeS = 1;
                        P1win = P1win +1;
                        P1WLT = 1;
                        P2WLT = 2;
                end;
            case 1,
                switch P2DecisionS
                    case 0,
                        P1OutcomeS = 3;
                        P2OutcomeS = 1;
                        P1win = P1win +1;
                        P1WLT = 1;
                        P2WLT = 2;
                    case 1,
                        P1OutcomeS = 2;
                        P2OutcomeS = 2;
                        P1tie = P1tie +1;
                        P2tie = P2tie +1;
                        P1WLT = 3;
                        P2WLT = 3;
                    case 2,
                        P1OutcomeS = 0;
                        P2OutcomeS = 4;
                        P2win = P2win +1;
                        P1WLT = 2;
                        P2WLT = 1;                     
                end;
            case 2,
                switch P2DecisionS
                    case 0,
                        P1OutcomeS = 1;
                        P2OutcomeS = 3;
                        P2win = P2win +1;
                        P1WLT = 2;
                        P2WLT = 1;
                    case 1,
                        P1OutcomeS = 4;
                        P2OutcomeS = 0;
                        P1win = P1win +1;
                        P1WLT = 1;
                        P2WLT = 2;
                    case 2,
                        P1OutcomeS = 2;
                        P2OutcomeS = 2;
                        P1tie = P1tie +1;
                        P2tie = P2tie +1;
                        P1WLT = 3;
                        P2WLT = 3;
                end
        end
        
    rMoveMatP1(CurrentRep, CurrentTrial) = P1DecisionS;
    rMoveMatP2(CurrentRep, CurrentTrial) = P2DecisionS;
    rScoreMatP1(CurrentRep, CurrentTrial) = P1OutcomeS;
    rScoreMatP2(CurrentRep, CurrentTrial) = P2OutcomeS;
    
    if CurrentTrial == 1
        rDiffMat(CurrentRep, CurrentTrial) = P1OutcomeS - P2OutcomeS;
    else
        rDiffMat(CurrentRep, CurrentTrial) = rDiffMat(CurrentRep, CurrentTrial-1)...
            + P1OutcomeS - P2OutcomeS;
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
    H_decision = {'R%','P%','S%','SD_R','SD_P','SD_S'};
    H_outcome = {'win%','tie%','lose%','SD_win','SD_tie','SD_lose'};
  
     % save data to csv
     for file = {'DecisionP1.csv', 'DecisionP2.csv', 'OutcomeP1.csv',...
            'OutcomeP2.csv', 'Diff.csv', 'Diff_CI.csv'}
        
        fileID = strcat('MT_MSD',file);
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
saveas(f,'MT_MSD','png');

