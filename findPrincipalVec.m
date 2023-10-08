% function point_in_principal = findPrincipalVec(branchPath, coords, Geodesic)

% branchPath = branchPath(9:end-9);
% a = coords(branchPath, 7);
% count = [];
%  for i = 1:numel(a)
%     b = a - a(i);                  
%     c = abs(b) < abs(min(a));      
%     d = find(c==1);
%     ee = numel(d)-1;              
%     count = [count; ee];           
%  end
% or = find(count == max(count));
% points = branchPath(or);
%  
% sumd = [];
% for i  = 1:numel(points)
%     pm = points(i);
%     rest = setdiff(points,pm);
%     sum_g = sum(Geodesic(pm,rest));
%     sumd = [sumd sum_g];
% end
% point_in_principal = find(sumd == min(sumd));
% point_in_principal = points(1);




function point_in_principal = findPrincipalVec(branchPath, cell2, coords, Geodesic)
%%
% branchPath = branchPath(9:end-9);
%  
% pes = [];      %path elems
% for i = 1:size(cell2,2)
%     judmember = ismember(branchPath, cell2{1,i});
%     if sum(judmember) > 0
%         pes = [pes, cell2{1,i}];
%     end
% end
pes = branchPath;
%  
len_path = length(pes);
seg = floor(len_path/3);
p1 = pes(1*seg);
p2 = pes(2*seg);

point_in_principal = [p1, p2];


