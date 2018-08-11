function [img] = basis2img( COEFF,col )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

count = 1;
for i=1:92
    for j=1:92
        img(j,i) = COEFF(count,col);
        count = count+1;
    end
end

img = mat2gray(img);

end

