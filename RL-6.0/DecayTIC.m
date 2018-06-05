function [ nlnL1] = DecayTIC (theta, winnerchoice, loserchoice)
global consts

     alpha = theta(1); %shape
     a = theta(2); %recency
     c = theta(3); %consistency
 
    ExpecP1 = [0 0 0]; %expectancy of R,P,S
    ChoiceProbP1 = [1/3 1/3 1/3];
    
    P1OutcomeC = 0;
    P2OutcomeC = 0;
    
    P1Utility = 0;

    for CurrentRepNum=1:consts.ntrials
        s = 3^c-1; %sensitivity
            % make choice
            if CurrentRepNum == 1 %first trial
                initial1 = randi(3);
                P1DecisionC = initial1 - 1;
                initial2 = randi(3);
                P2DecisionC = initial2 - 1;

            else %second trial
                % Update Expectancy
                ExpecP1 = ExpecP1*a;
                ExpecP1(P1DecisionC+1) = ExpecP1(P1DecisionC+1) + P1Utility;
                % Compute choiceprob for this trial
                [ChoiceProbP1(1),ChoiceProbP1(2),ChoiceProbP1(3)] = CalculateChoiceProb(ExpecP1(1), ExpecP1(2), ExpecP1(3),s); 
                P1DecisionC = winnerchoice(CurrentRepNum);
                P2DecisionC = loserchoice(CurrentRepNum);
            end

    % Update utility, expectancy
            [P1OutcomeC, P2OutcomeC] = RPS_outcome(P1DecisionC, P2DecisionC);
            % Calculate Utility
            P1Utility = P1OutcomeC^alpha;                      

            % Compute log likelihood (LL)
            if CurrentRepNum == 1 %first trial              
                nlnL1 = log(1/3);  % nlnL:negative of log likelihood
            elseif CurrentRepNum <= consts.ntrials
                Wsum = exp(s*ExpecP1(1)) + exp(s*ExpecP1(2)) + exp(s*ExpecP1(3));              
                LLupdateWinner = log(exp(s*ExpecP1(P1DecisionC+1))/Wsum);
                nlnL1 = nlnL1 - LLupdateWinner;
            end
    end           
end

