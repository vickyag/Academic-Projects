function [ E,S,E_inv ] = myEVD( M,f,s )

if(f ~= s)
[E,S] = eig(M'*M);
else
 [E,S] = eig(M);  
end
[E,S] = cdf2rdf(E,S);
E_inv = inv(E);




end

