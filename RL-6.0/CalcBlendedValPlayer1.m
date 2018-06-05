% calculate the blended value of a decision
function BlendedValue = CalcBlendedValPlayer1 (instance1, instance2, instance3, instance4)
    BlendedValue = (instance1.P1O * instance1.Re) + (instance2.P1O * instance2.Re) + (instance3.P1O * instance3.Re)+(instance4.P1O * instance4.Re);