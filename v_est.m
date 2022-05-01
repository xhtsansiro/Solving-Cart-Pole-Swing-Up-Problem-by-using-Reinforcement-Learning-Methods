function [a,y,var] = v_est(gmm,s)

%   gmm: model of gmm, s is the given state
%   a(i,1)->beta: the prior possibility of each gaussian, 
%   a(i,2)->miu,  a(i,3)->var,  y: average of the miu of all gaussians
    p_X = 0; y = 0; var = 0;
    l = size(gmm,1); % how many gaussians in the model
    dim = length(s); % how many dimensions
    n = dim + 1;
    for i = 1:1:l  %calculate p(x)
          cov_X = gmm{i,3}(1:dim,1:dim); 
          miu_X = gmm{i,2}(1:dim,1);
          p_X = [p_X; gmm{i,1} * mvnpdf(s,miu_X,cov_X)];
    end
    p_X(1) = []; % delete the 0, 
    
    %calculate beita(x) and miu_i (y|x), variance and estimate y
    if sum(p_X) ~= 0
       a(:,1) = p_X / sum(p_X); % beita, prior possibility
    end
   % a(:,2) = zeros(l,1); a(:,3) = zeros(l,1);
    for i = 1:1:l         
        a(i,2) = gmm{i,2}(n,1) + gmm{i,3}(n,1:dim)* (gmm{i,3}(1:dim,1:dim)\(s - gmm{i,2}(1:dim,1))); % miu, average
        a(i,3) = gmm{i,3}(n,n) - gmm{i,3}(n,1:dim)* (gmm{i,3}(1:dim,1:dim)\ gmm{i,3}(1:dim,n)); % sigma^2, variance
        y = y + a(i,1)*a(i,2); % the average output, beita(x)*miu(y|x)
    end
 
   % calculate the variance of estimation
   for i = 1:1:l
       var = var + a(i,1) * (a(i,3) + (a(i,2)-y)^2);
   end

end

