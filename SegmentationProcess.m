

%%
mesh_color = zeros(100,3);
for i = 1:size(mesh_color,1)
    mesh_color(i,:) = [rand() rand() rand()];
end

%% 
num_cell = length(cell_1);
count = 0;
% figure
for j = 1:num_cell
    subb = cell_1{1,j};               
    cell_1{3,j} = mesh_color(j,:);
%     drawMesh(elem_connec, nodes_coords, cell_1{1,j},cell_1{3,j})
    temp_set = [];
    speci_p = subb(1);                
    disp_v = Geodesic(subb,speci_p);
    [dv,col] = sort(disp_v);          
    for i = 2:length(col)-1          
        err_1 = dv(i) - dv(i-1);
        err_2 = dv(i + 1) - dv(i);
        if err_2 > 3*err_1 && err_1 > 0.1        
            temp_set = subb(col(i+1:end));        
            oter_set = setdiff(subb,temp_set);
            count = count+1;
            break
        end
    end
    if isempty(temp_set)
        continue
    else
        cell_1{1,j} = temp_set;
        cell_1{1,num_cell+count} = oter_set;     
    end
end

%%
% figure
bifur = [];                                   
for k = 1:size(cell_1,2)
   
    conn = [];
    for j = 1:size(cell_1,2)
        mat_D = D(cell_1{1,k},cell_1{1,j});              
        if k == j
            continue
        elseif min(min(mat_D)) > elem_size                 
            continue
        else
            Drv = [];
            Dcv = [];
            while  min(min(mat_D)) == elem_size
                [Dr,Dc] = find(mat_D == min(min(mat_D)));         
                mat_D(Dr,Dc) = inf;
                Drv = [Drv; Dr];
                Dcv = [Dcv; Dc];    
            end
            num_con = min(length(unique(Drv)),length(unique(Dcv)));        
            conn = [conn; j, num_con];
        end
    end
    cell_1{2,k} = conn;             
    if size(conn,1) >= 3  %|| numel(cell_1{1,k}) < 20          
        bifur = [bifur,k];
    end
end

%%  
for i = 1:length(cell_1)
    if size(cell_1{2,i}) == 2 
        rs = cell_1{2,i};
        numrs = rs(:,2);   
        rs = rs(:,1);
        max_con = find(numrs == max(numrs));
        max_con = max_con(1);
        if sum( ismember(rs,bifur))>=2             
            cell_1{1,rs(max_con)} = [cell_1{1,rs(max_con)},cell_1{1,i}];
            cell_1{2,i} = [];
            cell_1{1,i} = [];
        end
    end
end

%%  
for i = 1:length(cell_1)
    if isempty(cell_1{1,i})
        continue
    end
    if numel(cell_1{1,i}) < 10                                     
        rs = cell_1{2,i};
        numrs = rs(:,2);   
        rs = rs(:,1);
        max_con = find(numrs == max(numrs));
        max_con = max_con(1);
        
            cell_1{1,rs(max_con)} = [cell_1{1,rs(max_con)},cell_1{1,i}];
            cell_1{2,i} = [];
            cell_1{1,i} = [];
        
    end
end


%%   
for i = 1:length(bifur)      
    if bifur(i) == 0        
        continue
    end
    if isempty(cell_1{2,bifur(i)})
        continue
    end
    region = cell_1{2,bifur(i)};              
    region = region(:,1);                     
    iter = 1;
    while iter ~= 2
        if iter == 1
            pairs = [];
            for j = 1:numel(region)
                if size(cell_1{2,region(j)},1) >= 3
                    pairs = [pairs, region(j)];
                    co_bifur = find(bifur == region(j));
                    bifur(co_bifur) = 0;
                end
            end
            
            if isempty(pairs)
                break
            end
            iter = iter +1;
        end

    end
    %%  
    if iter == 2
        for k = 1:numel(pairs)
            cell_1{1,bifur(i)} = [cell_1{1,bifur(i)},cell_1{1,pairs(k)}];
            cell_1{1,pairs(k)} = [];
            cell_1{2,pairs(k)} = [];
        end
    end
    if iter == 3
        for k = 1:numel(pairs2)
            cell_1{1,bifur(i)} = [cell_1{1,bifur(i)},cell_1{1,pairs2(k)}];
            cell_1{1,pairs2(k)} = [];
            cell_1{2,pairs2(k)} = [];
        end
    end
end
    
  %%  
