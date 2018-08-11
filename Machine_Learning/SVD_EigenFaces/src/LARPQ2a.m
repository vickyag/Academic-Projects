
for im=1:10
str1 = 's08/face';
str2 = int2str(im);
str = strcat(str1,str2);
str = strcat(str,'.pgm');
f1 = imread(str);
h = figure
imhist(f1);
str = strcat('face',str2);
ylabel('No. of pixels');
title(str);
%str = strcat('LARP assignment\Hist',str);
%print(h,str,'-djpeg');
end