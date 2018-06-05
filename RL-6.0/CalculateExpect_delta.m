% Calculate Expectancy, delta RL

% globalPos - current simulation step
% AnInstance  - the instance for which the activation is calculated
function Expectancy = CalculateExpect_delta(expectancy, utility, a) 
	
    Expectancy = expectancy + a * (utility - expectancy);
