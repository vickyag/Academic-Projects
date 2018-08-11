function [ b ] = img2basis( m )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
k = 0;
for i=1:92
b(k+1:k+92,1) = m(:,i);
k = k+92;
end


end

