function [ChoiceProb1, ChoiceProb2, ChoiceProb3 ] = CalculateChoiceProbMT(sum1,sum2,sum3)

    sum = sum1+sum2+sum3;
    ChoiceProb1 = sum1/sum;
    ChoiceProb2 = sum2/sum;
    ChoiceProb3 = sum3/sum;

end

