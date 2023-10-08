function y = SpaceFrameAssemble(K,k,ElemNodes)
%  
i = ElemNodes(1);
j = ElemNodes(2);
%  
C=[6*i-5 6*i-4 6*i-3 6*i-2 6*i-1 6*i 6*j-5 6*j-4 6*j-3 6*j-2 6*j-1 6*j]';
R=[6*i-5 6*i-4 6*i-3 6*i-2 6*i-1 6*i 6*j-5 6*j-4 6*j-3 6*j-2 6*j-1 6*j];

for m = 1:12
    for n = 1:12
        K(C(m),R(n)) = K(C(m),R(n)) + k(m,n);
    end
end
y = K;
end

