function [cpv, vec] = centerness(cpv, coords, Geodesic, rmin)
%%  
xc = coords(cpv, 2);
yc = coords(cpv, 3);

jx = (coords(:,2) < xc + rmin) .* (coords(:,2) > xc - rmin);
jy = (coords(:,3) < yc + rmin) .* (coords(:,3) > yc - rmin);
c = jx.*jy;
c = logical(c);
d = coords(c,1);

%%
% record = [];     
% for i = 1:numel(d)
%     rest = setdiff(d,d(i));
%     sumd = sum(Geodesic(rest,d(i)));
%     record = [record;d(i) sumd];
% end
% [~,co] = sort(record);
% minr = co(1,2);        
% minp = record(minr,1);   
% stem3(coords(d,2),coords(d,3),coords(d,4),'m>')
% if abs(coords(minp,7) - coords(cpv,7)) < 0.5
%     cpv = minp;
%     vec = coords(minp,7);
% else
%     vec = coords(cpv,7);
% end
% stem3(coords(cpv,2),coords(cpv,3),coords(cpv,4),'g>','linewidth',5)

%%
sumx = sum(coords(d,2))/numel(d);
sumy = sum(coords(d,3))/numel(d);
sumz = sum(coords(d,4))/numel(d);
min_error = inf;
for i = 1:length(d)
    error = norm(coords(d(i),2:4) - [sumx,sumy,sumz]);
    if error < min_error
        min_error = error;
        minp = d(i);
    end
end

if abs(coords(minp,7) - coords(cpv,7)) < 0.5
    cpv = minp;
    vec = sum(coords(d,7))/numel(d);
else
    vec = sum(coords(d,7))/numel(d);
end
% stem3(coords(cpv,2),coords(cpv,3),coords(cpv,4),'g>','linewidth',5)
