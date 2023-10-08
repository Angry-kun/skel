function drawCircle(centerCoords,r)
cx = centerCoords(1);
cy = centerCoords(2);
cz = centerCoords(3);
% sample_x = [-r:0.01:r];
% % sample_r = [-r:0.1:r];
% sample_y = sqrt(r^2 - sample_x.^2);
% nsy = -sample_y;
% % 平移坐标系
% sample_x = sample_x+cx;
% sample_y = sample_y+cy;
% nsy = nsy +cy;
% 
% hold on
% for i = 1:numel(sample_x)
% %     p1 = [-sample_x(i), -sample_y(i)];
%     plot3(sample_x(i), sample_y(i), cz,'r.')
%     plot3(sample_x(i), nsy(i), cz,'r.')
% %     plot3(sample_x(i), sample_y(i), cz,'g.')
% %     plot3(sample_x(i), sample_y(i), cz,'b.')
% end
% 
% %% 第二部分
% sample_y = [-r:0.01:r];
% % sample_r = [-r:0.1:r];
% sample_x = sqrt(r^2 - sample_y.^2);
% nsx = -sample_x;
% % 平移坐标系
% sample_x = sample_x+cx;
% sample_y = sample_y+cy;
% nsx = nsx +cx;
% 
% for i = 1:numel(sample_x)
% %     p1 = [-sample_x(i), -sample_y(i)];
%     plot3(sample_x(i), sample_y(i), cz,'r.')
%     plot3(nsx(i),sample_y(i) , cz,'r.')
% %     plot3(sample_x(i), sample_y(i), cz,'g.')
% %     plot3(sample_x(i), sample_y(i), cz,'b.')
% end
% 
% 
% view(2)
% axis equal
% axis off

% drawCircle([31.5,24.5,0],5)
aplha = 0:pi/40:2*pi;
plot3(cx,cy,cz,'go','linewidth',2,'markeredgecolor','g','markerfacecolor','g','markersize',2)                    %,'color',[0.466,0.674,0.188]
x = r * cos(aplha);
y = r * sin(aplha);
x = x + cx;
y = y + cy;
cz = cz * ones(numel(x),1);
plot3(x,y,cz,'g-','linewidth',2);                      %,'color',[0.466,0.674,0.188]
axis equal
axis off