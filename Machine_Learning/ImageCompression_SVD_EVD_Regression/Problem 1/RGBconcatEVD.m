im = imread('16 sq.jpg');
[f,s,t] = size(im);
R_band = uint32(im(:,:,1));
G_band = uint32(im(:,:,2));
B_band = uint32(im(:,:,3));

RGBcat(:,:) = R_band.*2^16 + G_band.*2^8 + B_band;
[E,S,E_inv] = myEVD(double(RGBcat),f,s);
error = zeros(s,1);

for i=1:1:s
    ns = S(1:i,1:i);
    ne = E(:,1:i);
    ne_inv = E_inv(1:i,:);
    ni = ne*ns*ne_inv;
    if(f ~= s)
        t = pinv(double(RGBcat'));
    ni = t*ni;
    end
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
    str1 = 'RGBConcatSqEVD\N';
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
print(p,'RGBConcatSqEVD\ErrorPlotRGBConcatSVD','-djpeg')
