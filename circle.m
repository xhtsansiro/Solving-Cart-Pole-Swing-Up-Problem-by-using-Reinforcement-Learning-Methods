function circle(x,y,r,linewidth,col)
    %x and y are the coordinates of the center of the circle
    %r is the radius of the circle
    %0.01 is the angle step, bigger values will draw the circle faster but
    %you might notice imperfections (not very smooth)
    ang=0:0.001:2*pi; 
    xp=r*cos(ang);
    yp=r*sin(ang);
    % axis([-150 150 -150 150]);
    plot(x+xp,y+yp,'LineWidth',linewidth,'color',col);
    fill (x+xp,y+yp,'b');
    
end
