
       
xx = 1:consts.ntrials;
hold on
plot_ci(xx,[mean(Diff,1)',DiffCI(1,:)',DiffCI(2,:)'],'PatchColor', 'k', 'PatchAlpha', 0.1, ...
    'MainLineWidth', 2, 'MainLineStyle', '-', 'MainLineColor', 'b',...
    'LineWidth', 1.5, 'LineStyle','--', 'LineColor', 'k');
plot(xx,winnerloser_mean_diff,'r')
hold off
saveas(gcf,model{:},'png');

  