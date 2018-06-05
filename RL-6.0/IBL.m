% instances of seuqential dependencies rather than instances of moves

function [MSD1] = IBL (theta, winnerchoice, loserchoice)
global consts

% HUMAN PARAMETERS
d = theta(1); %decay
s = theta(2); %noise
tt = sqrt(2)*s; %tau

% STRUCTURE OF INSTANCE
P1instance = struct('ATTRIBUTE',{},'P2D_LAG',{},'P2D',{},'P1O',{}, 'USEINDEX',{},'ACTIV',{}, 'Re',{});
P2instance = struct('ATTRIBUTE',{},'P1D_LAG',{},'P1D',{},'P2O',{}, 'USEINDEX',{},'ACTIV',{}, 'Re',{});

% Matrix that summarize the simulations over problems and participants
ScoreMatP1 = zeros(1, consts.ntrials);
ScoreMatP2 = zeros(1,consts.ntrials);
MoveMatP1 = zeros(1, consts.ntrials);
MoveMatP2 = zeros(1, consts.ntrials);
MSD1 = 0;
MSD2 = 0;
% Create instances for D1 and D2 - based on the problem
% P1's memory/instance of P2's moves
        %RR
        P1instance(1).P2D_LAG = 0; 
        P1instance(1).P2D = 0; 
        P1instance(1).USEINDEX = [];
        %RP
        P1instance(2).P2D_LAG = 0; 
        P1instance(2).P2D = 1;
        P1instance(2).USEINDEX = [];
        %RS
        P1instance(3).P2D_LAG = 0;
        P1instance(3).P2D = 2; 
        P1instance(3).USEINDEX = [];
        %PR
        P1instance(4).P2D_LAG = 1;
        P1instance(4).P2D = 0;
        P1instance(4).USEINDEX = [];
        %PP
        P1instance(5).P2D_LAG = 1;
        P1instance(5).P2D = 1;
        P1instance(5).USEINDEX = [];
        %PS
        P1instance(6).P2D_LAG = 1;
        P1instance(6).P2D = 2;
        P1instance(6).USEINDEX = [];
        %SR
        P1instance(7).P2D_LAG = 2;
        P1instance(7).P2D = 0;
        P1instance(7).USEINDEX = [];
        %SP
        P1instance(8).P2D_LAG = 2;
        P1instance(8).P2D = 1;
        P1instance(8).USEINDEX = [];
        %SS
        P1instance(9).P2D_LAG = 2;
        P1instance(9).P2D = 2;
        P1instance(9).USEINDEX = [];
% P2's memory/instance of P1's moves
        %RR
        P2instance(1).P1D_LAG = 0; 
        P2instance(1).P1D = 0; 
        P2instance(1).USEINDEX = [];
        %RP
        P2instance(2).P1D_LAG = 0; 
        P2instance(2).P1D = 1;
        P2instance(2).USEINDEX = [];
        %RS
        P2instance(3).P1D_LAG = 0;
        P2instance(3).P1D = 2; 
        P2instance(3).USEINDEX = [];
        %PR
        P2instance(4).P1D_LAG = 1;
        P2instance(4).P1D = 0;
        P2instance(4).USEINDEX = [];
        %PP
        P2instance(5).P1D_LAG = 1;
        P2instance(5).P1D = 1;
        P2instance(5).USEINDEX = [];
        %PS
        P2instance(6).P1D_LAG = 1;
        P2instance(6).P1D = 2;
        P2instance(6).USEINDEX = [];
        %SR
        P2instance(7).P1D_LAG = 2;
        P2instance(7).P1D = 0;
        P2instance(7).USEINDEX = [];
        %SP
        P2instance(8).P1D_LAG = 2;
        P2instance(8).P1D = 1;
        P2instance(8).USEINDEX = [];
        %SS
        P2instance(9).P1D_LAG = 2;
        P2instance(9).P1D = 2;
        P2instance(9).USEINDEX = [];

