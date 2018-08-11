function [ U,S,V ] = mySVD( M )

[V,S2] = eig(M'*M);
S2 = diag(S2);
S2=sort(S2,'descend');
V = fliplr(V);
S=sqrtm(diag(S2));
U=(M*V)/S;
end

