function  [Vd, theta] = IntersectPoint(N1,N2)
%%  
k = ( N1(2)-N2(2) ) / (N1(1) - N2(1));
b = N1(2) - k * N1(1);

inter_x = - b * k / (k^2 + 1);
inter_y = b / (k^2 + 1);

Vd = (inter_x^2 + inter_y^2) ^ 0.5
theta = atan(inter_y / inter_x)


% % theta = theta/ pi * 180
% hold on 
% %plot(inter_x,inter_y,'o')
% plot(Vd,theta,'o')