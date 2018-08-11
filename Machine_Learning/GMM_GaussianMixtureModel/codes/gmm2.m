%CLASS 1
d1 = load('Assign-3 data\synthetic\C_1_Train.txt');
[size_ c] = size(d1);
dia = 0;
k = 10;
[id1,mu1] = kmeans(d1,k);
cov_cluster = zeros(2,2,k);
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
    cov_cluster(:,:,i) = cov(cluster_point(:,1),cluster_point(:,2)); 
    if(dia == 1)
    cov_cluster(:,:,i) =  diag(diag(cov_cluster(:,:,i))); 
    end
    pi(i,1) = index-1/size_; 
end
   
[bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM2(d1,mu1,pi,cov_cluster,k,dia);
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
    [bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM2(d1,mu1,pi,cov_cluster,k,dia);
end
c1_mu = mu1_;
c1_pi = pi_;
c1_cov = cov_cluster_;
c1_pdf = pdf_clus_;


%CLASS 2
d2 = load('Assign-3 data\synthetic\C_2_Train.txt');
[size_ c] = size(d2);
[id1,mu1] = kmeans(d2,k);
cov_cluster = zeros(2,2,k);
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
    cov_cluster(:,:,i) = cov(cluster_point(:,1),cluster_point(:,2)); 
    if(dia == 1)
    cov_cluster(:,:,i) =  diag(diag(cov_cluster(:,:,i))); 
    end
    pi(i,1) = index-1/size_; 
end
   
[bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM2(d2,mu1,pi,cov_cluster,k,dia);
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
    [bool,mu1_,pi_,cov_cluster_,pdf_clus_,dia] = EM2(d2,mu1,pi,cov_cluster,k,dia);
end
c2_mu = mu1_;
c2_pi = pi_;
c2_cov = cov_cluster_;
c2_pdf = pdf_clus_;
%{
%decision region
figure
for t=-15:0.1:15
    for j=-15:0.1:15
        x = [t j];
        c1_p = 0;
        c2_p = 0;
    for i=1:k
    c1_p = c1_p + mvnpdf(x,c1_mu(i,:),c1_cov(:,:,i))*c1_pi(i,1);
    c2_p = c2_p + mvnpdf(x,c2_mu(i,:),c2_cov(:,:,i))*c2_pi(i,1);
    end
      if(c1_p > c2_p)
        plot(t,j,'y*');
        hold on
      else
        plot(t,j,'g*');
        hold on
      end
    end
end
%scattering data
scatter(d1(:,1),d1(:,2));
hold on
scatter(d2(:,1),d2(:,2));
hold on

%plotting contour class 1
plot(c1_mu(:,1),c1_mu(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3);
 hold on
%} 
for i=1:k   
    index = 1;
    cluster_point = [];
    for j=1:size_        
       if(id1(j,1) == i)
           cluster_point(index,:) = d1(j,:);
           index = index+1;
       end
    end
    min1 = min(cluster_point);
max1 = max(cluster_point);
x11 = min1(1,1):.2:max1(1,1);
x12 = min1(1,2):.2:max1(1,2);
[X1,X2] = meshgrid(x11,x12);
F = mvnpdf([X1(:) X2(:)],c1_mu(i,:),c1_cov(:,:,i));
F = reshape(F,length(x12),length(x11));
c1_x1 = X1;
c1_x2 = X2;
c1_F = F;
[w,h] = contour(X1,X2,F,'k');
%h.ContourZLevel = -0.02;
hold on
end


%plotting contour class 2
plot(c2_mu(:,1),c2_mu(:,2),'mx',...
     'MarkerSize',15,'LineWidth',3);
 hold on
 
for i=1:k   
    index = 1;
    cluster_point = [];
    for j=1:size_        
       if(id1(j,1) == i)
           cluster_point(index,:) = d2(j,:);
           index = index+1;
       end
    end
    min1 = min(cluster_point);
max1 = max(cluster_point);
x11 = min1(1,1):.2:max1(1,1);
x12 = min1(1,2):.2:max1(1,2);
[X1,X2] = meshgrid(x11,x12);
F = mvnpdf([X1(:) X2(:)],c2_mu(i,:),c2_cov(:,:,i));
F = reshape(F,length(x12),length(x11));
c1_x1 = X1;
c1_x2 = X2;
c1_F = F;
[w,h] = contour(X1,X2,F,'m');
%h.ContourZLevel = -0.02;
hold on
end

%ROC

c1_test = load('Assign-3 data\synthetic\C_1_Test.txt');
c2_test = load('Assign-3 data\synthetic\C_2_Test.txt');
[c1_test_size c] = size(c1_test);
[c2_test_size c] = size(c2_test);
%normallizing data
%{
mean1 = mean(c1_test);
mean2 = mean(c2_test);
std1 = std(c1_test);
std2 = std(c2_test);
for j=1:c1_test_size
    c1_test(j,1) = (c1_test(j,1)-mean1(1,1))/std1(1,1);
    c1_test(j,2) = (c1_test(j,2)-mean1(1,2))/std1(1,2);
end
for j=1:c2_test_size
    c2_test(j,1) = (c2_test(j,1)-mean2(1,1))/std2(1,1);
    c2_test(j,2) = (c2_test(j,2)-mean2(1,2))/std2(1,2);
end
%}
targets = zeros(2,c1_test_size+c2_test_size);
outputs = zeros(2,c1_test_size+c2_test_size);

for j=1:c1_test_size
    x = c1_test(j,:);
    c1_p = 0;
    c2_p = 0;
    for i=1:k
    c1_p = c1_p + mvnpdf(x,c1_mu(i,:),c1_cov(:,:,i))*c1_pi(i,1);
    c2_p = c2_p + mvnpdf(x,c2_mu(i,:),c2_cov(:,:,i))*c2_pi(i,1);
    end
    sum = c1_p + c2_p;
    c1_p_arr(j,1) = c1_p/sum;
    c2_p_arr(j,1) = c2_p/sum;
    targets(1,j) = 1;
   % outputs(1,j) = c1_p/sum;
   % outputs(2,j) = c2_p/sum;
end

for j=1:c2_test_size
    x = c2_test(j,:);
    c1_p = 0;
    c2_p = 0;
    for i=1:k
    c1_p = c1_p + mvnpdf(x,c1_mu(i,:),c1_cov(:,:,i))*c1_pi(i,1);
    c2_p = c2_p + mvnpdf(x,c2_mu(i,:),c2_cov(:,:,i))*c2_pi(i,1);
    end
    sum = c1_p + c2_p;
    c1_p_arr(j+c1_test_size,1) = c1_p/sum;
    c2_p_arr(j+c1_test_size,1) = c2_p/sum;
    targets(2,j+c1_test_size) = 1;
   % outputs(1,j+c1_test_size) = c1_p/sum;
   % outputs(2,j+c1_test_size) = c2_p/sum;
end

max_ = max([max(c1_p_arr) max(c2_p_arr)]);
min_ = min([min(c1_p_arr) min(c2_p_arr)]);
index = 1;
for th=min_:0.002:1
tp = 0;
fp = 0;
tn = 0;
fn = 0;
for j=1:c1_test_size
    c1_p = c1_p_arr(j,1);
    c2_p = c2_p_arr(j,1);
      if(c1_p > c2_p)
          outputs(1,j) = 1;
          if(c1_p > th)
              tp = tp+1;
          else
              fn = fn+1;
          end
      else
          if(c2_p > th)
              fp = fp+1;
          else
              tn = tn+1;
          end
      end
end

for j=1:c2_test_size
    c1_p = c1_p_arr(j+c1_test_size,1);
    c2_p = c2_p_arr(j+c1_test_size,1);
      if(c2_p > c1_p)
          outputs(2,j+c1_test_size) = 1;
          if(c2_p > th)
              tp = tp+1;
          else
              fn = fn+1;
          end
      else
          if(c1_p > th)
              fp = fp+1;
          else
              tn = tn+1;
          end
      end
end

tpr(index,1) = tp/(tp+fn);
fpr(index,1) = fp/(fp+tn);
fnr(index,1) = fn/(fn+tp);
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