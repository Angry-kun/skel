clc
clear
 
tic
 coords = importdata('Center_coords.txt');
elem_connec = importdata('elem_connec.txt');     
nodes_coords = importdata('nodes_coord.txt');    
logi_c = find(coords(:,6) > 0.001);             
rc = coords(:,1);
rc = rc(logi_c);
elem_connec = elem_connec(rc,:);
coords = coords(rc,:);
coords(:,6) = coords(:,1);              
coords(:,1) = 1:length(coords);         
n = length(coords);                     
% coords = zeros( n, 6 );
elem_size = 1;              
rmin = 3 * elem_size;


%% 
D = zeros(n, n);
for i = 1 : n - 1
    for j = i + 1 : n
        D(i, j) = norm( coords(i, 2:4) - coords(j, 2:4) );           
        D(j, i) = D(i,j);
    end
end
%%  
W1 = zeros(n, n);
near_cell = {};
for i = 1 : n
    Arb_row = D(i, :);                                 
    t = sort(Arb_row(:));                              
    adjan = (Arb_row <= sqrt(2)* elem_size);           
    [row, col] = find(adjan);                          
    near_cell{i} = col;
    for j = 1 : length(row)
        c = col(1,j);
        W1(i,c) = D(i,c);
    end
end
%%  
W1(find(W1 == 0)) = inf;     
W1 = W1 - diag(diag(W1));    
W1(isnan(W1)) = 0;          
%%  
[dist,mypath,Path,Geodesic] = myFloyd(W1,1,2);     
%%
set = coords(:,1)';
sub_set = getSubset(set,Geodesic,coords,near_cell, elem_size, elem_connec, nodes_coords);

% figure
%% 
iter = 1;
subAreaPn = 50;                                          
while true
    sub_col = size(sub_set,2);                            
    lo_col = 0;
    for i = 1:sub_col
         
        if numel(sub_set{iter,i}) < subAreaPn                   
            lo_col = lo_col + 1;
            sub_set{iter + 1,lo_col} = sub_set{iter,i};    
            continue
        end
        temp = getSubset(sub_set{iter,i},Geodesic,coords,near_cell,elem_size, elem_connec, nodes_coords);
        for j = 1:size(temp,2)
            sub_set{iter + 1,(lo_col + j)} = temp{j};
        end
        lo_col = lo_col + size(temp,2);
    end
    count = 0;
    for k = 1:size(sub_set,2)
        if numel(sub_set{iter + 1,k}) >= subAreaPn          
            count = count + 1;
        end
    end

    if count == 0                 
        break
    else
        iter = iter + 1;           
    end
end
%% 
sub_row = size(sub_set,1);             
cell_1 = sub_set(sub_row,:);            
cell_1(cellfun(@isempty,cell_1)) = [];   

SegmentationProcess
