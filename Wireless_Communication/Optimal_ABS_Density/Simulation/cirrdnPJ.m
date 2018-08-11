function [x y]=cirrdnPJ(x1,y1,rc)
a=2*pi*rand;
r=sqrt(rand);
x=(rc*r)*cos(a)+x1;
y=(rc*r)*sin(a)+y1;
end

% function to uniformly scatter users in a given circular area.