function BP = BifurcationPoint(brs, coords)
%%  
BP = [];
for i = 1:size(brs,1)-1
    pm = brs(i,:);
    for j = i+1 : size(brs,1)
        ps = brs(j,:);
        temp_bp = draw_bp(pm,ps,coords);
        BP = [BP; temp_bp];
    end
end
x_B = sum(BP(:,1))/size(BP,1);
y_B = sum(BP(:,2))/size(BP,1);
BP = [x_B, y_B];
end

function bp = draw_bp(p1, p2, coords)
%%  
p1_ID = coords(p1(1));
p2_ID = coords(p2(1));
k1 = tan(p1(2));
k2 = tan(p2(2));
x1 = coords(p1_ID,2);
x2 = coords(p2_ID,2);
y1 = coords(p1_ID,3);
y2 = coords(p2_ID,3);
if k1 == k2
    x_bp = (x1+x2)/2;
else
    x_bp = (k1*x1 - y1 - k2*x2 + y2)/(k1 - k2);
end
y_bp = k1*x_bp - k1*x1 + y1;
bp = [x_bp,y_bp];
end


