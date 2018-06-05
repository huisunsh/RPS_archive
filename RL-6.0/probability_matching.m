function [ nlnL1] = probability_matching (theta1, choicedata)
 global consts;

     P1lag = theta1;
     ChoiceProbP1R = 1/3;
     ChoiceProbP1P = 1/3;
     ChoiceProbP1S = 1/3;
    
%     P1OutcomeC = 0;
%     P2OutcomeC = 0;


    for CurrentRepNum=1:consts.ntrials
            % make choice
            if CurrentRepNum == 1 %first trial
                initial1 = randi(3);
                P1DecisionC = initial1 - 1;

            else %second trial
                % Compute choiceprob for this trial
                if P1lag < CurrentRepNum
                    P1sumR = sum(choicedata(CurrentRepNum-P1lag:CurrentRepNum-1)==0);
                    P1sumP = sum(choicedata(CurrentRepNum-P1lag:CurrentRepNum-1)==1);
                    P1sumS = sum(choicedata(CurrentRepNum-P1lag:CurrentRepNum-1)==2);
                else
                    P1sumR = sum(choicedata(1:CurrentRepNum-1)==0);
                    P1sumP = sum(choicedata(1:CurrentRepNum-1)==1);
                    P1sumS = sum(choicedata(1:CurrentRepNum-1)==2);
                end

                [ChoiceProbP1R,ChoiceProbP1P,ChoiceProbP1S] = CalculateChoiceProbMT(P1sumR, P1sumP, P1sumS);
                P1DecisionC = choicedata(CurrentRepNum);
            end

    % Update utility, expectancy
%      switch P1DecisionC
%          case 0,
%              switch P2DecisionC
%                  case 0,
%                      P1OutcomeC = 2; 
%                      P2OutcomeC = 2;
%                  case 1,
%                      P1OutcomeC = 1;
%                      P2OutcomeC = 3;
%                  case 2,
%                      P1OutcomeC = 4;
%                      P2OutcomeC = 0;
%              end;
%          case 1,
%              switch P2DecisionC
%                  case 0,
%                      P1OutcomeC = 3;
%                      P2OutcomeC = 1;
%                  case 1,
%                      P1OutcomeC = 2;
%                      P2OutcomeC = 2;
%                  case 2,
%                      P1OutcomeC = 1;
%                      P2OutcomeC = 3;
%              end;
%           case 2,
%              switch P2DecisionC
%                  case 0,
%                      P1OutcomeC = 0;
%                      P2OutcomeC = 4;
%                  case 1,
%                      P1OutcomeC = 3;
%                      P2OutcomeC = 1;
%                  case 2,
%                      P1OutcomeC = 2;
%                      P2OutcomeC = 2;
%              end;
%      end;

        
     
     %avoid inf in log calcuation (when prob = 0)
     if ChoiceProbP1R == 0
         ProbRupdate = 0.01;
     else ProbRupdate = ChoiceProbP1R;
     end

     if ChoiceProbP1P == 0
         ProbPupdate = 0.01;
     else ProbPupdate = ChoiceProbP1P;
     end

     if ChoiceProbP1S == 0
         ProbSupdate = 0.01;
     else ProbSupdate = ChoiceProbP1S;
     end
     
            % Compute log likelihood (LL)
            if CurrentRepNum == 1 %first trial              
                nlnL1 = 0;  % nlnL:negative of log likelihood
            elseif CurrentRepNum <= consts.ntrials
                switch P1DecisionC
                    case 0, LLupdate = ProbRupdate;
                    case 1, LLupdate = ProbPupdate;
                    case 2, LLupdate = ProbSupdate;
                end  
                nlnL1 = nlnL1 - log(LLupdate);
            end
    end      
end

