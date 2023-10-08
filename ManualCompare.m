boundElem = [1:50,3951:4000];         
boundt = [];
for i = 1:numel(boundElem)
    trow = find(coords(:,6) == boundElem(i));     
    if isempty(trow)
        continue
    end
    boundt = [boundt,trow];
end
boundElem = boundt;                    
bifurArea = B_ord(:,2);              
transB = [];
%%  
for i = 1:length(bifurArea)
    cArea = cell2{1,bifurArea(i)};    
    if ~isempty(intersect(boundElem,cArea))
        transB = [transB bifurArea(i)];                             
        interElems = intersect(boundElem,cArea);
        bx = sum(coords(interElems,2))/numel(interElems);
        by = sum(coords(interElems,3))/numel(interElems);
        B_ord(i,3) = bx;
        B_ord(i,4) = by;
    end
end
%% ¸üÐÂline
for i = 1:size(B,1)
    if ~ismember(B_ord(i,2),transB)         
        continue
    end
    pmBcoordx = B_ord(i,3);
    pmBcoordy = B_ord(i,4);
    for j = 1:size(B,1)
        psBcoordx = B_ord(j,3);
        psBcoordy = B_ord(j,4);
        if B(i,j) == 1
%             line([pmBcoordx,psBcoordx],[pmBcoordy,psBcoordy],'color','yellow','linewidth',5)
        end
    end
end  
 
%%  
hold on
B_ord_Manual =[80 25 0; 44.5 4.5 0;  0.5 2.5 0;   44.5 45.5 0;  0.5 47.5 0;     32.5 25.5 0];       
r_record = [];
for i = 1:size(B_ord_Manual,1)
    r = sqrt((B_ord_Manual(i,1)-B_ord(i,3))^2 + (B_ord_Manual(i,2)-B_ord(i,4))^2);
    r_record = [r_record, r];
    if r <= 0.5
        plot3(B_ord_Manual(i,1),B_ord_Manual(i,2),B_ord_Manual(i,3),'g.')
    else
        drawCircle(B_ord_Manual(i,:),r)
    end
end

%%  
Elems = [];
Nodes = [];
count = 0;
count_n = 0;
nel = 10;      
for i = 1:size(branch,1)
     
    n1 = branch{i,1}(1);
    n2 = branch{i,1}(2);
    n1x = B_ord(n1,3);
    n1y = B_ord(n1,4);
    n2x = B_ord(n2,3);
    n2y = B_ord(n2,4);  
    bx = linspace(n1x,n2x,nel+1);
    by = linspace(n1y,n2y,nel+1);
    ori_cn = count_n;
    count_n = count_n + nel+1;
    nid = ori_cn+1 : count_n;       
    for k = 1: nel+1
        Nodes(nid(k),1) = nid(k);
        Nodes(nid(k),2) = bx(k);
        Nodes(nid(k),3) = by(k);
    end
    
    for j = 1:nel
        count = count + 1;
        Elems(count,1) = count;  
        Elems(count,2) = bx(j);  
        Elems(count,3) = by(j);
        Elems(count,4) = bx(j+1);   
        Elems(count,5) = by(j+1);       
    end
end
 %  
 for i = 1:size(B_ord,1)
     bx = B_ord(i,3);
     by = B_ord(i,4);
     row = intersect(find(Nodes(:,2) == bx),find(Nodes(:,3) == by));
     if numel(row) >= 2
         row = setdiff(row,row(1));
         Nodes(row,:) = [];
     end
 end
  
 for i= 1:size(Nodes,1)
     Nodes(i,1) = i;
 end
 
 %%  
 for i = 1:size(Elems,1)
     n1x = Elems(i,2);
     n1y = Elems(i,3);
     n2x = Elems(i,4);
     n2y = Elems(i,5);
     n1 = intersect(find(Nodes(:,2) == n1x), find(Nodes(:,3) == n1y));
     n2 = intersect(find(Nodes(:,2) == n2x), find(Nodes(:,3) == n2y));
     Elems(i,6) = n1;
     Elems(i,7) = n2;
 end
 Nodes(:,4) = 0;   
 
 %%  
 Prop = [100e3 3.846e5 4.0568 1.3097 1.3097 2.6193];                       %%%%%%%%%%%%%%%%n      
%  colorset = [0 0 200; 21 121 255; 0 199 221; 40 255 185; 57 255 0; 170 255 0; 255 227 0; 255 113 0; 255 0 0];
%  colorset = colorset/255;
 colorset = [0.1 0.1 0.44; 0 0 1; 0 1 1; 0.5 1 0.83; 0.5 1 0; 1 1 0; 1 0.38 0; 1 0 0];      
 nodesCoords = Nodes;
 elemsConnec(:,1) = Elems(:,1);
 elemsConnec(:,2) = Elems(:,6);
 elemsConnec(:,3) = Elems(:,7);
 for i = 1:size(Nodes,1)
     NodesCoords{i} = Nodes(i,2:4);
 end
 
 for i = 1:size(Elems,1)
     ElemNodePair{i} = [Elems(i,6) Elems(i,7)];
 end
 totalDof = 6 * size(NodesCoords,2);
 %% 
for i = 1:numel(ElemNodePair)
    Elem_Point{i} = [NodesCoords{ElemNodePair{i}(1)},NodesCoords{ElemNodePair{i}(2)}];   
end
%%  
ks = {};
for i = 1:numel(ElemNodePair)       
    k = SpaceFrameElementStiffness(Prop,Elem_Point{i});
    ks{i} = k;                               
end
%% 
K = zeros(totalDof,totalDof);
for k = 1:numel(ElemNodePair)
    K = SpaceFrameAssemble(K,ks{k},ElemNodePair{k});
end

%%  
F = zeros(totalDof,1);
F(2) = -100;                                                                 
constrainedDof = [181:186,355:360];                      
U = solution(totalDof,constrainedDof,K,F);       
C = 0.5*U'*K*U;

%%  
originNodes = zeros(size(NodesCoords,2),3);
deformedNodes = zeros(size(NodesCoords,2),3);
scale = 100;
for i = 1: size(NodesCoords,2)
    dispx = U(6*(i-1) + 1);
    dispy = U(6*(i-1) + 2);
    
    originNodes(i,1) = i;                    
    originNodes(i,2) = nodesCoords(i,2);      
    originNodes(i,3) = nodesCoords(i,3);    
    dispx = scale * dispx;
    dispy = scale * dispy;
    deformedNodes(i,1) = i;                 
    deformedNodes(i,2) = nodesCoords(i,2) + dispx;     
    deformedNodes(i,3) = nodesCoords(i,3) + dispy;     
end
temp = [];
for i = 1:size(deformedNodes,1)
    tempx = U(6*(i-1) + 1);
    tempy = U(6*(i-1) + 2);
    tempU = sqrt(tempx^2 + tempy^2);
    temp = [temp tempU];
end
figure
for i = 1:size(elemsConnec,1)
    n1 = elemsConnec(i,2);
    n2 = elemsConnec(i,3);
    originline = [originNodes(n1,2) originNodes(n1,3) ;originNodes(n2,2) originNodes(n2,3) ];
    deformline = [deformedNodes(n1,2) deformedNodes(n1,3) ;deformedNodes(n2,2) deformedNodes(n2,3) ];
    drawLine(originline, deformline, colorset,scale*min(temp),scale*max(temp))
end
postBeamOpt_1031