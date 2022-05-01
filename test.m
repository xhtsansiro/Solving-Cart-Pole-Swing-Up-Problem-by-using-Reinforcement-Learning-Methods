% initialize the GMM model of (s,a) space, it has 5 dimensions
gmm_a{1,1} = 1; gmm_a{1,2} = zeros(5,1); gmm_a{1,4} = 0; gmm_a{1,5} = zeros(5,1);
gmm_a{1,3} = [40 0 0 0 0
              0 100 0 0 0
              0 0 10 0 0
              0 0 0 100 0
              0 0 0 0 100];
gmm_a{1,6} = [40 0 0 0 0
              0 100 0 0 0
              0 0 10 0 0
              0 0 0 100 0
              0 0 0 0 100];
          
% initialize the GMM model of (s,a,q) space, it has 6 dimensions
% 1: alpha; 2: average; 3: covariance; 4: weighted numbers; 5: [z]_t; 6: [z z_t]
gmm_c{1,1} = 1; gmm_c{1,2} = zeros(6,1); gmm_c{1,4} = 0; gmm_c{1,5} = zeros(6,1);
gmm_c{1,3} = [40 0 0 0 0 0
              0 100 0 0 0 0
              0 0 10 0 0 0
              0 0 0 100 0 0
              0 0 0 0 100 0
              0 0 0 0 0 100];
gmm_c{1,6} = [40 0 0 0 0 0
              0 100 0 0 0 0
              0 0 10 0 0 0
              0 0 0 100 0 0
              0 0 0 0 100 0
              0 0 0 0 0 100];
% start collecting sample and learn the model
[gmm_a_f, gmm_c_f, reward] = gmmrl(gmm_a, gmm_c);

figure(1)
plot(reward);
% after model is learnt, 
figure(2)
x = 0; theta = -pi; % the initial state
s = [0;0;-pi;0];
ss = zeros(1,150);
for t = 1:1:150 % 10s duration
    
    x = s(1); theta = s(3);
    clf(figure(2));
    hold on
    axis([-10 10 -4 10]);
    % plot the cart
    rectangle('Position',[x-2 0.5 4 1])
    hold on 
    % two wheels
    circle(x-1,0.25,0.25,1,'b');
    circle(x+1,0.25,0.25,1,'b');
    % plot the cart
    rectangle('Position',[x-2 0.5 4 1])
    
    circle(x,1,0.05,1,'b');
    
    x2 = x - 4 * sin(theta) ;  % the position where the end point of pendulum
    y2 = 1 + 4 * cos(theta) ;   % use 4 as length to visualize, in fact it is 1

    circle(x2,y2,0.07,1,'g'); 
    plot ([x x2],[1 y2],'LineWidth',1.5); %plot a line between two points of pendulum
    
    drawnow;
    % take tha action
    [~,a,~] = v_est(gmm_a_f,s);
    % get to the next action
    ss(t) = s; 
    s = simulator(s,a); 
    
end

    
    

  



