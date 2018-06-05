RPS project

## Models
### Decision Learning Models (Ahn et al., 2008)

Utility <img src="https://rawgit.com/huisunsh/RPS/master/svgs/0a1a462b13730a5b0e2a89b3923617dd.svg?invert_in_darkmode" align=middle width=86.42205pt height=24.56553pt/> 

Updating of Expectations:

- Delta learning rule: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/79e464a49c5e018e5ce9989438c6effa.svg?invert_in_darkmode" align=middle width=310.061895pt height=24.56553pt/>
- Decay learning rule: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/83463ebb1010074a841131beaf303be4.svg?invert_in_darkmode" align=middle width=215.020245pt height=24.56553pt/>

Choice Rule: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/e25556062561314e6527dfc28a0cd382.svg?invert_in_darkmode" align=middle width=230.147445pt height=36.19407pt/>

Sensitivity: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/4d386aee532e7c2f0f29c48d50041cf0.svg?invert_in_darkmode" align=middle width=26.79633pt height=24.56553pt/>

- trial-dependent choice rule (TDC): <img src="https://rawgit.com/huisunsh/RPS/master/svgs/c07ab99d9735bb9630efdd82561c27d9.svg?invert_in_darkmode" align=middle width=97.735935pt height=24.56553pt/>
- trial-independent choice rule (TIC): <img src="https://rawgit.com/huisunsh/RPS/master/svgs/326ed7bb3dfa42462ebd6b34aef242da.svg?invert_in_darkmode" align=middle width=91.78323pt height=24.56553pt/>

Parameters:

1. Shape of utility functions: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/c745b9b57c145ec5577b82542b2df546.svg?invert_in_darkmode" align=middle width=10.537065pt height=14.10255pt/>
2. recency: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/44bc9d542a92714cac84e01cbbb7fd61.svg?invert_in_darkmode" align=middle width=8.656725pt height=14.10255pt/>
3. consistency: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/3e18a4a28fdee1744e5e3f79d13b9ff6.svg?invert_in_darkmode" align=middle width=7.087278pt height=14.10255pt/>

Execution: 

1. Parameter estimation: `main_DL.m` (estimation of four models: DecayTDC, DecayTIC, DeltaTDC, DeltaTIC)
2. Simulation based on estiamted parameters: `MSD_DL.m`

### Best Response Model
Best response rule tries to maximize the expected payoff with respect to what the player believes the other player will play and strategically select a move against the believed move of the opponent.

More specifically, in the scenario of a RPS game, a pure best response strategy can be stated as win-stay (<img src="https://rawgit.com/huisunsh/RPS/master/svgs/8d819a317e84bcca556d37c989edd7e7.svg?invert_in_darkmode" align=middle width=21.995325pt height=22.38192pt/>), lose-left-shift (<img src="https://rawgit.com/huisunsh/RPS/master/svgs/7a5f6c9b2d4ae619a3077b3a4cdb1ffe.svg?invert_in_darkmode" align=middle width=23.88309pt height=22.38192pt/>) and tie-right-shift (<img src="https://rawgit.com/huisunsh/RPS/master/svgs/d68c64e268fc8738fb5a6bc812d52fc4.svg?invert_in_darkmode" align=middle width=19.623945pt height=22.38192pt/>) (Wang & Xu, 2014), where left (clockwise) is defined as P->R->S and right (counterclockwise) is defined as R->P->S.

Here, we loose the constraint of pure strategies and implement the best response rule in a probabilistic manner.

Parameters：

1. <img src="https://rawgit.com/huisunsh/RPS/master/svgs/cd118d7dc62c729583869e65857a594d.svg?invert_in_darkmode" align=middle width=126.49065pt height=24.56553pt/>
2. <img src="https://rawgit.com/huisunsh/RPS/master/svgs/92498548b832fb2da805c3c94e9f6261.svg?invert_in_darkmode" align=middle width=183.472245pt height=24.56553pt/>
3. <img src="https://rawgit.com/huisunsh/RPS/master/svgs/48f7fed74cafe8cfa64ddfb8b87dd204.svg?invert_in_darkmode" align=middle width=182.904645pt height=24.56553pt/>

