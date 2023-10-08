function y = SpaceFrameElementLength(ElemPoints)
%计算单元长度
%   单元长度取决于输入的P1和P2的坐标
x1 = ElemPoints(1);
y1 = ElemPoints(2);
z1 = ElemPoints(3);
x2 = ElemPoints(4);
y2 = ElemPoints(5);
z2 = ElemPoints(6);
y=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);


end

