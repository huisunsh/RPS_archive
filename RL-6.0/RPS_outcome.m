function [P1Outcome, P2Outcome ] = RPS_outcome(P1choice,P2choice )
    RewardP1 = [2,1,3;3,2,0;1,4,2];
    RewardP2 = RewardP1';
    
    idxP1 = P1choice + 1;
    idxP2 = P2choice + 1;
    
    P1Outcome = RewardP1(idxP1,idxP2);
    P2Outcome = RewardP2(idxP1,idxP2);
    
end