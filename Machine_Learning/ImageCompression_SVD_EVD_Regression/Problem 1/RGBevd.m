im = imread('16 sq.jpg');
[f,s,t] = size(im);
im = im2double(im);
R_band = im(:,:,1);
G_band = im(:,:,2);
B_band = im(:,:,3);

[Er,Sr,E_invr] = myEVD(R_band,f,s);
[Eg,Sg,E_invg] = myEVD(G_band,f,s);
[Eb,Sb,E_invb] = myEVD(B_band,f,s);

error = zeros(s,1);

for i=1:1:s
    nsr = Sr(1:i,1:i);
    ner = Er(:,1:i);
    ne_invr = E_invr(1:i,:);
    nir = ner*nsr*ne_invr;
    
    nsg = Sg(1:i,1:i);
    neg = Eg(:,1:i);
    ne_invg = E_invg(1:i,:);
    nig = neg*nsg*ne_invg;
    
    nsb = Sb(1:i,1:i);
    neb = Eb(:,1:i);
    ne_invb = E_invb(1:i,:);
    nib = neb*nsb*ne_invb;
   if(f ~= s)
        t = pinv(R_band');
    nir = t*nir;
    t = pinv(G_band');
    nig = t*nig;
    t = pinv(B_band');
    nib = t*nib;
    end
    
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
    str1 = 'RGBSqEVD\N';
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
print(p,'RGBSqEVD\ErrorPlotRGBSVD','-djpeg')

