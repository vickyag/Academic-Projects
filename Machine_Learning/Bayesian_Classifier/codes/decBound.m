function [ Cx1_2,Cx1_x2,Cx2_2,Cx1,Cx2,Cx0 ] = decBound( A1,B1,C1,A2,B2,C2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Cx1_2 = A1(1,1)-A2(1,1);
Cx1_x2 = A1(1,2)+A1(2,1)-A2(1,2)-A2(2,1);
Cx2_2 = A1(2,2)-A2(2,2);
Cx1 = B1(1,1)-B2(1,1);
Cx2 = B1(2,1)-B2(2,1);
Cx0 = C1-C2;

end

