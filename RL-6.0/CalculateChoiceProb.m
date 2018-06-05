% calculate choice probability of an option

function [ChoiceProb1, ChoiceProb2, ChoiceProb3] = CalculateChoiceProb(expectancy1, expectancy2, expectancy3,theta) 
    
    m = max(vertcat(expectancy1,expectancy2,expectancy3));
    Prob1 = exp((expectancy1-m) * theta);
    Prob2 = exp((expectancy2-m) * theta);
    Prob3 = exp((expectancy3-m) * theta);
    
    ChoiceProbAll = Prob1 + Prob2 + Prob3;
    
    ChoiceProb1 = Prob1/ChoiceProbAll;
    ChoiceProb2 = Prob2/ChoiceProbAll;
    ChoiceProb3 = Prob3/ChoiceProbAll;

end
