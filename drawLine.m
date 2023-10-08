function drawLine(originLine, deformedLine, colorset, mind, maxd)
 

% if originLine(1,1) ==  originLine(2,1)
%     originLine(2,1) = originLine(1,1)+ 0.00000001;
% end
% if originLine(1,2) ==  originLine(2,2)
%     originLine(2,2) = originLine(1,2)+ 0.00000001;
% end
% if deformedLine(1,1) ==  deformedLine(2,1)
%     deformedLine(2,1) = deformedLine(1,1)+ 0.00000001;
% end
% if deformedLine(1,2) ==  deformedLine(2,2)
%     deformedLine(2,2) = deformedLine(1,2)+ 0.00000001;
% end
numLegend = size(colorset,1);  
ox = linspace(originLine(1,1),originLine(2,1),100);        
oy = linspace(originLine(1,2),originLine(2,2),100);          
dx = linspace(deformedLine(1,1),deformedLine(2,1),100);
dy = linspace(deformedLine(1,2),deformedLine(2,2),100);
% if norm(deformedLine(2,:)-deformedLine(1,:)) > norm(originLine(2,:)-deformedLine(1,:))     
%     dist = sqrt((dx - ox).^2 + (dy - oy).^2);                     
%     ticks = -1* linspace(maxd,mind,numLegend);                     
%     type = 1;
% else
%     dist = -1 * sqrt((dx - ox).^2 + (dy - oy).^2);                  
%     ticks = linspace(mind,maxd,numLegend);                      
%     type = 0;
% end
                              
dist = sqrt((dx - ox).^2 + (dy - oy).^2);                       
ticks = linspace(mind,maxd,numLegend);                       
% figure
hold on
% dist_color = zeros(1,numel(ox));
for i = 1:numel(dist)-1
    judge = (dist(i) <= ticks+0.0001);      
    nonZero = find(judge == 1,1,'first');    
    dist_color = colorset(nonZero,:);       

     
    plot([ox(i),ox(i+1)],[oy(i),oy(i+1)],'k','linewidth',2)
     
    plot([dx(i),dx(i+1)],[dy(i),dy(i+1)],'color',dist_color,'linewidth',2)
end
view(2)
axis off
% colorset = [0.1 0.1 0.44; 0 0 1; 0 1 1; 0.5 1 0.83; 0.5 1 0; 1 1 0; 1 0.38 0; 1 0 0];%[0 0 0; 0.2 0.2 0.2; 0.5 0.5 0.5 ;0.7 0.7 0.7 ; 1 1 1 ];
% drawLine([0 0 ; 1 0],[0 0; 1 1],colorset,0,1)