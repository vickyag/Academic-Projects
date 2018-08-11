function [ k ] = poissonGenerator()

lambda = 10;
L = exp(-1*lambda);
k = 0;
p = 1;
while(true)
   k = k+1;
   u = rand;
   p = p*u;
   if(p<=L)
      break;
   end
end
k = k-1;
end

