function s_next = simulator(s, u)
%SIMULATOR simulate the system dynamics
%   x: the position; x': the velocity; theta: the angle; 
%   theta_dot: angle velocity; u: the applied force
   x = s(1,1); x_dot = s(2,1); theta = s(3,1); theta_dot = s(4,1);
   m1 = 0.5; m2 = 0.5; % m1: the weight of cart, m2: the weight of pole
   l = 0.6; % l is the length of the pole
   b = 0.1; % (parameter) friction between cart and ground
   g = 9.82; % gravity accerlation 
   dt = 0.01; 
   time = 0;
   while time < 0.1
       %calculate the derivates z = [x,x_dot,theta,theta_dot]
       dz_1 = x_dot;
       dz_2 = (-2*m2*l*theta_dot^2 * sin(theta) - 3*m2*g*sin(theta)*cos(theta) + 4*u - 4*b*x_dot) / (4*(m1+m2)-3*m2*cos(theta)^2);
       dz_3 = theta_dot;
       dz_4 = (-3*m2*l*theta_dot^2 *sin(theta)*cos(theta) - 6*(m1+m2)*g*sin(theta) + 6*(u-b*x_dot)*cos(theta)) /(4*l*(m1+m2)-3*m2*l*cos(theta)^2);
       %Euler method
       x = x + dz_1 * dt + 1/2 * dz_2 * dt^2 ;
       % the range of x_dot is [-10 10]
       x_dot = x_dot + dz_2 * dt;
       if x_dot < -10
           x_dot = -10;
       elseif x_dot > 10
           x_dot = 10;
       end
        
       % check the angle, angle range [-pi,pi]
       temp = theta + dz_3 * dt + 1/2 * dz_4 * dt^2;
       if temp < -pi
           theta = temp + 2*pi;
       elseif temp > pi
           theta = temp - 2*pi;
       else
           theta = temp; 
       end
       
       theta_dot = theta_dot + dz_4 * dt;
       % the range of theta_dot is [-10 10]
       if theta_dot < -10
           theta_dot = -10;
       elseif theta_dot > 10
           theta_dot = 10;
       end
       
     
       %add the time
       time = time + dt;
      
   end
   s_next = [x; x_dot; theta; theta_dot];

end

