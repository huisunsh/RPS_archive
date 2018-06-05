% Calculate Expectancy, delta RL

% globalPos - current simulation step
% AnInstance  - the instance for which the activation is calculated
function Expectancy = CalculateExpect_decay(expectancy, utility, a) 
	
    Expectancy = a * expectancy + utility;
