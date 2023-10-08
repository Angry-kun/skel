function y=SpaceFrameElementStiffness(Prop,Elem_Point)
 
E = Prop(1);
G = Prop(2);
A = Prop(3);
Iy= Prop(4);
Iz= Prop(5);
J = Prop(6);
x1=Elem_Point(1);
x2=Elem_Point(4);
y1=Elem_Point(2);
y2=Elem_Point(5);
z1=Elem_Point(3);
z2=Elem_Point(6); 

L=SpaceFrameElementLength(Elem_Point);    
w1=E*A/L;
w2=12*E*Iz/(L^3);
w3=6*E*Iz/(L^2);
w4=4*E*Iz/L;
w5=2*E*Iz/L;
w6=12*E*Iy/(L^3);
w7=6*E*Iy/(L^2);
w8=4*E*Iy/L;
w9=2*E*Iy/L;
w10=G*J/L;
kprime=[w1   0     0    0     0    0    -w1     0     0     0     0     0;       
         0  w2     0    0     0   w3      0   -w2     0     0     0    w3;
         0   0    w6    0   -w7    0      0     0   -w6     0   -w7     0;
         0   0     0  w10     0    0      0     0     0  -w10     0     0;
         0   0   -w7    0    w8    0      0     0    w7     0    w9     0;
         0  w3     0    0     0   w4      0   -w3     0     0     0    w5;
       -w1   0     0    0     0    0     w1     0     0     0     0     0;
         0 -w2     0    0     0  -w3      0    w2     0     0     0   -w3;
         0   0   -w6    0    w7    0      0     0    w6     0    w7     0;
         0   0     0 -w10     0    0      0     0     0   w10     0     0;
         0   0   -w7    0    w9    0      0     0    w7     0    w8     0;
         0  w3     0    0     0   w5      0   -w3     0     0     0    w4];
if x1==x2 && y1==y2    
    if z2>z1
        lambda=[0 0 1;0 1 0;-1 0 0];
    else
        lambda=[0 0 -1;0 1 0;1 0 0];
    end
else                  
    CXx=(x2-x1)/L;
    CYx=(y2-y1)/L;
    CZx=(z2-z1)/L;
    D=sqrt(CXx^2+CYx^2);
    CXy=-CYx/D;
    CYy=CXx/D;
    CZy=0;           
    CXz=-CXx*CZx/D;
    CYz=-CYx*CZx/D;
    CZz=D;
    lambda=[CXx CYx CZx;CXy CYy CZy;CXz CYz CZz];
end
R=[lambda zeros(3) zeros(3) zeros(3);
    zeros(3) lambda zeros(3) zeros(3);
    zeros(3) zeros(3) lambda zeros(3);
    zeros(3) zeros(3) zeros(3) lambda];
y=R'*kprime*R;

