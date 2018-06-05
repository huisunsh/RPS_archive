function [ChoiceProb1, ChoiceProb2, ChoiceProb3] = CalculateWSLSChoiceProb(PDecision, PWLT, theta1, theta2, theta3 )
switch PWLT
    case 1 %win
        switch PDecision
            case 0 %R
                Rprob = theta1;
                Pprob = (1-theta1)/2;
                Sprob = (1-theta1)/2;
            case 1 %P
                Pprob = theta1;
                Sprob = (1-theta1)/2;
                Rprob = (1-theta1)/2;               
            case 2 %S
                Sprob = theta1;
                Rprob = (1-theta1)/2;
                Pprob = (1-theta1)/2;                   
        end       
    case 2 %lose
        switch PDecision
            case 0 %R
                Sprob = theta2;
                Pprob = theta3;
                Rprob = 1-theta2-theta3;
            case 1 %P
                Rprob = theta2;
                Sprob = theta3;
                Pprob = 1-theta2-theta3;               
            case 2 %S
                Pprob = theta2;
                Rprob = theta3;
                Sprob = 1-theta2-theta3;                   
        end              
    case 3 %tie        
        Sprob = 1/3;
        Pprob = 1/3;
        Rprob = 1/3;                     
end

ChoiceProb1 = Rprob;
ChoiceProb2 = Pprob;
ChoiceProb3 = Sprob;
end