cell2 = {};
count  = 0;
for i= 1:size(cell_1,2)
    if isempty(cell_1{1,i}) || numel(cell_1{1,i}) <10
        continue
    else
        count = count + 1;
        cell2{1,count} = cell_1{1,i};
        cell2{2,count} = cell_1{2,i};
        cell2{3,count} = cell_1{3,i};
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  
for k = 1:size(cell2,2)
    
     
    conn = [];
    for j = 1:size(cell2,2)
        if k == j
            continue
        else
            num_con = length(find(Geodesic(cell2{1,k},cell2{1,j}) <= 2*elem_size));       
            if num_con > 1      
                conn = [conn; j, num_con];
            end
        end
    end
    cell2{2,k} = conn;        
end

%% 
c_p = [];                   
for i = 1:size(cell2,2)
    temp_set = cell2{1,i};
    Geo_d = inf;        
    for k = 1:length(temp_set)
        current_p = temp_set(k);     
        rest_p = setdiff(temp_set, current_p);
        d_sum = sum(Geodesic(current_p,rest_p));
        if Geo_d > d_sum
            Geo_d = d_sum;
            mini_p = current_p;
        end
    end
    hold on
   
    
    if isempty(cell2{3,i})
        cell2{3,i} = [rand(),rand(),rand()];
    end
%     drawMesh(elem_connec, nodes_coords, cell2{1,i},cell2{3,i})
    center_x = coords(mini_p,2);
    center_y = coords(mini_p,3);
    center_z = coords(mini_p,4);
    % P = [P;center_x,center_y];
    c_p = [c_p;i mini_p];
    
%     plot3(center_x,center_y,center_z,'ro','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r');     %plot(center_x,center_y,center_z * 100, 'y','fill','linewidth',5)
end

%% 
llines = [];
for i = 1:size(cell2,2)
    pm = c_p(i,2);         
    mat_s = cell2{2,i};   
    for j = 1:size(cell2{2,i},1)     
        ps = c_p(mat_s(j,1),2);     
%         line(coords([pm,ps],2),coords([pm,ps],3),'Color','cyan','linewidth',5);%,coords([pm,ps],3)
        llines = [llines; coords(pm,2:3); coords(ps,2:3) ];
    end
    %% 
    B_n = size(mat_s, 1);      
    if B_n >= 3
        cell2{3,i} = 'B';
    elseif B_n == 2
        pm_ID = c_p(i,2);           
        ps1_ID = c_p(mat_s(1,1),2);
        ps2_ID = c_p(mat_s(2,1),2);
        pm_coord = coords(pm_ID,2:3);
        ps1_coord = coords(ps1_ID,2:3);
        ps2_coord = coords(ps2_ID,2:3);
        v1 = ps1_coord - pm_coord;
        v2 = ps2_coord - pm_coord;
        len1 = norm(v1);
        len2 = norm(v2);
        product_v12 = dot(v1,v2);
        theta = acos(product_v12 / (len1 * len2));
        cell2{3,i} = theta * 57.3;       
    else         
        cell2{3,i} = 'B';
    end
    
end
for i = 1:size(cell2,2)
    if cell2{3,i} == 'B'
        cell2{4,i} = 'B';
    else
        theta_curr = cell2{3,i};
        ps1 = cell2{2,i}(1,1);       
        ps2 = cell2{2,i}(2,1);      
        if cell2{3, ps1} == 'B' ||  cell2{3, ps2} == 'B'     
            cell2{4,i} = 10000;                              
        else
            if cell2{3,i} < min(cell2{3, ps1}, cell2{3, ps2}) && (abs(cell2{3,i} - cell2{3, ps1}) >30 || abs(cell2{3,i} - cell2{3, ps1}) >30)
                cell2{4,i} = 'B';
            else
                cell2{4,i} = 10000;
            end
        end
    end
end


%% 
B_ord = [];
count = 0;
for i = 1:length(cell2)
    if cell2{4,i} == 'B'
        count = count+1;
        B_ord = [B_ord; count, i];
    end
end
%%  
Bs = c_p(B_ord(:,2),2);                         
% plot3(coords(Bs,2),coords(Bs,3),coords(Bs,4),'bo','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');

