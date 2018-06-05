RPS project

## Models
### Decision Learning Models (Ahn et al., 2008)

Utility $ u(t) = x(t)^{\alpha}$ 

Updating of Expectations:

- Delta learning rule: $ E_j(t) = E_j(t-1) + a  \delta_j(t)  [u(t) - E_j(t-1)] $
- Decay learning rule: $ E_j(t) = a  E_j(t-1) + \delta_j(t)  u(t) $

Choice Rule: $ Pr(D(t+1) = j] = \frac{e^{\theta(t)  E_j(t)}}{\sum_{k=1}^{3}e^{\theta(t) E_k(t)}} $

Sensitivity: $\theta(t)$

- trial-dependent choice rule (TDC): $\theta(t) = (t/10)^c $
- trial-independent choice rule (TIC): $ \theta(t) = 3^c - 1$

Parameters:

1. Shape of utility functions: $\alpha$
2. recency: $a$
3. consistency: $c$

Execution: 

1. Parameter estimation: `main_DL.m` (estimation of four models: DecayTDC, DecayTIC, DeltaTDC, DeltaTIC)
2. Simulation based on estimated parameters: `MSD_DL.m`

### Best Response Model
Best response rule tries to maximize the expected payoff with respect to what the player believes the other player will play and strategically select a move against the believed move of the opponent.

More specifically, in the scenario of a RPS game, a pure best response strategy can be stated as win-stay ($W_{0}$), lose-left-shift ($L{-}$) and tie-right-shift ($T_{+}$) (Wang & Xu, 2014), where left (clockwise) is defined as P->R->S and right (counterclockwise) is defined as R->P->S.

Here, we loose the constraint of pure strategies and implement the best response rule in a probabilistic manner.

Parameters:š

1. $a_1 = P(stay|win)$
2. $a_2 = P(left-shift|lose)$
3. $a_3 = P(right-shift|tie)$

- If a player won in the last trial with move $i$, she will have an $a1$ probability of playing the same move in the next trial and $(1-a_1)/2$ probability of moving to either of the other two moves.
- If a player lost in the last trial with move $i$, she will have $a_2$ probability of choosing the clockwise next move and have $(1-a_2)/2$ probability of either staying or moving to the counterclockwise next move.
- If a player tied in the last trial with move $i$, she will have $a_3$ probability of choosing the counterclockwise next move and have $(1-a_3)/2$ probability of either staying or moving to the clockwise next move.

- MLE: $a_1^* = \frac{\#stay|win}{\#win}$, $a_2^* = \frac{\#left-shift|lose}{\#lose}$, $a_3^* = \frac{\#right-shift|tie}{\#tie}$


Execution: 

1. Parameter estimation: `main_BR.m`
2. Simulation based on estimated parameters: `MSD_BR.m`

### Win-Stay-Lose-Shift Model
Win-stay-lose-shift captures the propensity of players to move either clockwise or counterclockwise after losing while making the same move after winning. Sometimes, it's also referred to as conditional response (Wang, Xu, & Zhou, 2014). 

Parameters:

1. $a_1 = Pr(stay|win)$
2. $a_2 = Pr(right-shift|lose)$
3. $a_3 = Pr(left-shift|lose)$

- If a player won in the last trial, she will have $a_1$ probability of playing the same move again in the next trial and $(1-a_1)/2$ probability of playing either of the two other moves.
- If a player lost in the last trial, she will have $a_2$ probability of shifting to the move counterclockwise to the last move, $a_3$ probability of shifting to the move clockwise to the last move, and $(1-a_2-a_3)$ probability of staying with the same move.
- If a player tied in the last trial, she will have equal probability of playing either of the three moves in the next trial.
- MLE: $a_1 = \frac{\#stay|win}{\#win}$, $a_2 = \frac{\#rs|lose}{\#lose}$, $a_3 = \frac{\#ls|lose}{\#lose}$



Execution:

1. Parameter estimation: `main_WSLS.m`
2. Simulation: `MSD_WSLS.m`

### Probability Tracking/Matching Model
Probability matching model is based on established experimental findings that human beings tend to make decisions with a frequency equivalent to the probability of that decision being the best choice. For example, when asked to predict the color of balls sampling with replacement from an urn with 60 black balls and 40 white balls, a human participant will tend to guess black balls 3 times and white ball 2 times out of five samples. However, the best strategy in this case is to guess black balls all the time.

Here, we use a probability matching model that takes potential limitations of memory span into account. We assume that a person cannot foresee all his/her decisions during the whole game. And therefore, we operationalize the probabilities to be matched as the frequency of choices during the last $k$ trials of game. It should be noted that the probability to be matched can either be players' own choice histories, or their opponents choice histories.

Parameter: Span of memory $k$

Execution:

1. Parameter estimation: `main_prob_matching.m`(MLE) and `main_prob_matching_MSD.m` (min MSD)
2. Simulation: `MSD_prob_matching.m`

### Baseline Model
1. Equiprobability: each move has equal probability of being chosen (equals to 1/3).
2. Nash equilibrium: $Pr(Rock) = 1/2$, $Pr(Scissors) = Pr(Paper) = 1/4$.

Execution: `main_baseline.m`
