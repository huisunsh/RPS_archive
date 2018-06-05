% calculate retrival probability for an instances related to single decision
function [RetrivalProb1, RetrivalProb2, RetrivalProb3, RetrivalProb4] = CalculateRetrivalProb(Instance1, Instance2, Instance3, Instance4, s) 
    
    Retrival1 = exp(Instance1.ACTIV/(s*sqrt(2)));
    Retrival2 = exp(Instance2.ACTIV/(s*sqrt(2)));
    Retrival3 = exp(Instance3.ACTIV/(s*sqrt(2)));
    Retrival4 = exp(Instance4.ACTIV/(s*sqrt(2)));
    
    Retrival = Retrival1 + Retrival2 + Retrival3 + Retrival4;
    
    RetrivalProb1 = Retrival1/Retrival;
    RetrivalProb2 = Retrival2/Retrival;
    RetrivalProb3 = Retrival3/Retrival;
    RetrivalProb4 = Retrival4/Retrival;