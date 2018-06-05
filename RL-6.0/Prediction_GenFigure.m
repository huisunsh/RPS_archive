figure('Units','pixels','Position',[100 100 640 480]);
grid on
hold on
x = 1:ntrials;
hScoreP1 = line(x,ScoreWinnerAverage);
hScoreP2 = line(x,ScoreLoserAverage);
hScoreDiff = line(x,ScoreDiffAverage);


set(hScoreP1,'Color',[.6 .77 .9],'LineWidth',1.5,'LineSmoothing','on');
set(hScoreP2,'Color',[.23 .54 .79],'LineWidth',1.5,'LineSmoothing','on');
set(hScoreDiff, 'Color',[.95 .42 .31],'LineWidth',1.5,'LineSmoothing','on');

hTitle = title('Time Series Score Graph (WIN+1,TIE+0,LOSE-1)');
hXLabel = xlabel('Number of Rounds Played (RepNum)');
hYLabel = ylabel('Score');
%hText = text(10,800,sprintf('\\it{Payoff % Matrix:}',c,cint(2)-c));

hLegend = legend([hScoreP1, hScoreP2, hScoreDiff],'P1Score','P2Score','Accumulate Score Diff','Location','east');
legend('boxoff')

set(gca,'FontName','Verdana');
set([hXLabel,hYLabel],'FontName','Verdana');
set([hLegend,gca],'FontSize',11);
set([hXLabel,hYLabel],'FontSize',11);
set(hTitle,'FontName','Verdana','FontSize',15,'FontWeight','bold');
set(gca,'Box','off','TickDir','out','TickLength','[.02 .02]','LineWidth',1);

set(gcf, 'PaperPositionMode','auto');