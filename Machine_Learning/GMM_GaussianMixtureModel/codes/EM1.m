function [bool,mu1,pi,cov_cluster,pdf_clus,dia] = EM1(d1,mu1,pi,cov_cluster,k,dia)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 [size_ c] = size(d1);
 
 for i=1:k
    pdf_clus(:,i) = mvnpdf(d1,mu1(i,:),cov_cluster(:,:,i))*pi(i,1); 
 end

npdf = sum(pdf_clus,2);
ln_npdf = log(npdf);
log_likelihood = sum(ln_npdf);
gamma = zeros(size_,k);
for i=1:size_
    for j=1:k
    gamma(i,j) = pdf_clus(i,j)/npdf(i,1);
    end
end

N =  sum(gamma)';
for i=1:k
    mu1(i,:) = (gamma(:,i)'*d1)/N(i,1);
end

pi = N/size_;

temp1 = zeros(size_,23,k);
temp2 = zeros(size_,23,k);
for i=1:size_
    for j=1:k
    temp1(i,:,j) = d1(i,:)-mu1(j,:);
    temp2(i,:,j) = temp1(i,:,j)*gamma(i,j);
    end
end 

for j=1:k
   cov_cluster(:,:,j) = (temp2(:,:,j)'*temp1(:,:,j))/N(j,1);
   if(dia == 1)
    cov_cluster(:,:,j) =  diag(diag(cov_cluster(:,:,j))); 
   end
end

 for i=1:k
    pdf_clus(:,i) = mvnpdf(d1,mu1(i,:),cov_cluster(:,:,i))*pi(i,1); 
 end

npdf = sum(pdf_clus,2);
ln_npdf = log(npdf);
new_log_likelihood = sum(ln_npdf);

if(abs(new_log_likelihood-log_likelihood) > 0.1)
bool = 1;
else
bool = 0;    
end

end

