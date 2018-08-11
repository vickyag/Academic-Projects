
im = imread('16rec.jpg');
[f,s,t] = size(im);
gray = rgb2gray(im);
gray = im2double(gray);
[U,S,V] = mySVD(gray);
error = zeros(s,1);
for i=1:1:s
    ns = S(1:i,1:i);
    nu = U(:,1:i);
    nv = V(:,1:i);
    ni = nu*ns*nv';
    
    h = figure;
    subplot(1,2,1);    
    imshow(ni); 
    title('Reconstructed Image')
    subplot(1,2,2);
    imshow(gray-ni);
    title('Errored Image')
    str1 = 'GrayScaleRecSVD\N';
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
print(p,'GrayScaleRecSVD\ErrorPlotGSSVD','-djpeg')