% Pre populate instances for DECISION-R, DECISION-P and DECISION-S.
        P1instance(10).P1D = 0;
        P1instance(10).P1O = 30;
        P1instance(10).USEINDEX = 0;

        P1instance(11).P1D = 1;
        P1instance(11).P1O = 30;
        P1instance(11).USEINDEX = 0;

        P1instance(12).P1D = 2;
        P1instance(12).P1O = 30;
        P1instance(12).USEINDEX = 0;

        P2instance(10).P1D = 0;
        P2instance(10).P1O = 30;
        P2instance(10).USEINDEX = 0;

        P2instance(11).P1D = 1;
        P2instance(11).P1O = 30;
        P2instance(11).USEINDEX = 0;

        P2instance(12).P1D = 2;
        P2instance(12).P1O = 30;
        P2instance(12).USEINDEX = 0;

% MAIN LOOP FOR A PARTICIPANT IN A PROBLEM
for CurrentTrial=1:consts.ntrials

% Calculate the activation for all instances
for insIndex=1:length(P1instance)
    P1instance(insIndex).ACTIV = CalculateBll(CurrentTrial , P1instance(insIndex), d, s);
    P2instance(insIndex).ACTIV = CalculateBll(CurrentTrial , P2instance(insIndex), d, s);
end;


% Make decision
% In the first trial make decision based on activation of prepopulated instances
if CurrentTrial==1  % First trial
    %Best response
    P1DecisionS = IBL_BR(P1instance(10).ACTIV, P1instance(11).ACTIV, P1instance(12).ACTIV);
    P2DecisionS = IBL_BR(P2instance(10).ACTIV, P2instance(11).ACTIV, P2instance(12).ACTIV);
    % Get outcomes for Decision 1 and Update the instance
    [P1OutcomeS, P2OutcomeS] = RPS_outcome(P1DecisionS, P2DecisionS);
elseif CurrentTrial == 2
    %Best response
    P1DecisionS = IBL_BR(P1instance(10).ACTIV, P1instance(11).ACTIV, P1instance(12).ACTIV);
    P2DecisionS = IBL_BR(P2instance(10).ACTIV, P2instance(11).ACTIV, P2instance(12).ACTIV);
    % Get outcomes for Decision 1 and Update the instance
    [P1OutcomeS, P2OutcomeS] = RPS_outcome(P1DecisionS, P2DecisionS);
    switch MoveMatP2(1, CurrentTrial - 1) %P1's storage of P2's move
        case 0,
            switch P2DecisionS
                case 0, P1instance(1).USEINDEX(end+1,:) = CurrentTrial; P1instance(1).P1O = P1OutcomeS;
                case 1, P1instance(2).USEINDEX(end+1,:) = CurrentTrial; P1instance(2).P1O = P1OutcomeS;
                case 2, P1instance(3).USEINDEX(end+1,:) = CurrentTrial; P1instance(3).P1O = P1OutcomeS;
            end;
        case 1,
            switch P2DecisionS
                case 0, P1instance(4).USEINDEX(end+1,:) = CurrentTrial; P1instance(4).P1O = P1OutcomeS;
                case 1, P1instance(5).USEINDEX(end+1,:) = CurrentTrial; P1instance(5).P1O = P1OutcomeS;
                case 2, P1instance(6).USEINDEX(end+1,:) = CurrentTrial; P1instance(6).P1O = P1OutcomeS; 
            end;
        case 2,
            switch P2DecisionS
                case 0, P1instance(7).USEINDEX(end+1,:) = CurrentTrial; P1instance(7).P1O = P1OutcomeS;
                case 1, P1instance(8).USEINDEX(end+1,:) = CurrentTrial; P1instance(8).P1O = P1OutcomeS;
                case 2, P1instance(9).USEINDEX(end+1,:) = CurrentTrial; P1instance(9).P1O = P1OutcomeS;
            end;
    end;

    switch MoveMatP1(1, CurrentTrial - 1) %P2's storage of P1's move
        case 0,
            switch P1DecisionS
                case 0, P2instance(1).USEINDEX(end+1,:) = CurrentTrial; P2instance(1).P2O = P2OutcomeS;
                case 1, P2instance(2).USEINDEX(end+1,:) = CurrentTrial; P2instance(2).P2O = P2OutcomeS;
                case 2, P2instance(3).USEINDEX(end+1,:) = CurrentTrial; P2instance(3).P2O = P2OutcomeS;
            end;
        case 1,
            switch P1DecisionS
                case 0, P2instance(4).USEINDEX(end+1,:) = CurrentTrial; P2instance(4).P2O = P2OutcomeS;
                case 1, P2instance(5).USEINDEX(end+1,:) = CurrentTrial; P2instance(5).P2O = P2OutcomeS;
                case 2, P2instance(6).USEINDEX(end+1,:) = CurrentTrial; P2instance(6).P2O = P2OutcomeS;
            end;
        case 2,
            switch P1DecisionS
                case 0, P2instance(7).USEINDEX(end+1,:) = CurrentTrial; P2instance(7).P2O = P2OutcomeS;
                case 1, P2instance(8).USEINDEX(end+1,:) = CurrentTrial; P2instance(8).P2O = P2OutcomeS;
                case 2, P2instance(9).USEINDEX(end+1,:) = CurrentTrial; P2instance(9).P2O = P2OutcomeS;
            end;
    end;
    
    
