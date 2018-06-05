function [ nlnL1] = BR (theta, winnerchoice, loserchoice)
 global consts;

 a1 = theta(1); %win stay
 a2 = theta(2); %lose left-shift
 a3 = theta(3); %tie right-shift

 P1WLT = 0; %1-W,2-L,3-T
 P2WLT = 0; %1-W,2-L,3-T

 ChoiceProbP1R = 1/3;
 ChoiceProbP1P = 1/3;
 ChoiceProbP1S = 1/3;

 ChoiceProbP2R = 1/3;
 ChoiceProbP2P = 1/3;
 ChoiceProbP2S = 1/3;
    

    for CurrentRepNum=1:consts.ntrials
            % make choice
            if CurrentRepNum == 1 %first trial
                initial1 = randi(3);
                P1DecisionC = initial1 - 1;
                initial2 = randi(3);
                P2DecisionC = initial2 - 1;

            else %second trial
                % Compute choiceprob for this trial
                [ChoiceProbP1R,ChoiceProbP1P,ChoiceProbP1S] = CalculateBRChoiceProb(P1DecisionC, P1WLT, a1,a2,a3);
                [ChoiceProbP2R,ChoiceProbP2P,ChoiceProbP2S] = CalculateBRChoiceProb(P2DecisionC, P2WLT, a1,a2,a3);
                
                P1DecisionC = winnerchoice(CurrentRepNum);
                P2DecisionC = loserchoice(CurrentRepNum);
            end

    
    switch P1DecisionC
         case 0,
             switch P2DecisionC
                 case 0,
                     P1WLT = 3; %tie
                     P2WLT = 3;
                 case 1,
                     P1WLT = 2; %lose
                     P2WLT = 1; %win
                 case 2,
                     P1WLT = 1;
                     P2WLT = 2;
             end;
         case 1,
             switch P2DecisionC
                 case 0,
                     P1WLT = 1;
                     P2WLT = 2;
                 case 1,
                     P1WLT = 3;
                     P2WLT = 3;
                 case 2,
                     P1WLT = 2;
                     P2WLT = 1;
             end;
          case 2,
             switch P2DecisionC
                 case 0,
                     P1WLT = 2;
                     P2WLT = 1;
                 case 1,
                     P1WLT = 1;
                     P2WLT = 2;
                 case 2,
                     P1WLT = 3;
                     P2WLT = 3;
             end;
     end; 

            % Compute log likelihood (LL)
            if CurrentRepNum == 1 %first trial              
                nlnL1 = 0; 
                nlnL2 = 0; % nlnL:negative of log likelihood
            elseif CurrentRepNum <= consts.ntrials
                switch P2DecisionC
                    case 0, LLupdateLoser = ChoiceProbP2R;
                    case 1, LLupdateLoser = ChoiceProbP2P;
                    case 2, LLupdateLoser = ChoiceProbP2S;
                end
                switch P1DecisionC
                    case 0, LLupdateWinner = ChoiceProbP1R;
                    case 1, LLupdateWinner = ChoiceProbP1P;
                    case 2, LLupdateWinner = ChoiceProbP1S;
                end  
                nlnL1 = nlnL1 - log(LLupdateWinner);
                nlnL2 = nlnL2 - log(LLupdateLoser);
            end
    end      
end

