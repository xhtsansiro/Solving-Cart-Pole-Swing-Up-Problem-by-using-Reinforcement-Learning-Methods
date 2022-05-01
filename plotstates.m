figure(2)
x = 0; theta = -pi; % the initial state
s = [0;0;-pi;0];
ss = zeros(4,150);
for t = 0:1:150 % 15s duration
    
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
    ss(:,t+1) = s; 
    s = simulator(s,a); 
    
end

%figure(3)
%plot(time, ss(1,:)); title('15 seconds simulation'); xlabel('time'); ylabel('position x'); grid on

%figure(4)
%plot(time, ss(2,:)); title('15 seconds simulation'); xlabel('time'); ylabel('velocity x_dot');grid on




