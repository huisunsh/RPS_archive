function [MSD] = probability_matching_MSD (theta1, choicedata)

  global consts;
  rng(consts.seed);

     P1lag = theta1;
     MSD = 0;

    for CurrentRepNum=1:consts.ntrials
            % make choice
            if CurrentRepNum == 1 %first trial
                initial1 = randi(3);
                P1DecisionS = initial1 - 1; %S- simulated decision

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

                [ChoiceProbR,ChoiceProbP,ChoiceProbS] = CalculateChoiceProbMT(P1sumR, P1sumP, P1sumS);
                
                xx = rand;
                if rand < ChoiceProbR
                    P1DecisionS = 0;
                elseif rand > 1-ChoiceProbS
                    P1DecisionS = 1;
                elseif (rand > ChoiceProbR) && (rand < ChoiceProbR + ChoiceProbP)
                    P1DecisionS = 2;
                end
                
            end
        
        P1DecisionC = choicedata(CurrentRepNum);
        if P1DecisionC ~= P1DecisionS
            MSD = MSD + 1;
        end
        
    end 
end