else % third trial 
    P1DecisionS = IBL_BR(BlendedValuePlayer1R, BlendedValuePlayer1P, BlendedValuePlayer1S);
    P2DecisionS = IBL_BR(BlendedValuePlayer2R, BlendedValuePlayer2P, BlendedValuePlayer2S);
    % get outcomes
    [P1OutcomeS, P2OutcomeS] = RPS_outcome(P1DecisionS, P2DecisionS);
    % update instance use
    switch MoveMatP2(1, CurrentTrial - 1) %P1's storage of P2's move
        case 0,
            switch P2DecisionS
                case 0, P1instance(1).USEINDEX(end+1,:) = CurrentTrial; P1instance(1).P1O = P1OutcomeS;
                case 1, P1instance(2).USEINDEX(end+1,:) = CurrentTrial; P1instance(2).P1O = P1OutcomeS;
                case 2, P1instance(3).USEINDEX(end+1,:) = CurrentTrial; P1instance(3).P1O = P1OutcomeS;
            end;
        case 1,
            switch P2DecisionS
                case 0, P1instance(4).USEINDEX(end+1,:) = CurrentTrial; P1instance(4).P1O = P1OutcomeS;
                case 1, P1instance(5).USEINDEX(end+1,:) = CurrentTrial; P1instance(5).P1O = P1OutcomeS;
                case 2, P1instance(6).USEINDEX(end+1,:) = CurrentTrial; P1instance(6).P1O = P1OutcomeS; 
            end;
        case 2,
            switch P2DecisionS
                case 0, P1instance(7).USEINDEX(end+1,:) = CurrentTrial; P1instance(7).P1O = P1OutcomeS;
                case 1, P1instance(8).USEINDEX(end+1,:) = CurrentTrial; P1instance(8).P1O = P1OutcomeS;
                case 2, P1instance(9).USEINDEX(end+1,:) = CurrentTrial; P1instance(9).P1O = P1OutcomeS;
            end;
    end;

    switch MoveMatP1(1, CurrentTrial - 1) %P2's storage of P1's move
        case 0,
            switch P1DecisionS
                case 0, P2instance(1).USEINDEX(end+1,:) = CurrentTrial; P2instance(1).P2O = P2OutcomeS;
                case 1, P2instance(2).USEINDEX(end+1,:) = CurrentTrial; P2instance(2).P2O = P2OutcomeS;
                case 2, P2instance(3).USEINDEX(end+1,:) = CurrentTrial; P2instance(3).P2O = P2OutcomeS;
            end;
        case 1,
            switch P1DecisionS
                case 0, P2instance(4).USEINDEX(end+1,:) = CurrentTrial; P2instance(4).P2O = P2OutcomeS;
                case 1, P2instance(5).USEINDEX(end+1,:) = CurrentTrial; P2instance(5).P2O = P2OutcomeS;
                case 2, P2instance(6).USEINDEX(end+1,:) = CurrentTrial; P2instance(6).P2O = P2OutcomeS;
            end;
        case 2,
            switch P1DecisionS
                case 0, P2instance(7).USEINDEX(end+1,:) = CurrentTrial; P2instance(7).P2O = P2OutcomeS;
                case 1, P2instance(8).USEINDEX(end+1,:) = CurrentTrial; P2instance(8).P2O = P2OutcomeS;
                case 2, P2instance(9).USEINDEX(end+1,:) = CurrentTrial; P2instance(9).P2O = P2OutcomeS;
            end;
    end;
    % Calculate P1's retrival probability/prediction for P2's next move
    [P1instance(1).Re, P1instance(4).Re, P1instance(7).Re, P1instance(10).Re] = CalculateRetrivalProb(P1instance(1), P1instance(4), P1instance(7),P1instance(10), s); %P1's guess that P2's next move is R
    [P1instance(2).Re, P1instance(5).Re, P1instance(8).Re, P1instance(11).Re] = CalculateRetrivalProb(P1instance(2), P1instance(5), P1instance(8),P1instance(11), s); %P
    [P1instance(3).Re, P1instance(6).Re, P1instance(9).Re, P1instance(12).Re] = CalculateRetrivalProb(P1instance(3), P1instance(6), P1instance(9),P1instance(12), s); %S

    BlendedValuePlayer1R = CalcBlendedValPlayer1 (P1instance(1), P1instance(4), P1instance(7), P1instance(10)); %P1's blended guess of P2's next move
    BlendedValuePlayer1P = CalcBlendedValPlayer1 (P1instance(2), P1instance(5), P1instance(8), P1instance(11));
    BlendedValuePlayer1S = CalcBlendedValPlayer1 (P1instance(3), P1instance(6), P1instance(9), P1instance(12));

