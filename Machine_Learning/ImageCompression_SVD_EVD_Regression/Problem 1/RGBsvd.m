im = imread('16rec.jpg');
[f,s,t] = size(im);
im = im2double(im);
R_band = im(:,:,1);
G_band = im(:,:,2);
B_band = im(:,:,3);

[Ur,Sr,Vr] = mySVD(R_band);
[Ug,Sg,Vg] = mySVD(G_band);
[Ub,Sb,Vb] = mySVD(B_band);

error = zeros(s,1);

for i=1:1:s
    nsr = Sr(1:i,1:i);
    nur = Ur(:,1:i);
    nvr = Vr(:,1:i);
    nir = nur*nsr*nvr';
    
    nsg = Sg(1:i,1:i);
    nug = Ug(:,1:i);
    nvg = Vg(:,1:i);
    nig = nug*nsg*nvg';
    
    nsb = Sb(1:i,1:i);
    nub = Ub(:,1:i);
    nvb = Vb(:,1:i);
    nib = nub*nsb*nvb';
    
    ni(:,:,1) = nir;
    ni(:,:,2) = nig;
    ni(:,:,3) = nib;
    
    h = figure;
    subplot(1,2,1);    
    imshow(ni); 
    title('Reconstructed Image')
    subplot(1,2,2);
    imshow(im-ni);
    title('Errored Image')
    str1 = 'RGBRecSVD\N';
    str2 = int2str(i);
    str = strcat(str1,str2);
    print(h,str,'-djpeg')
    error(i,1) = sqrt(immse(im,ni));
end
p = figure;
plot((1:s),error);
title('First N singular values Vs RMSE')
xlabel('N')
ylabel('RMSE')
print(p,'RGBRecSVD\ErrorPlotRGBSVD','-djpeg')
