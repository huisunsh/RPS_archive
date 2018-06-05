clear;

global consts
consts.npair = 47;
consts.ntrials = 100;

load('choicemat.mat')

Wshift = zeros(consts.npair,9);
Lshift = zeros(consts.npair,9);

for ppt = 1:consts.npair
    RR=0; RP=0;RS=0; PR=0;PP=0;PS=0;SR=0;SP=0;SS=0;
    RR2=0; RP2=0;RS2=0; PR2=0;PP2=0;PS2=0;SR2=0;SP2=0;SS2=0;
    for j = 1:(consts.ntrials-1)
        switch winnerchoice(ppt,j)
            case 0
                switch winnerchoice(ppt,j+1)
                    case 0, RR = RR +1;
                    case 1, RP = RP +1;
                    case 2, RS = RS +1;
                end
            case 1
                switch winnerchoice(ppt,j+1)
                    case 0, PR = PR +1;
                    case 1, PP = PP +1;
                    case 2, PS = PS +1;
                end
            case 2
                switch winnerchoice(ppt,j+1)
                    case 0, SR = SR +1;
                    case 1, SP = SP +1;
                    case 2, SS = SS +1;
                end
        end
        
        switch loserchoice(ppt,j)
            case 0
                switch loserchoice(ppt,j+1)
                    case 0, RR2 = RR2 +1;
                    case 1, RP2 = RP2 +1;
                    case 2, RS2 = RS2 +1;
                end
            case 1
                switch loserchoice(ppt,j+1)
                    case 0, PR2 = PR2 +1;
                    case 1, PP2 = PP2 +1;
                    case 2, PS2 = PS2 +1;
                end
            case 2
                switch loserchoice(ppt,j+1)
                    case 0, SR2 = SR2 +1;
                    case 1, SP2 = SP2 +1;
                    case 2, SS2 = SS2 +1;
                end
        end        
        
    end
    Wshift(ppt,:) = [RR, RP, RS, PR, PP, PS, SR, SP, SS];
    Lshift(ppt,:) = [RR2, RP2, RS2, PR2, PP2, PS2, SR2, SP2, SS2];
end

%%
figure('Units','pixels','Position',[100 100 640 480]);
grid on
hold on
baseline = zeros(1,consts.ntrials);
x = 1:consts.ntrials;
SD = line(x,scorediff);
base = line(x,baseline);
set(SD,'Color',[.6 .77 .9],'LineWidth',1.5,'LineSmoothing','on');
set(base,'Color',[.23 .54 .79],'LineWidth',1.5,'LineSmoothing','on');
%set(yscissors, 'Color',[.95 .42 .31],'LineWidth',1.5,'LineSmoothing','on');

hTitle = title('Score Differences');
hXLabel = xlabel('Number of Rounds Played (Ntrials)');
hYLabel = ylabel('Score Differences (Winner - Loser)');

%hLegend = legend([WS, LS],'Winner','Loser','Location','northeast');
%legend('boxoff')

set(gca,'FontName','Verdana');
set([hXLabel,hYLabel],'FontName','Verdana');
set(gca,'FontSize',11);
set([hXLabel,hYLabel],'FontSize',11);
set(hTitle,'FontName','Verdana','FontSize',15,'FontWeight','bold');
%set(gca,'Box','off','TickDir','out','TickLength','.02 .02','LineWidth',1);

set(gcf, 'PaperPositionMode','auto');

savefig('scorediff.fig')
print('scorediff','-dpdf')