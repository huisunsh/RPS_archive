clear; 
global consts;
consts.npair = 47;
consts.ntrials = 100;
 
load choicemat

winnerLLs = zeros(consts.npair,1);
loserLLs = zeros(consts.npair,1);

for i = 1:consts.npair
    summarymat = zeros(3,3,3); % summary mat conunts event (p1 choice, p2 choice, p1 next choice)
    for j = 1:consts.ntrials - 1
        summarymat(winnerchoice(i,j) + 1,loserchoice(i,j) + 1,winnerchoice(i,j+1) + 1) = ...
            summarymat(winnerchoice(i,j) + 1,loserchoice(i,j) + 1,winnerchoice(i,j+1) + 1)+1;  
    end
    numwin = sum(summarymat(1,3,:) + summarymat(2,1,:) + summarymat(3,2,:));
    numlose = sum(summarymat(1,2,:) + summarymat(2,3,:) + summarymat(3,1,:));
    numtie = sum(summarymat(1,1,:) + summarymat(2,2,:) + summarymat(3,3,:));
    
    numwin_stay = sum(summarymat(1,3,1) + summarymat(2,1,2) + summarymat(3,2,3));
    numlose_ls = sum(summarymat(1,2,3) + summarymat(2,3,1) + summarymat(3,1,2));
    numlose_rs = sum(summarymat(1,2,2) + summarymat(2,3,3) + summarymat(3,1,1));
    
    a1 = numwin_stay/numwin;
    a2 = numlose_rs/numlose;
    a3 = numlose_ls/numlose;
    
    nLL = log(1/3);
    nLL = nLL + numwin_stay * log(a1) + (numwin - numwin_stay) * log((1-a1)/2) ...
        + numlose_rs * log(a2) + numlose_ls * log(a3) + (numlose - numlose_ls - numlose_rs) * log(1-a2-a3) ... ...
        + numtie * log(1/3);

    winnerLLs(i) = -nLL;
end

for i = 1:consts.npair
    summarymat = zeros(3,3,3);
    for j = 1:consts.ntrials - 1
        summarymat(loserchoice(i,j) + 1,winnerchoice(i,j) + 1,loserchoice(i,j+1) + 1) = ...
            summarymat(loserchoice(i,j) + 1,winnerchoice(i,j) + 1,loserchoice(i,j+1) + 1)+1;  
    end
    numwin = sum(summarymat(1,3,:) + summarymat(2,1,:) + summarymat(3,2,:));
    numlose = sum(summarymat(1,2,:) + summarymat(2,3,:) + summarymat(3,1,:));
    numtie = sum(summarymat(1,1,:) + summarymat(2,2,:) + summarymat(3,3,:));
    
    numwin_stay = sum(summarymat(1,3,1) + summarymat(2,1,2) + summarymat(3,2,3));
    numlose_ls = sum(summarymat(1,2,3) + summarymat(2,3,1) + summarymat(3,1,2));
    numlose_rs = sum(summarymat(1,2,2) + summarymat(2,3,3) + summarymat(3,1,1));
     
    a1 = numwin_stay/numwin;
    a2 = numlose_rs/numlose;
    a3 = numlose_ls/numlose;
    
    nLL = log(1/3);
    nLL = nLL + numwin_stay * log(a1) + (numwin - numwin_stay) * log((1-a1)/2) ...
        + numlose_rs * log(a2) + numlose_ls * log(a3) + (numlose - numlose_ls - numlose_rs) * log(1-a2-a3) ... ...
        + numtie * log(1/3);

    loserLLs(i) = -nLL;
end

equal_baseline = -log(1/3) * consts.ntrials;

figure(1); hold on;
label = {'loser WSLS', 'winner WSLS'};
boxplot([loserLLs, winnerLLs], 'Labels', label);
plot([0,3], [equal_baseline, equal_baseline], 'r--');     
