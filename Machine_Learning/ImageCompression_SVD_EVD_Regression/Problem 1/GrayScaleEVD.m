im = imread('16 sq.jpg');

gray = rgb2gray(im);
[f,s]=size(gray);
gray = im2double(gray);
[E,S,E_inv] = myEVD(gray,f,s);

error = zeros(s,1);
for i=1:1:s
    ns = S(1:i,1:i);
    ne = E(:,1:i);
    n_inv = E_inv(1:i,:);
    ni = ne*ns*n_inv;
    if(f ~= s)
        t = pinv(gray');
    ni = t*ni;
    end
    
    h = figure;
    subplot(1,2,1);    
    imshow(ni); 
    title('Reconstructed Image')
    subplot(1,2,2);
    imshow(gray-ni);
    title('Errored Image')
    str1 = 'GrayScaleSqEVD\N';
    str2 = int2str(i);
    str = strcat(str1,str2);
    print(h,str,'-djpeg')
    error(i,1) = sqrt(immse(gray,ni));
end    
p = figure;
plot((1:s),error);
title('First N singular values Vs RMSE')
xlabel('N')
ylabel('RMSE')
print(p,'GrayScaleSqEVD\ErrorPlotGSEVD','-djpeg')