% Calculate P2's retrival probability/prediction for P1's next move
    [P2instance(1).Re, P2instance(4).Re, P2instance(7).Re, P2instance(10).Re] = CalculateRetrivalProb(P2instance(1), P2instance(4), P2instance(7),P2instance(10), s); %P2's guess that P1's next move is R
    [P2instance(2).Re, P2instance(5).Re, P2instance(8).Re, P2instance(11).Re] = CalculateRetrivalProb(P2instance(2), P2instance(5), P2instance(8),P2instance(11), s); %P
    [P2instance(3).Re, P2instance(6).Re, P2instance(9).Re, P2instance(12).Re] = CalculateRetrivalProb(P2instance(3), P2instance(6), P2instance(9),P2instance(12), s); %S

    BlendedValuePlayer2R = CalcBlendedValPlayer2 (P2instance(1), P2instance(4), P2instance(7), P2instance(10));
    BlendedValuePlayer2P = CalcBlendedValPlayer2 (P2instance(2), P2instance(5), P2instance(8), P2instance(11));
    BlendedValuePlayer2S = CalcBlendedValPlayer2 (P2instance(3), P2instance(6), P2instance(9), P2instance(12));
    % need to check for outcome update
end;

    

% Update the RunMat matrix for this pair of participants
% RunMat(CurrentRepNum,:) = [CurrentRepNum, P1DecisionC, P2DecisionC, P1OutcomeC, P2OutcomeC];
MoveMatP1(1, CurrentTrial) = P1DecisionS;
MoveMatP2(1, CurrentTrial) = P1DecisionS;
ScoreMatP1(1, CurrentTrial) = P1OutcomeS;
ScoreMatP2(1, CurrentTrial) = P2OutcomeS;
P1Decision = winnerchoice(1, CurrentTrial);
P2Decision = loserchoice(1, CurrentTrial);
if P1Decision ~= P1DecisionS
    MSD1 = MSD1 + 1;
end
if P2Decision ~= P2DecisionS
    MSD2 = MSD2 + 1;
end 

end

