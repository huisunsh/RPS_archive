function [ nlnL] = baseline_empirical (choicedata)
    global consts
    nlnL = 0;
    P1sumR = sum(choicedata==0);
    P1sumP = sum(choicedata==1);
    P1sumS = sum(choicedata==2);

    ChoiceProbR = P1sumR/consts.ntrials;
    ChoiceProbP = P1sumP/consts.ntrials;
    ChoiceProbS = P1sumS/consts.ntrials;
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