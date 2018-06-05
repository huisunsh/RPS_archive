%load choicemat;
winnerchoice = mod(randi(100, [5000,100]),3);
loserchoice = mod(randi(100, [5000,100]),3);
score = zeros(2,5000); % generate 5000 random gameplays

observe_point = 100;

for i = 1:5000
    for j = 1:observe_point
        [d1, d2] = RPS_outcome(winnerchoice(i,j), loserchoice(i,j));
        score(1,i) = score(1,i) + d1;
        score(2,i) = score(2,i) + d2;
    end
end
scorediff1 = abs(score(1,:) - score(2,:));
load choicemat; % load the real data
score = zeros(2,47);
for i = 1:47
    for j = 1:observe_point
        [d1, d2] = RPS_outcome(winnerchoice(i,j), loserchoice(i,j));
        score(1,i) = score(1,i) + d1;
        score(2,i) = score(2,i) + d2;
    end
end
scorediff2 = abs(score(1,:) - score(2,:));
dist1 = fitdist(scorediff1','kernel'); % using kde to estimate distribution
dist2 = fitdist(scorediff2','kernel');
x = 0:1:120;
pdf_random = pdf(dist1, x);
pdf_real = pdf(dist2, x);
figure(); hold on;
plot(x, pdf_random, 'r');
plot(x, pdf_real, 'b');
legend('random', 'real')
xlabel('score difference')
ylabel('pdf')
