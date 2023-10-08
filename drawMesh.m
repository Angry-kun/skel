function drawMesh(elemConnec, nodesCoord, p_set,color)
% 
vertices = nodesCoord(:,2:4);      
f_mat = elemConnec(p_set,2:5);     
patch('Vertices',vertices,'Faces',f_mat,'Edgecolor','w','LineWidth',0.000000001,'FaceColor',color)   %
axis equal
axis off