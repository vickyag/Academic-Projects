load('EigenVectors.mat');
%imshow(basis2img(COEFF,1));

for i=1:3:75
str = 'basis ';
str2 = int2str(i);
str = strcat(str,str2); 
h = figure    
imshow(basis2img(COEFF,i));
title(str);
%str = 'LARP assignment\basis ';
%str = strcat(str,str2);
%print(h,str,'-djpeg');
end   
