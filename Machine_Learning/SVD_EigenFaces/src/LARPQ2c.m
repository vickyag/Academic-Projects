load('EigenVectors.mat');
for t=1:10
str1 = 's08/face';
str2 = int2str(t);
str = strcat(str1,str2);
str = strcat(str,'.pgm');
f1 = imread(str);

%h = figure
%imshow(f1);
%str = strcat('face',str2);
%title(str);
%str = strcat('LARP assignment\',str);
%print(h,str,'-djpeg');

h = figure
b1 = img2basis(f1);
b1 = double(b1);
xb1 = COEFF'*b1;
abs_xb1 = abs(xb1);
[xb1_sort,index] = sort(abs_xb1,'descend');

relative_error_arr = zeros(8464,1);
 fnorm_original = 0;
for j=1:8464
       fnorm_original = fnorm_original + b1(j,1)^2;
end 
 fnorm_original = sqrt(fnorm_original);
 
for k=1:8464
    recon = zeros(8464,1);
    for i=1:k
    recon = recon +  xb1(index(i))*COEFF(:,index(i));
    end
    error = b1 - recon;
    %imshow(basis2img(recon,1));
    fnorm_error = 0;
    for j=1:8464
       fnorm_error = fnorm_error + error(j,1)^2;
    end    
    fnorm_error = sqrt(fnorm_error);
    relative_error = fnorm_error/fnorm_original;
    relative_error = relative_error*100;
    relative_error_arr(k,1) = relative_error;
    if(relative_error < 1) 
        imshow(basis2img(recon,1));
        break; 
    end
end  

str = 'Top ';
str3 = int2str(k);
str = strcat(str,str3);
str = strcat(str,' face');
str = strcat(str,str2);
title(str);
str = strcat('LARP assignment\',str);
print(h,str,'-djpeg');

h = figure
plot(1:k,relative_error_arr(1:k,1));
xlabel('Top K values');
ylabel('Relative Error');
str = strcat('FrobNorm Face',str2);
title(str);
str = strcat('LARP assignment\',str);
print(h,str,'-djpeg');

end