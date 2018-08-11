function [ col_space ] = colSpace( mat )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[m n] = size(mat);

ech = mat;
  
piv = zeros(m,1);
k = 1;
for j=1:1:n    
    
    max = 0;index = 0;
    for i=k:1:m
        if(ech(i,j) > max )
            max = ech(i,j);  
            index = i;
        end        
    end    
    
    if(index == 0)  
        continue; 
    end
    ech([k index],:) = ech([index k],:);
    coeff = ech(k,j);
    rowk = ech(k,:)/coeff;
    ech(k,:) = rowk;
    piv(k,1) = j; 
    for i=k+1:m
        d = ech(i,j);
        ech(i,:) = ech(i,:)-d*rowk;
    end     
    k = k+1;
end  


 col_space = [];
for j=1:m    
    if(piv(j,1) == 0)
    continue;
    end    
  col_space = [col_space mat(:,piv(j,1))];
end

end


