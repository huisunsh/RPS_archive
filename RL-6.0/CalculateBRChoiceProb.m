function [ChoiceProb1, ChoiceProb2, ChoiceProb3] = CalculateBRChoiceProb(PDecision, PWLT, theta1, theta2, theta3 )
switch PWLT
    case 1 %win-stay
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
    case 2 %lose-left-shift
        switch PDecision
            case 0 %R
                Sprob = theta2;
                Pprob = (1-theta2)/2;
                Rprob = (1-theta2)/2;
            case 1 %P
                Rprob = theta2;
                Sprob = (1-theta2)/2;
                Pprob = (1-theta2)/2;               
            case 2 %S
                Pprob = theta2;
                Rprob = (1-theta2)/2;
                Sprob = (1-theta2)/2;                   
        end              
    case 3 %tie-right-shift        
        switch PDecision
            case 0 %R
                Pprob = theta3;
                Sprob = (1-theta3)/2;
                Rprob = (1-theta3)/2;
            case 1 %P
                Sprob = theta3;
                Rprob = (1-theta3)/2;
                Pprob = (1-theta3)/2;               
            case 2 %S
                Rprob = theta3;
                Pprob = (1-theta3)/2;
                Sprob = (1-theta3)/2;                   
        end          
end

ChoiceProb1 = Rprob;
ChoiceProb2 = Pprob;
ChoiceProb3 = Sprob;
end
