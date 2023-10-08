 
length_total = 0;
branch_lens = [];
for i = 1:size(branch,1)
    b1 = branch{i,1}(1);
    b2 = branch{i,1}(2);
    b1x = B_ord(b1,3);
    b1y = B_ord(b1,4);
    b2x = B_ord(b2,3);
    b2y = B_ord(b2,4);
    length = norm([b2x-b1x, b2y-b1y]);
    branch{i,10} = length;
    branch_lens = [branch_lens length];
    length_total = length_total + length;
end
V = 1200;      
cross_initial = V/length_total;      
r = sqrt(cross_initial/3.1415926);
E = 100e3;                                                 
G = E/2.6;                                                 
A = 3.1415926 * r^2;
Ix = 3.1415926 * (2*r)^4 / 64;
Iy = 3.1415926 * (2*r)^4 / 64;
J = 2*Ix;
prop_branch = zeros(size(branch,1),6);      
prop_branch(:,1) = E;
prop_branch(:,2) = G;
prop_branch(:,3) = A;
prop_branch(:,4) = Ix;
prop_branch(:,5) = Iy;
prop_branch(:,6) = J;
count_iter = 0;
cc = [];                
C_old = 0;
C_his = [];
while 1
    count_iter = count_iter + 1;
    %%  
    ks = {};
    for m = 1:size(branch,1)
        tempElemID = (m-1)*nel + 1 : m*nel;         
        for j = 1:numel(tempElemID)                 
            i = tempElemID(j);
            k = SpaceFrameElementStiffness(prop_branch(m,:),Elem_Point{i});
            ks{i} = k;                               
        end
    end
    %%
    %%%  
    K = zeros(totalDof,totalDof);
    for j = 1:numel(ElemNodePair)
        K = SpaceFrameAssemble(K,ks{j},ElemNodePair{j});
    end
    
    %% 
    F = zeros(totalDof,1);
    F(2) = -100;                                           
    constrainedDof = [181:186, 355:360];                      
    U = solution(totalDof,constrainedDof,K,F);      
    
    C = 0.5 * U' * K * U
    %%  
    tempElemID = [];
    tempNodeID = [];
    nodesID  = [];
    cc = [];
    for m = 1:size(branch,1)
        
        tempElemID = (m-1)*nel + 1 : m*nel;     
        
        ccc = 0;
        for i = 1:numel(tempElemID)
            current_Elem = tempElemID(i);
            temp_node = Elems(current_Elem,6:7);          
            dof1 = (temp_node(1)-1) *6 + 1: 6* temp_node(1);
            dof2 = (temp_node(2)-1) *6 + 1: 6* temp_node(2);
            dof = [dof1, dof2];
            ccc = ccc+0.5*U(dof)' * ks{current_Elem} * U(dof);
        end
        
        cc(count_iter,m) = ccc;
    end
    ccc_iter = sum(cc(count_iter,:));
    %%  
    cc(count_iter,:) = cc(count_iter,:)./(branch_lens.*prop_branch(:,3)');
    max_cc = max(cc(count_iter,:));
    %%  
    total_v = 0;
    for i = 1:size(branch,1)
        prop_branch(i,3) = prop_branch(i,3) * (cc(count_iter,i) / max_cc) ^0.5;      
        rr = sqrt(prop_branch(i,3)/3.1415926);
        prop_branch(i,4) = 3.1415926 * (2*rr)^4 /64;
        prop_branch(i,5) = prop_branch(i,4);
        prop_branch(i,6) = 2*prop_branch(i,4);
        total_v = total_v + branch{i,10} * prop_branch(i,3);
        
    end
    total_v;
    coeff = total_v/V;
    %%  
    prop_branch(:,3) = prop_branch(:,3) / coeff;
    rr = sqrt(prop_branch(:,3)/3.1415926);
    prop_branch(:,4) = 3.1415926*(2*rr).^4/64;
    prop_branch(:,5) = prop_branch(:,4);
    prop_branch(:,6) = 2*prop_branch(:,5);
    
    if abs((C - C_old)/C) < 0.01 || count_iter > 100
        break
    end
    C_old = C;
    C_his = [C_his C];
end




