%CLASS 1
d1 = load('Assign-3 data\Image_Data_set\oc_Train.txt');
[size_ c] = size(d1);
dia = 0;
%{
for i=1:23
   mean1 = mean(d1(:,i)); 
   std1 = std(d1(:,i));
   for j=1:size_
      d1(j,i) = (d1(j,i)- mean1)/std1; 
   end
end
%}
k = 10;
[id1,mu1] = kmeans(d1,k);
cov_cluster = zeros(23,23,k);
pi = zeros(k,1);
for i=1:k   
    index = 1;
    cluster_point = [];
    for j=1:size_        
       if(id1(j,1) == i)
           cluster_point(index,:) = d1(j,:);
           index = index+1;
       end
    end
    cov_cluster(:,:,i) = cov(cluster_point); 
    if(dia == 1)
    cov_cluster(:,:,i) =  diag(diag(cov_cluster(:,:,i))); 
    end
    pi(i,1) = index-1/size_; 
end
   
for i=1:k
    
end

[bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM1(d1,mu1,pi,cov_cluster,k,dia);
count = 0;
%EM algo 
for i=1:100  
     
    count = count+1;
    if(bool == 1)
    mu1 = mu1_;
    pi = pi_;
    cov_cluster = cov_cluster_; 
    pdf_clus = pdf_clus_;
    else
        break;
    end
    [bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM1(d1,mu1,pi,cov_cluster,k,dia);
end
c1_mu = mu1_;
c1_pi = pi_;
c1_cov = cov_cluster_;
c1_pdf = pdf_clus_;


%CLASS 2
d2 = load('Assign-3 data\Image_Data_set\str_Train.txt');
[size_ c] = size(d2);
%{
for i=1:23
   mean2 = mean(d2(:,i)); 
   std2 = std(d2(:,i));
   for j=1:size_
      d2(j,i) = (d2(j,i)- mean2)/std2; 
   end
end
%}
[id1,mu1] = kmeans(d2,k);
cov_cluster = zeros(23,23,k);
pi = zeros(k,1);
for i=1:k   
    index = 1;
    cluster_point = [];
    for j=1:size_        
       if(id1(j,1) == i)
           cluster_point(index,:) = d2(j,:);
           index = index+1;
       end
    end
    cov_cluster(:,:,i) = cov(cluster_point); 
    if(dia == 1)
    cov_cluster(:,:,i) =  diag(diag(cov_cluster(:,:,i))); 
    end
    pi(i,1) = index-1/size_; 
end
   
[bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM1(d2,mu1,pi,cov_cluster,k,dia);
count = 0;
%EM algo 
for i=1:100  
     
    count = count+1;
    if(bool == 1)
    mu1 = mu1_;
    pi = pi_;
    cov_cluster = cov_cluster_; 
    pdf_clus = pdf_clus_;
    else
        break;
    end
    [bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM1(d2,mu1,pi,cov_cluster,k,dia);
end
c2_mu = mu1_;
c2_pi = pi_;
c2_cov = cov_cluster_;
c2_pdf = pdf_clus_;

%CLASS 3
d3 = load('Assign-3 data\Image_Data_set\tb_Train.txt');
[size_ c] = size(d3);
%{
for i=1:23
   mean3 = mean(d3(:,i)); 
   std3 = std(d3(:,i));
   for j=1:size_
      d3(j,i) = (d3(j,i)- mean3)/std3; 
   end
end
%}
[id1,mu1] = kmeans(d3,k);
cov_cluster = zeros(23,23,k);
pi = zeros(k,1);
for i=1:k   
    index = 1;
    cluster_point = [];
    for j=1:size_        
       if(id1(j,1) == i)
           cluster_point(index,:) = d3(j,:);
           index = index+1;
       end
    end
    cov_cluster(:,:,i) = cov(cluster_point); 
    if(dia == 1)
    cov_cluster(:,:,i) =  diag(diag(cov_cluster(:,:,i))); 
    end
    pi(i,1) = index-1/size_;
end
   
[bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM1(d3,mu1,pi,cov_cluster,k,dia);
count = 0;
%EM algo 
for i=1:100  
     
    count = count+1;
    if(bool == 1)
    mu1 = mu1_;
    pi = pi_;
    cov_cluster = cov_cluster_; 
    pdf_clus = pdf_clus_;
    else
        break;
    end
    [bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM1(d3,mu1,pi,cov_cluster,k,dia);
end
c3_mu = mu1_;
c3_pi = pi_;
c3_cov = cov_cluster_;
c3_pdf = pdf_clus_;

%ROC

c1_test = load('Assign-3 data\Image_Data_set\oc_Valid.txt');
c2_test = load('Assign-3 data\Image_Data_set\str_Valid.txt');
c3_test = load('Assign-3 data\Image_Data_set\tb_Valid.txt');
[c1_test_size c] = size(c1_test);
[c2_test_size c] = size(c2_test);
[c3_test_size c] = size(c3_test);

targets = zeros(3,c1_test_size+c2_test_size+c3_test_size);
outputs = zeros(3,c1_test_size+c2_test_size+c3_test_size);

for j=1:c1_test_size
    x = c1_test(j,:);
    c1_p = 0;
    c2_p = 0;
    c3_p = 0;
    for i=1:k
    c1_p = c1_p + mvnpdf(x,c1_mu(i,:),c1_cov(:,:,i))*c1_pi(i,1);
    c2_p = c2_p + mvnpdf(x,c2_mu(i,:),c2_cov(:,:,i))*c2_pi(i,1);
    c3_p = c3_p + mvnpdf(x,c3_mu(i,:),c3_cov(:,:,i))*c3_pi(i,1);
    end
    sum = c1_p + c2_p + c3_p;
    c1_p_arr(j,1) = c1_p/sum;
    c2_p_arr(j,1) = c2_p/sum;
    c3_p_arr(j,1) = c3_p/sum;
    targets(1,j) = 1;
end

for j=1:c2_test_size
    x = c2_test(j,:);
    c1_p = 0;
    c2_p = 0;
    c3_p = 0;
    for i=1:k
    c1_p = c1_p + mvnpdf(x,c1_mu(i,:),c1_cov(:,:,i))*c1_pi(i,1);
    c2_p = c2_p + mvnpdf(x,c2_mu(i,:),c2_cov(:,:,i))*c2_pi(i,1);
    c3_p = c3_p + mvnpdf(x,c3_mu(i,:),c3_cov(:,:,i))*c3_pi(i,1);
    end
    sum = c1_p + c2_p + c3_p;
    c1_p_arr(j+c1_test_size,1) = c1_p/sum;
    c2_p_arr(j+c1_test_size,1) = c2_p/sum;
    c3_p_arr(j+c1_test_size,1) = c3_p/sum;
    targets(2,j+c1_test_size) = 1;
   end

for j=1:c3_test_size
    x = c3_test(j,:);
    c1_p = 0;
    c2_p = 0;
    c3_p = 0;
    for i=1:k
    c1_p = c1_p + mvnpdf(x,c1_mu(i,:),c1_cov(:,:,i))*c1_pi(i,1);
    c2_p = c2_p + mvnpdf(x,c2_mu(i,:),c2_cov(:,:,i))*c2_pi(i,1);
    c3_p = c3_p + mvnpdf(x,c3_mu(i,:),c3_cov(:,:,i))*c3_pi(i,1);
    end
    sum = c1_p + c2_p + c3_p;
    c1_p_arr(j+c1_test_size+c2_test_size,1) = c1_p/sum;
    c2_p_arr(j+c1_test_size+c2_test_size,1) = c2_p/sum;
    c3_p_arr(j+c1_test_size+c2_test_size,1) = c3_p/sum;
    targets(3,j+c1_test_size+c2_test_size) = 1;
   end

max_ = max([max(c1_p_arr) max(c2_p_arr) max(c3_p_arr)]);
min_ = min([min(c1_p_arr) min(c2_p_arr) min(c3_p_arr)]);
index = 1;
for th=min_:0.002:1

tp1 = 0;
fp1 = 0;
tn1 = 0;
fn1 = 0;
for j=1:c1_test_size
    c1_p = c1_p_arr(j,1);
    c2_p = c2_p_arr(j,1);
    c3_p = c3_p_arr(j,1);
      if(c1_p > max(c2_p,c3_p))
          outputs(1,j) = 1;
          if(c1_p > th)
              tp1 = tp1+1;              
          else
              fn1 = fn1+1;
          end
      else
          if(c1_p > th)
              fp1 = fp1+1;
          else
              tn1 = tn1+1;
          end
      end
end

for j=1:c2_test_size
    c1_p = c1_p_arr(j+c1_test_size,1);
    c2_p = c2_p_arr(j+c1_test_size,1);
    c3_p = c3_p_arr(j+c1_test_size,1);
      if(max(c2_p) > max(c1_p,c3_p))
          outputs(2,j+c1_test_size) = 1;
          if(c2_p > th)
              tp1 = tp1+1;              
          else
              fn1 = fn1+1;
          end
      else
          if(max(c1_p,c3_p) > th)
              fp1 = fp1+1;
          else
              tn1 = tn1+1;
          end
      end
end

for j=1:c3_test_size
    c1_p = c1_p_arr(j+c1_test_size+c2_test_size,1);
    c2_p = c2_p_arr(j+c1_test_size+c2_test_size,1);
    c3_p = c3_p_arr(j+c1_test_size+c2_test_size,1);
      if(c3_p > max(c1_p,c2_p))
          outputs(3,j+c1_test_size+c2_test_size) = 1;
          if(c3_p > th)
              tp1 = tp1+1;              
          else
              fn1 = fn1+1;
          end
      else
          if(max(c1_p,c2_p) > th)
              fp1 = fp1+1;
          else
              tn1 = tn1+1;
          end
      end
end

tpr(index,1) = tp1/(tp1+fn1);
fpr(index,1) = fp1/(fp1+tn1);
fnr(index,1) = fn1/(fn1+tp1);
index = index+1;
end
figure
plot(fpr(:,1),tpr(:,1));
title('ROC');
figure
plot(fpr(:,1)*100,fnr(:,1)*100);
title('DET');
%[tpr3,fpr3,thresholds] = roc(targets,outputs);

%confusion matrix
figure
plotconfusion(targets,outputs);

