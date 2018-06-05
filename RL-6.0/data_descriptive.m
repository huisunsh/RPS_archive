load choicemat

% data in choicemat.mat
% npair: valid pairs of participants
% ntrials: total trials of each game
% IDrank: player ID, winner(1)|loser(0), final score, data validity
% (invalid data:1)

% winnerchoice: final winners' choice at each trial
% loserchoice: final losers' choice at each trial 

% winnerscore: final winners' score of each trial
% loserscore: final losers' score of each trial

% winnerscoreC: final winners' cumulative score after each trial
% loserscoreC: final losers' cumulative score after each trial
% scorediff: cumulative differences in scores between winners and losers

% winnerreport: final winners' self report choice frequency of R,P,S after
% the end of the game.
% loserreport: final losers' self report choice frequency of R,P,S after
% the end of the game.

% Notice: Each row of data in files starting with "winner" and "loser" are
% correspondent. Namely row number is equivalent to groupID of each pair.

WMoveProb = zeros(npair,3); %winner Frequency of choosing R, P, S
LMoveProb = zeros(npair,3); %loser Frequency of choosing R, P, S

for i = 1:3
    WMoveProb(:,i) = sum(winnerchoice==(i-1),2);
    LMoveProb(:,i) = sum(loserchoice==(i-1),2);
end

%% Calculate discrepency between estimate and behavioral frequencies
dL = zeros(npair,6);
dW = zeros(npair,6);
LDeviation = zeros(npair,2);
WDeviation = zeros(npair,2);

for ppt = 1:npair
    %differences in estimate and behavioral frequencies of self
    dL(ppt,1:3)= loserreport(ppt,1:3)- LMoveProb(ppt,1:3);
    dW(ppt,1:3) = winnerreport(ppt,1:3) - WMoveProb(ppt,1:3);
    %differences in estimate and behavioral frequencies of opponent
    dL(ppt,4:6) = loserreport(ppt,4:6) - WMoveProb(ppt,1:3);%L guess W
    dW(ppt,4:6) = winnerreport(ppt,4:6) - LMoveProb(ppt,1:3);%W guess L
    %Deviation
    LDeviation(ppt,1) = (sum(dL(ppt,1:3).^2))^0.5; %L estiamte deviation from self
    LDeviation(ppt,2) = (sum(dL(ppt,4:6).^2))^0.5; %L estimate deviation from opponent
    WDeviation(ppt,1) = (sum(dW(ppt,1:3).^2))^0.5;
    WDeviation(ppt,2) = (sum(dW(ppt,4:6).^2))^0.5;
end

%%
Predict_score =  zeros(npair,2);
RewardP1 = [2,1,3;3,2,0;1,4,2];
RewardP2 = RewardP1';

for ppt = 1:npair
    for j = 1:3
        for k = 1:3
            %prediction for winners' final score if both parties act randomly
            %according to their final choice frequencies 
            Predict_score(ppt,1) = Predict_score(ppt,1) + ...
                WMoveProb(ppt,j)*LMoveProb(ppt,k)*RewardP1(j,k);
            %prediction for losers' final score if both parties act randomly
            %according to their final choice frequencies 
            Predict_score(ppt,2) = Predict_score(ppt,2) + ...
                WMoveProb(ppt,j)*LMoveProb(ppt,k)*RewardP2(j,k);
        end
    end
end

Predict_score = Predict_score/10000;