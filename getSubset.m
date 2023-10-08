function sub_set = getSubset(set,Geodesic,coords,near_cell, elem_size, elemConnec, nodesCoord)
%% 
%%
[temp_geo, ~] = max(Geodesic(set,set));      
temp = 0;
order = 0;
for i = 1 : length(temp_geo)
    if temp_geo(i) == inf
        continue
    end
    if temp_geo(i) > temp
        temp = temp_geo(i);                  
        order = set(i);                    
    end
end

[~,row] = max(Geodesic(set,order));           
row = set(row);

%%

list_rest = setdiff(set,[order,row]);     
Set_one = [];                             
Set_two = [];
for i = 1:length(list_rest)
    temp_elem_ID = list_rest(i);         
    if (Geodesic(temp_elem_ID,row) == inf) || (Geodesic(order, temp_elem_ID)==inf )
        continue
    end
    current_geod1 = Geodesic(temp_elem_ID,row);                                  
    current_geod2 = Geodesic(temp_elem_ID,order);
    set_adjan = intersect(near_cell{1,temp_elem_ID},set);                         
    set_adjan = setdiff(set_adjan,temp_elem_ID);                                 
    if current_geod1 > max(Geodesic(set_adjan,row)) || current_geod1 < min(Geodesic(set_adjan,row))     
        Set_one = [Set_one, temp_elem_ID];                                                             
    end
    if current_geod2 > max(Geodesic(set_adjan,order)) || current_geod2 < min(Geodesic(set_adjan,order))
        Set_two = [Set_two, temp_elem_ID];
    end
end


%% 
for i = 1:length(Set_one)
    for j = 1:length(Set_two)
%         disp([Set_one(i),Set_two(j)])                           
        if Set_two(j) == 0 ||Set_one(i)==Set_two(j)          
            continue
        end
        A = Geodesic(Set_one(i),Set_two(j));                 
        if  A < 2 * elem_size
%             disp(Set_one(i))
            Set_two(j) = 0;                                  
        end
    end
end

interf_set = intersect(Set_one,Set_two);          
if isempty(interf_set) || length(interf_set)==1   
    interf_set = [row, order];
end
hold on

% stem3(coords(interf_set,2),coords(interf_set,3),coords(interf_set,4),'go','fill','linewidth',8)
% stem3(coords([row,order],2),coords([row,order],3),coords([row,order],4),'ro','fill','linewidth',8)


line_F_rest = setdiff(set,interf_set);         
Geod_f = Geodesic(line_F_rest, interf_set);   
[~,ind_f] = min(Geod_f,[],2);                  
ind_mat = [line_F_rest;interf_set(ind_f)]';   

%% 
for i = 1:length(interf_set)
    logi = (ind_mat(:,2) == interf_set(i));         
    p_set = ind_mat(:,1);
    p_set = p_set(logi);                            
    p_set = [p_set;interf_set(i)];
    
%     stem3(coords(p_set,2),coords(p_set,3),coords(p_set,4),'o')     
    %%
  
%     drawMesh(elemConnec, nodesCoord, p_set,[rand(),rand(),rand()])

    
    sub_set{i} = p_set';
    %sub_set{i} = drawing_2020(coords,p_set,4,Geodesic,interf_set(i));
end


