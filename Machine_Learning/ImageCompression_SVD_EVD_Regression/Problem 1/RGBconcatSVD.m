im = imread('16rec.jpg');
[f,s,t] = size(im);
R_band = uint32(im(:,:,1));
G_band = uint32(im(:,:,2));
B_band = uint32(im(:,:,3));

RGBcat(:,:) = R_band.*2^16 + G_band.*2^8 + B_band;
[U,S,V] = mySVD(double(RGBcat));

error = zeros(s,1);

for i=1:1:s
    ns = S(1:i,1:i);
    nu = U(:,1:i);
    nv = V(:,1:i);
    ni = nu*ns*nv';
    ni = uint32(ni);
    nicat(:,:,3) = uint8(bitand(ni,255));
    nicat(:,:,2) = uint8(bitand(bitshift(ni,-8),255));
    nicat(:,:,1) = uint8(bitand(bitshift(ni,-16),255));
    
    h = figure;
    subplot(1,2,1);    
    imshow(nicat); 
    title('Reconstructed Image')
    subplot(1,2,2);
    imshow(im-nicat);
    title('Errored Image')
    str1 = 'RGBConcatRecSVD\N';
    str2 = int2str(i);
    str = strcat(str1,str2);
    print(h,str,'-djpeg')
    error(i,1) = sqrt(immse(im,nicat));
end
p = figure;
plot((1:s),error);
title('First N singular values Vs RMSE')
xlabel('N')
ylabel('RMSE')
print(p,'RGBConcatRecSVD\ErrorPlotRGBConcatSVD','-djpeg')
