function [gmm_a,gmm_c,reward] = gmmrl(gmm_a,gmm_c)
%GMMRL get the learned gmm model; gmm_a: gmm of actor; gmm_c: gmm of critic
   
  n_e = 0; % number of learning episodes
  nn_a = 0; nn_c = 0;
  gamma = 0.85; % discouting factor
  reward = zeros(1,10000); % store the accumulative reward of 15s,
  
  l = 0.6; % l is the length of the pole
  j_target = [0 0 1]; T_inv = [1 l 0; l l^2 0; 0 0 l^2];
 
  while n_e < 10000  % 10000 episodes
      s = [0;0;-pi;0]; %starting state, cart in origin and pole is in downward pos.
      
      for i =1:1:50  % 50 iterations 50*0.1 = 5s
          % action selection， randomly select an action at for state s_t
      
          a = -10 + 20 * rand;    
          if a > 10 
              a = 10;
          elseif a < -10
              a = -10;
          end       
          % apply the action to the system, calculate r(s,a), to the next
          % state 
          j = [s(1), sin(s(3,1)), cos(s(3,1))];
          r = - (1 -exp(-0.5*(j-j_target)*T_inv*(j-j_target)'));
          s_next = simulator(s,a);
          % when the cart already moves out of range [-6 6], finish this
          % episode 
          if s_next(1) > 6 || s_next(1) < -6
              break;
          end
          %which action to be taken in next state
          [~,act_mn,~] = v_est(gmm_a,s_next);%
          % which action value function if apply this action in s_next
          [~,Q_est,~] =  v_est(gmm_c,[s_next;act_mn]); 
          q = r + gamma * Q_est;
          
          % update GMM of (s,a,q) using the samples
          [gmm_c,nn_c] = gmm_update(gmm_c,nn_c,[s;a;q]); 
          
          % generate a_target
          [~,pi_st,~] = v_est(gmm_a, s); % generate the determinstic action
          
          if pi_st > 10
              pi_st  = 10;
          elseif pi_st < -10
              pi_st = -10;
          end
          
          [~,q_pi,~] = v_est(gmm_c,[s;pi_st]); % q_value of the determinstic action
          
          % is it necessary to re-calculate Q(s_t+1,a_t+1) after learning   
          [~,Q_n_est,~] =  v_est(gmm_c,[s_next;act_mn]);
          q_prime = r + gamma * Q_n_est; % the explorative action value (based on learnt critic)
          % compare the action value function between explorative action and determinstic action
          if q_prime > q_pi
              a_target = a;
          else
              %calculate the gradient in the position pi_st;
              [~,q_pi_next,~] = v_est(gmm_c,[s;pi_st+0.001]);
              grad =  (q_pi_next - q_pi)/0.001;
              % the target action goes a little step along the gradient
              % direction, learning rate 0.02;
              a_target = pi_st + grad;  
              % check if the targt action out of range
              if a_target > 10
                  a_target = 10;
              elseif a_target < -10
                  a_target = -10;
              end    
          end
          % update GMM of (s,a) with the sample (s,a_target)
          [gmm_a,nn_a] = gmm_update(gmm_a,nn_a,[s;a_target]);
          
          % give s_next to s 
          s = s_next;
          
      end
      
      % check the performance of the learning, run 15 seconds and check the
      % accumulative reward
      
      s_test = [0;0;-pi;0];
      for t = 1:1:150
         % take tha action
         
         jj = [s_test(1), sin(s_test(3,1)), cos(s_test(3,1))];
         % which reward of r(s,a)
         rr = - (1 -exp(-0.5*(jj-j_target)*T_inv*(jj-j_target)'));
         reward(n_e+1) = reward(n_e+1) + gamma^(t-1) * rr ;
         % after taking the action, to the next state
         [~,aa,~] = v_est(gmm_a,s_test);
         s_test = simulator(s_test, aa);   
      end
      n_e = n_e + 1;
  end               
   
end


 
