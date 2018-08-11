function [ A,B,C ] = gxCoeff( mu,sigma )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
mu = mu';
A = inv(sigma)/-2;
B = inv(sigma)*mu;
C = ((mu'*B)/-2)-((log(det(sigma)))/-2)-log(3);

end

