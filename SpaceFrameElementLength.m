function y = SpaceFrameElementLength(ElemPoints)
%���㵥Ԫ����
%   ��Ԫ����ȡ���������P1��P2������
x1 = ElemPoints(1);
y1 = ElemPoints(2);
z1 = ElemPoints(3);
x2 = ElemPoints(4);
y2 = ElemPoints(5);
z2 = ElemPoints(6);
y=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2);


end

