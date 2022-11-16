function [FF] = drawing_2020(coords,p_set,level_num, Geodesic, P1)

[value, col] = sort(Geodesic(P1, p_set));
logic_v = (value~=inf);
value = value(logic_v);
col = col(logic_v);          %%
col = p_set(col);
set_num = floor(length(value)/ level_num);     %
figure
stem3(coords(P1,2),coords(P1,3),100*coords(P1,5),'filled','g');    %
hold on
for i = 1:level_num
    if i <level_num
        FF{i} = col((i-1)*set_num + 1 : i * set_num);
        x = coords(FF{i},2);
        y = coords(FF{i},3);
        z = Geodesic(FF{i},P1);
        stem3(x,y,z,'s','fill','Color',[rand(),rand(),rand()])
        hold on
    else
        FF{i} = col((i-1)*set_num + 1 : end);
        x = coords(FF{i},2);
        y = coords(FF{i},3);
        z = Geodesic(FF{i},P1);
        stem3(x,y,z,'s','fill','m')
    end
end
