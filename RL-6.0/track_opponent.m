function [ nlnL] = baseline_empirical (choicedata,opp_choicedata, windowsize, epsilon)
 global consts; 
    unif = [1/3, 1/3, 1/3];
    nlnL = 0;
    for CurrentRepNum=1:consts.ntrials
            empirical = zeros(1,3);
            if CurrentRepNum == 1
                empirical = ones(1,3);
            else
                if CurrentRepNum < windowsize + 2
                    for i = 1:3
                       empirical(i) = sum(opp_choicedata(1:CurrentRepNum-1) == i-1);
                    end
                else
                    for i = 1:3
                       empirical(i) = sum(opp_choicedata(CurrentRepNum - windowsize - 1:CurrentRepNum-1) == i-1);
                    end
                end
            end
            
            empirical = empirical/sum(empirical);
            choiceprob = (1-epsilon) * empirical + epsilon * unif;
            % make choice   
            P1DecisionC = choicedata(CurrentRepNum);
            % Compute log likelihood (LL)
            LLupdate = choiceprob(mod(P1DecisionC-1,3) + 1);
            nlnL = nlnL - log(LLupdate);
    end
end