%% 
B = zeros(size(B_ord,1),size(B_ord,1));
% figure
% drawMesh(elem_connec, nodes_coords, set,[0.5,0.5,0.5])
% hold on
BP_ID = c_p(B_ord(:,2),2);               
% stem3(coords(BP_ID,2),coords(BP_ID,3),coords(BP_ID,4),'bo','filled','linewidth',8)
for i = 1:size(B_ord,1)-1
    pm = B_ord(i,2);          
    pm_elem = c_p(pm,2);        
    for j = i+1:size(B_ord,1)
        ps = B_ord(j,2);        
        ps_elem = c_p(ps,2);
        path_ms = path_N1_N2(Path, pm_elem, ps_elem, coords);
        
        B_rest = setdiff(B_ord(:,2),[pm,ps]);
        rest_elems = [];
        for k = 1:numel(B_rest)
             
            cuB = B_rest(k);                          
            mat_adjan = cell2{2,cuB};
            mat_adjan = mat_adjan(:,1);
            mat_adjan = setdiff(mat_adjan,[pm,ps]);     
            rest_elems = [rest_elems cell2{1,B_rest(k)}];
            for q = 1:numel(mat_adjan)
                rest_elems = [rest_elems cell2{1,mat_adjan(q)}];
            end
        end
        if ~isempty(intersect(path_ms,rest_elems))
            
        else
            B(i,j) = 1;
            B(j,i) = 1;
        end
    end
end
num_branch = numel(find(B==1))/2;

%%  
count = 0;
branch = {};
% figure
% drawMesh(elem_connec, nodes_coords, set,[0,0,0])
% hold on
for i = 1:size(B,1)
    for j = i+1:size(B,1)
        if B(i,j) == 1
            count = count + 1;
            branch{count,1} = [i,j];    
            s1 = B_ord(i,2);            
            s2 = B_ord(j,2);
            s1_elem = c_p(s1, 2);     
            s2_elem = c_p(s2, 2);      
            branch{count,2} = [s1,s2];
            branch{count,3} = [s1_elem, s2_elem];
            branch{count,4} = path_N1_N2(Path, s1_elem, s2_elem, coords);
            branch2Ps = findPrincipalVec( branch{count,4},cell2,coords,Geodesic);
            branch{count,5} = branch2Ps(1);                
            branch{count,6} = branch2Ps(2);               
        end
    end
end

%% 
for i = 1:size(branch,1)
    cp1 = branch{i, 5};
    cp2 = branch{i, 6};
    [cp1,~] = centerness(cp1,coords,Geodesic,rmin);
    [cp2,~] = centerness(cp2,coords,Geodesic,rmin);
    x_error = coords(cp1,2) - coords(cp2,2);
    y_error = coords(cp1,3) - coords(cp2,3);
    if x_error * y_error < 0                                  
        theta_branch = 3.1415926 + atan(y_error/x_error);
    else
        theta_branch = atan(y_error/x_error);
    end
    midp_x = (coords(cp1,2) + coords(cp2,2))/2;
    midp_y = (coords(cp1,3) + coords(cp2,3))/2;
    mid_errorx = coords(:,2) - midp_x;
    mid_errory = coords(:,3) - midp_y;
    sum_mid = abs(mid_errorx) + abs(mid_errory);
    midp = find(sum_mid == min(sum_mid));
    branch{i,8} = midp(1);            
    branch{i,9} = theta_branch;       
end


%% 
for i = 1:size(B,1)
    B_row = B(i,:);          
    B_c = find(B_row==1);   
    brs = [];
    for j = 1:numel(B_c)
        brs = [brs; i B_c(j)];      
    end
    bps = [];               
    %     if size(brs,1) == 1
    %         continue
    %     end
    for k = 1:size(brs,1)
        bm = brs(k,:);                  
        for q = 1:size(branch,1)
            bs = branch{q,1};
            if isequal(bm , bs) || isequal(bm , fliplr(bs))
                bps = [bps; branch{q,8} branch{q,9}];
            end
        end
    end
    
    %% 
    if size(brs,1) == 1                        
        B_ord(i,3) = coords(BP_ID(i),2);        
        B_ord(i,4) = coords(BP_ID(i),3);
    else
        BP = BifurcationPoint(bps,coords);
        B_ord(i,3) = BP(1);                    
        B_ord(i,4) = BP(2);
    end
end

%% 
% figure
% drawMesh(elem_connec, nodes_coords, set,[0,0,0])
for i = 1:size(B,1)-1
    pmBcoordx = B_ord(i,3);
    pmBcoordy = B_ord(i,4);
    for j = i+1:size(B,1)
        psBcoordx = B_ord(j,3);
        psBcoordy = B_ord(j,4);
        if B(i,j) == 1
%             line([pmBcoordx,psBcoordx],[pmBcoordy,psBcoordy],'color','red','linewidth',5)
        end
    end
end  
ManualCompare   
    

