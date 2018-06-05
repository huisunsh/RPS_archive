function [ nlnL] = baseline_ne (choicedata)
    global consts
    nlnL = 0;
    ChoiceProbR = 1/2;
    ChoiceProbP = 1/4;
    ChoiceProbS = 1/4;
    for CurrentRepNum=1:consts.ntrials
            % make choice   
            P1DecisionC = choicedata(CurrentRepNum);
            % Compute log likelihood (LL)
            switch P1DecisionC
                case 0, LLupdate = ChoiceProbR;
                case 1, LLupdate = ChoiceProbP;
                case 2, LLupdate = ChoiceProbS;
            end  
            nlnL = nlnL - log(LLupdate);
    end
end