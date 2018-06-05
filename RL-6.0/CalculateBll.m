% globalPos - current simulation step
% AnInstance  - the instance for which the activation is calculated
function Activation = CalculateBll(globalPos, AnInstance, d, s) 
	activationSum = 0.0;

    %if and(not(isempty( AnInstance.USEINDEX)), globalPos > 1)
    if not(isempty( AnInstance.USEINDEX))
        for i = 1:length(AnInstance.USEINDEX)
                activationSum = activationSum + ((globalPos - AnInstance.USEINDEX(i)) ^ (-d));
        end;
         p = 0.0001 + (0.9999-0.0001)*rand;
         epsilon = s * log((1 - p) / p);
        Activation = log(activationSum) + epsilon;
    else
        Activation = -10;
    end;
end
