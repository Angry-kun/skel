function disp = solution(TotalDof, ConstrainedDof, K, force)
%  
activeDof = setdiff(1:TotalDof, ConstrainedDof);
U = K(activeDof,activeDof)\force(activeDof);
disp = zeros(TotalDof,1);
disp(activeDof) = U;
