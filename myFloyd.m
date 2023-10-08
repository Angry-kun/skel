function [dist,mypath, path, GeoMat]=myFloyd(a,stp,desp)
% 
n = size(a,1); 
path = zeros(n);
for i = 1:n
    for j = 1:n
%         if a(i,j) ~= inf
            path(i,j) = j;        
%         end
    end
end
for k = 1:n
    for i = 1:n
        for j = 1:n
            if a(i,j) > a(i,k)+a(k,j)
                a(i,j) = a(i,k)+a(k,j);
                path(i,j) = path(i,k);
            end
        end
    end
end
dist = a(stp,desp);
GeoMat = a;
mypath = stp;
tp = stp;
while tp ~= desp
    temp = path(tp,desp);
    mypath = [mypath,temp];
    tp = temp;
end
return