- If a player won in the last trial with move <img src="https://rawgit.com/huisunsh/RPS/master/svgs/77a3b857d53fb44e33b53e4c8b68351a.svg?invert_in_darkmode" align=middle width=5.642109pt height=21.60213pt/>, she will have an <img src="https://rawgit.com/huisunsh/RPS/master/svgs/3baa1a9bb3889c13f7fd9dfc0f7b2f47.svg?invert_in_darkmode" align=middle width=16.84518pt height=21.10812pt/> probability of playing the same move in the next trial and <img src="https://rawgit.com/huisunsh/RPS/master/svgs/097d9386aaf4b174f15f3a0e20232f15.svg?invert_in_darkmode" align=middle width=73.37781pt height=24.56553pt/> probability of moving to either of the other two moves.
- If a player lost in the last trial with move <img src="https://rawgit.com/huisunsh/RPS/master/svgs/77a3b857d53fb44e33b53e4c8b68351a.svg?invert_in_darkmode" align=middle width=5.642109pt height=21.60213pt/>, she will have <img src="https://rawgit.com/huisunsh/RPS/master/svgs/2ca230a36892a5d996272ca45a782d16.svg?invert_in_darkmode" align=middle width=15.184785pt height=14.10255pt/> probability of choosing the clockwise next move and have <img src="https://rawgit.com/huisunsh/RPS/master/svgs/c78136f8e0a4d41ed6cb071b641ba0db.svg?invert_in_darkmode" align=middle width=73.37781pt height=24.56553pt/> probability of either staying or moving to the counterclockwise next move.
- If a player tied in the last trial with move <img src="https://rawgit.com/huisunsh/RPS/master/svgs/77a3b857d53fb44e33b53e4c8b68351a.svg?invert_in_darkmode" align=middle width=5.642109pt height=21.60213pt/>, she will have <img src="https://rawgit.com/huisunsh/RPS/master/svgs/788998aa37ce7b850be242e21214e159.svg?invert_in_darkmode" align=middle width=15.184785pt height=14.10255pt/> probability of choosing the counterclockwise next move and have <img src="https://rawgit.com/huisunsh/RPS/master/svgs/b3e48986b4d504288991b79cd25303a9.svg?invert_in_darkmode" align=middle width=73.37781pt height=24.56553pt/> probability of either staying or moving to the clockwise next move.

- MLE: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/aa705f8c4688b5cffdc732052c2a62a5.svg?invert_in_darkmode" align=middle width=102.735765pt height=33.14091pt/>, <img src="https://rawgit.com/huisunsh/RPS/master/svgs/b0d3105556a46e0aad867ccf1336bfe1.svg?invert_in_darkmode" align=middle width=142.5303pt height=33.14091pt/>, <img src="https://rawgit.com/huisunsh/RPS/master/svgs/2b70cc185204d83d749c903d3d663a7d.svg?invert_in_darkmode" align=middle width=142.69992pt height=33.14091pt/>


Execution: 

1. Parameter estimation: `main_BR.m`
2. Simulation based on estiamted parameters: `MSD_BR.m`

### Win-Stay-Lose-Shift Model
Win-stay-lose-shift captures the propensity of players to move either clockwise or counterclockwise after losing while making the same move after winning. Sometiems, it's also referred to as conditional response (Wang, Xu, & Zhou, 2014). 

Paramter:

1. <img src="https://rawgit.com/huisunsh/RPS/master/svgs/d661fe9932a26d940f4f819430722e5a.svg?invert_in_darkmode" align=middle width=134.335905pt height=24.56553pt/>
2. <img src="https://rawgit.com/huisunsh/RPS/master/svgs/49bd70421b87037dcee8914505925c53.svg?invert_in_darkmode" align=middle width=200.018445pt height=24.56553pt/>
3. <img src="https://rawgit.com/huisunsh/RPS/master/svgs/49b000a1fab37522e3a0bf65108f99ad.svg?invert_in_darkmode" align=middle width=191.316345pt height=24.56553pt/>

