% data cleaning
% #1. Find winner

ndpair = 49;
ntrials = 100;
IDrank = zeros(ndpair*2,4); 
%ID | loser(0),winner(1) | final score | valid(0), invalid(1)

% data source: data.csv

for i = 1:ndpair
    p1id = (i-1)*2+1;
    p2id = i*2;
    IDrank(p1id,1) = p1id;
    IDrank(p2id,1) = p2id;
    j = 200*i;
    if raw(j,1) == p1id
        IDrank(p1id,3) = raw(j,9);
        IDrank(p2id,3) = raw(j,10);
    else
        IDrank(p1id,3) = raw(j,10);
        IDrank(p2id,3) = raw(j,9);          
    end
    
    
    if raw(j,9) <= raw(j,10)
        if raw(j,1) == p1id
            IDrank(p1id,2) = 0;
            IDrank(p2id,2) = 1;
        else
            IDrank(p2id,2) = 0;
            IDrank(p1id,2) = 1; 
        end
    else
        if raw(j,1) == p1id
            IDrank(p1id,2) = 1;
            IDrank(p2id,2) = 0;
        else 
            IDrank(p2id,2) = 1;
            IDrank(p1id,2) = 0;
        end
    end
end


%% #2.winnerchoice,loserchoice
winnerchoice = zeros(ndpair,ntrials);
loserchoice = zeros(ndpair,ntrials);
winnerscore = zeros(ndpair,ntrials);
loserscore = zeros(ndpair,ntrials);
for i = 1:length(raw)
    grp_id = (raw(i,1) + mod(raw(i,1),2))/2;
    if IDrank(raw(i,1),2) == 0 %loser
       loserchoice(grp_id,raw(i,3)) = raw(i,4);
       loserscore(grp_id,raw(i,3)) = raw(i,7);
    else
        winnerchoice(grp_id,raw(i,3)) = raw(i,4);
        winnerscore(grp_id,raw(i,3)) = raw(i,7);
    end
end

%% culmulative score
winnerscoreC = zeros(ndpair,ntrials);
loserscoreC = zeros(ndpair,ntrials);
for i = 1:ndpair
for j = 1:ntrials
    if j==1
        winnerscoreC(i,j) = winnerscore(i,j);
        loserscoreC(i,j) = loserscore(i,j);
    else
        winnerscoreC(i,j) = winnerscoreC(i,j-1) + winnerscore(i,j);
        loserscoreC(i,j) = loserscoreC(i,j-1) + loserscore(i,j);
    end
end
end

diff = winnerscoreC - loserscoreC;


%% clean outlier data
% row 13, row 43
IDrank(25:26,4) = 1; %invaid data
IDrank(85:86,4) = 1;

npair = ndpair - 2;
winnerscoreC(43,:) = [];
winnerscore(43,:) = [];
winnerscoreC(13,:) = [];
winnerscore(13,:) = [];
winnerchoice(43,:) = [];
winnerchoice(13,:) = [];

loserscoreC(43,:) = [];
loserscore(43,:) = [];
loserscoreC(13,:) = [];
loserscore(13,:) = [];
loserchoice(43,:) = [];
loserchoice(13,:) = [];

diff(43,:) = [];
diff(13,:) = [];


%% clean subjective report data
 % 
% data source: raw_subjreport.csv

loserreport = zeros(npair,6);
winnerreport = zeros(npair,6);
for i = 1:npair
    if raw_subjreport(2*i-1,2) <= raw_subjreport(2*i,2) %the latter is winner
        idxW = 2*i;
        idxL = 2*i-1;
        % estimate of self choice frequencies (col 1:3/ col 6:8 in original data)
        % estimate of opponent choice frequencies (col 4:6 / col 9:11 in original data)
        winnerreport(raw_subjreport(idxW,1),:) = raw_subjreport(idxW,6:11); 
        loserreport(raw_subjreport(idxL,1),:) = raw_subjreport(idxL,6:11);
    else
        idxW = 2*i-1;
        idxL = 2*i;
        winnerreport(raw_subjreport(idxW,1),:) = raw_subjreport(idxW,6:11);
        loserreport(raw_subjreport(idxL,1),:) = raw_subjreport(idxL,6:11);        
    end
end