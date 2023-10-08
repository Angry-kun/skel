function mypath = path_N1_N2(Path, N1, N2, coords)
%
mypath = N1;
t = N1;
while t ~= N2
    temp = Path(t,N2);
    mypath = [mypath,temp];
    t = temp;
end

%% 
path_vertices = [];
for i = 1:length(mypath)
    path_vertices = [path_vertices; coords(mypath(i),:)];
end
hold on
% plot3(path_vertices(:,2),path_vertices(:,3),path_vertices(:,4),'o-r')