- If a player won in the last trial, she will have <img src="https://rawgit.com/huisunsh/RPS/master/svgs/8e830a5ab471143f1bb80e525c09bbaa.svg?invert_in_darkmode" align=middle width=15.184785pt height=14.10255pt/> probability of playing the same move again in the next trial and <img src="https://rawgit.com/huisunsh/RPS/master/svgs/097d9386aaf4b174f15f3a0e20232f15.svg?invert_in_darkmode" align=middle width=73.37781pt height=24.56553pt/> probability of playing either of the two other moves.
- If a player lost in the last trial, she will have <img src="https://rawgit.com/huisunsh/RPS/master/svgs/2ca230a36892a5d996272ca45a782d16.svg?invert_in_darkmode" align=middle width=15.184785pt height=14.10255pt/> probability of shifting to the move counterclockwise to the last move, <img src="https://rawgit.com/huisunsh/RPS/master/svgs/788998aa37ce7b850be242e21214e159.svg?invert_in_darkmode" align=middle width=15.184785pt height=14.10255pt/> probability of shifting to the move clockwise to the last move, and <img src="https://rawgit.com/huisunsh/RPS/master/svgs/82d0171235b4003f13fbba3e96e437e1.svg?invert_in_darkmode" align=middle width=93.075345pt height=24.56553pt/> probability of staying with the same move.
- If a player tied in the last trial, she will have euqal probability of playing either of the three moves in the next trial.
- MLE: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/629604f4e41f30a011616b134411ad63.svg?invert_in_darkmode" align=middle width=102.553275pt height=33.14091pt/>, <img src="https://rawgit.com/huisunsh/RPS/master/svgs/3e390d69be12255513d19fc3a42e0f01.svg?invert_in_darkmode" align=middle width=90.39228pt height=33.14091pt/>, <img src="https://rawgit.com/huisunsh/RPS/master/svgs/883ddb44aadf6348c095d11cb6750ba4.svg?invert_in_darkmode" align=middle width=88.158675pt height=33.14091pt/>



Execution:

1. Parameter estimation: `main_WSLS.m`
2. Simulation: `MSD_WSLS.m`

### Probability Tracking/Matching Model
Probability matching model is based on established experimental findings that human beings tend to make decisions with a frequency equivalent to the probability of that decision being the best choice. For example, when asked to predict the color of balls sampling with replacement from an urn with 60 black balls and 40 white balls, a human participant will tend to guess black balls 3 times and white ball 2 times out of five samples. However, the best strategy in this case is to guess black balls all the time.

Here, we use a probability matching model that takes potential limitations of memory span into account. We assume that a person cannot foresee all his/her decisions during the whole game. And therefore, we operationalize the probabilities to be matched as the frequency of choices during the last <img src="https://rawgit.com/huisunsh/RPS/master/svgs/63bb9849783d01d91403bc9a5fea12a2.svg?invert_in_darkmode" align=middle width=9.041505pt height=22.74591pt/> trials of game. It should be noted that the probability to be matched can either be players' own choice histories, or their opponents choice histories.

Parameter: Span of memory <img src="https://rawgit.com/huisunsh/RPS/master/svgs/63bb9849783d01d91403bc9a5fea12a2.svg?invert_in_darkmode" align=middle width=9.041505pt height=22.74591pt/>

Execution:

1. Parameter estimation: `main_prob_matching.m`(MLE) and `main_prob_matching_MSD.m` (min MSD)
2. Simulation: `MSD_prob_matching.m`

### Baseline Model
1. Equiprobability: each move has equal probability of being chosen (equals to 1/3).
2. Nash equilibrium: <img src="https://rawgit.com/huisunsh/RPS/master/svgs/cab085b4e6465f247954d6da0c986df6.svg?invert_in_darkmode" align=middle width=116.44644pt height=24.56553pt/>, <img src="https://rawgit.com/huisunsh/RPS/master/svgs/95f83c2a2fb32ee93072dde4fb96ab19.svg?invert_in_darkmode" align=middle width=242.763345pt height=24.56553pt/>.

Execution: `main_baseline.m`
