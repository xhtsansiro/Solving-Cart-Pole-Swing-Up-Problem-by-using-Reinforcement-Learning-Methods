function [gmm,nn] = gmm_update(gmm,nn,sample)
%GMM_UPDATE use samples to update gmm
%   
    dim = length(sample); % check the dimension of the gmm 
    l = size(gmm,1); % how many gaussians in this GMM 
    w = 0; p = zeros(1,l); %p_c = 0 ;
    
    % Online EM  
    for i = 1:1:l
        w = [w,  gmm{i,1}* mvnpdf(sample,gmm{i,2},gmm{i,3})]; % calculate the activation of each gaussian
    end
    w(1) = [];
    if sum(w) ~= 0  
        w = w/sum(w); % get the activation
    end
    % calculate [1]_t, [z]_t, [z z_t]
    %  n_z = counter * V * p_z; % V = 0.000001 * total_volumne of x (12*20*2pi*20*20*20)
    % if dim =5, V =0.00001* total_volumne
    if dim == 5
        n_z = nn * 0.5 * sum(w);
    elseif dim == 6
        n_z = nn * 0.5 * sum(w);
    end
    
    lamda = 1- (1-0.01)/(0.01*n_z + 10); % a = 0.01, b = 10
    
    nn = 0; %reset the total samples and recalculate it based on the new samples
    for i = 1:1:l
         gmm{i,4} = lamda ^ w(1,i) * gmm{i,4} + (1-lamda^w(1,i))/(1-lamda);
         gmm{i,5} = lamda ^ w(1,i) * gmm{i,5} + (1-lamda^w(1,i))/(1-lamda) * sample;
         gmm{i,6} = lamda ^ w(1,i) * gmm{i,6} + (1-lamda^w(1,i))/(1-lamda) * (sample * sample');
         nn = nn + gmm{i,4}; %get the new total sample number
         p(1,i) = gmm{i,4};
    end
    
     % 2) update alpha, average and covariance matrix of each gaussian class
   for i = 1:1:l
         gmm{i,1} = gmm{i,4} / nn;
         gmm{i,2} = gmm{i,5}/ gmm{i,4};
         gmm{i,3} = gmm{i,6}/ gmm{i,4} - gmm{i,2} * gmm{i,2}';  
         % regularization of the covariance matrix, make it positiv definit
         eig_v = eig(gmm{i,3});
         while min(eig_v) < 0.000001
             coef = 0.04;
             var =  trace(gmm{i,3})/(nn + 1);
             var = max(var, 0.01);
             gmm{i,3} = gmm{i,3} + coef* var^2 * eye(size(gmm{i,3}));
             eig_v = eig(gmm{i,3});
         end     
   end   
    
   % check if a new gaussian is needed 
   s = sample(1:dim-1); % take the state from the sample
   [~,est,~] = v_est(gmm, s); % get the estimation from the model
   error = (est - sample(dim))^2; % calculate the error between estimation and real value
   w_new = 0.2; % the weight of the new generated gaussian
   
   if dim == 5
       if error >= 1
           if min(p) > 8
               gmm{l+1,1} = 1/(nn+1); gmm{l+1,2} = sample;
               gmm{l+1,3} = [40 0 0 0 0
                             0 100 0 0 0
                             0 0 10 0 0
                             0 0 0 100 0
                             0 0 0 0 100];            
               nn = nn + 1;
               gmm{l+1,4} = 1; gmm{l+1,5} = w_new * sample; gmm{l+1,6} = gmm{l+1,3}; % this need to be rechecked 
               for k = 1:1:l
                  gmm{k,1} = gmm{k,4}/nn;
               end 
           end 
       end
       
   elseif dim == 6
       if error >= 4    
           if min(p) > 8
               gmm{l+1,1} = 1/(nn+1); gmm{l+1,2} = sample;
    
                 gmm{l+1,3} = [40 0 0 0 0 0
                               0 100 0 0 0 0
                               0 0 10 0 0 0
                               0 0 0 100 0 0
                               0 0 0 0 100 0
                               0 0 0 0 0 100];                            
                nn = nn + 1;
                gmm{l+1,4} = 1; gmm{l+1,5} = w_new * sample; gmm{l+1,6} = gmm{l+1,3}; % this need to be rechecked 
               
               for k = 1:1:l
                  gmm{k,1} = gmm{k,4}/nn;
               end 
           end    
       end     
   end  
    
end

