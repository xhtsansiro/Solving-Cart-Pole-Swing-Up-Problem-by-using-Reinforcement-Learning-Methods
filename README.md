# Solving-Cart-Pole-Swing-Up-Problem-by-using-Reinforcement-Learning-Methods

Gaussian Mixture Model based actor-critic algorithm, the algorithm is implemented and simulated in Matlab.

## The problem description
The scenario is a cart-pole swing up task. The dynamics of the system can be found in the followingreference: Deisenroth, Marc Peter. Efficient reinforcement learning using Gaussian processes. Vol. 9. KIT Scientific Publishing, 2010. Page 172-173

## Modelling 
A five dimensional GMM for (state, action) and a six dimensional GMM for (state, action, action value) are created. Only one Gaussian in GMM is initalized in the beginning. More Gaussians are added during learning when it is required. Online incremental Expectation Maximization are used to update GMM model. 

## Policy update
Using policy gradient method to update policy. In the sametime, choosing an explorative action using current GMM parameters. Compare their action value accordingly. Choose the one which leads to a higher action value. This is the exploit and explore. 
