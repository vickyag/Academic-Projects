%data = load('Assignment_Data_Split\Linear_Separable\16_ls.txt');
%data = data./100;
d1 = load('Assignment_Data_Split\Linear_Separable\C_1_Train.txt');
d2 = load('Assignment_Data_Split\Linear_Separable\C_2_Train.txt');
d3 = load('Assignment_Data_Split\Linear_Separable\C_3_Train.txt');


%computing mean and cov for class1
mu11 = mean(d1(:,1));
mu12 = mean(d1(:,2));
mu1 = [mu11 mu12];
cov1 = cov(d1(:,1),d1(:,2));



%computing mean and cov for class2
mu21 = mean(d2(:,1));
mu22 = mean(d2(:,2));
mu2 = [mu21 mu22];
cov2 = cov(d2(:,1),d2(:,2));



%computing mean and cov for class3
mu31 = mean(d3(:,1));
mu32 = mean(d3(:,2));
mu3 = [mu31 mu32];
cov3 = cov(d3(:,1),d3(:,2));
%covariance calculations


fin_cov = (cov1+cov2+cov3)/3;
fin_cov(1,2) = 0;
fin_cov(2,1) = 0;
fin_cov(1,1) = (fin_cov(1,1) + fin_cov(2,2))/2;
fin_cov(2,2) = fin_cov(1,1);


cov1 = fin_cov;
cov2 = fin_cov;
cov3 = fin_cov;
%computing coeff of G(x) for each of the classes
[A1,B1,C1] = gxCoeff(mu1,cov1);
[A2,B2,C2] = gxCoeff(mu2,cov2);
[A3,B3,C3] = gxCoeff(mu3,cov3);

%ezplot decision boundary for all the classes
[ Cx1_2,Cx1_x2,Cx2_2,Cx1,Cx2,Cx0 ] = decBound( A1,B1,C1,A2,B2,C2 );
syms x1 x2
f1(x1,x2) = Cx1_2*(x1)^2 + Cx1_x2*x1*x2 + Cx2_2*(x2)^2 + Cx1*x1 + Cx2*x2 + Cx0;
%ezplot(f1,[5.5,20,-10,12.5]);

[ Cx1_2,Cx1_x2,Cx2_2,Cx1,Cx2,Cx0 ] = decBound( A2,B2,C2,A3,B3,C3 );
syms x1 x2
f2(x1,x2) = Cx1_2*(x1)^2 + Cx1_x2*x1*x2 + Cx2_2*(x2)^2 + Cx1*x1 + Cx2*x2 + Cx0;
%ezplot(f2,[5.5,20,12.5,20]);

[ Cx1_2,Cx1_x2,Cx2_2,Cx1,Cx2,Cx0 ] = decBound( A1,B1,C1,A3,B3,C3 );
syms x1 x2
f3(x1,x2) = Cx1_2*(x1)^2 + Cx1_x2*x1*x2 + Cx2_2*(x2)^2 + Cx1*x1 + Cx2*x2 + Cx0;
%ezplot(f3,[-10,6,-10,12.5]);

%scatter plot
figure
for i=-10:1:20
    for j=-10:1:25
        x = [i,j];
    g1 = x*A1*x' + B1'*x' + C1;
    g2 = x*A2*x' + B2'*x' + C2;
    g3 = x*A3*x' + B3'*x' + C3;
    if g1>g2 && g1>g3
        plot(i,j,'r*');
        hold on
    end
    if g2>g1 && g2>g3
        plot(i,j,'g*');
        hold on
    end
    if g3>g2 && g3>g1
        plot(i,j,'b*');
        hold on
    end
    end
end
scatter(d1(:,1),d1(:,2));
hold on
scatter(d2(:,1),d2(:,2));
hold on
scatter(d3(:,1),d3(:,2));
hold on
%legend('class1','class2','class3');
%ezplot(f1,[5.5,20,-10,12.5]);
%ezplot(f2,[5.5,20,12.5,20]);
%ezplot(f3,[-10,6,-10,12.5]);
plot([mu1(1,1) mu2(1,1)],[mu1(1,2) mu2(1,2)]);
plot([mu1(1,1) mu3(1,1)],[mu1(1,2) mu3(1,2)]);
plot([mu3(1,1) mu2(1,1)],[mu3(1,2) mu2(1,2)]);

%load validation data
t1 = load('Assignment_Data_Split\Linear_Separable\C_1_Valid.txt');
t2 = load('Assignment_Data_Split\Linear_Separable\C_2_Valid.txt');
t3 = load('Assignment_Data_Split\Linear_Separable\C_3_Valid.txt');


%confusion matrix
target = zeros(3,300);
output = zeros(3,300);
for i=1:1:300    
    if i<=100
        x = t1(i,:);
        target(1,i) = 1;
    end
    if i<=200 && i>100
        x = t2(i-100,:);
        target(2,i) = 1;
    end
    if i<=300 && i>200
        x = t3(i-200,:);
        target(3,i) = 1;
    end   
    
    g1 = x*A1*x' + B1'*x' + C1;
    g2 = x*A2*x' + B2'*x' + C2;
    g3 = x*A3*x' + B3'*x' + C3;
 
    if g1>g2 && g1>g3
        output(1,i) = 1;
    end
    if g2>g1 && g2>g3
        output(2,i) = 1;
    end
    if g3>g2 && g3>g1
       output(3,i) = 1;
    end
    
end    
figure
plotconfusion(target,output)

%ROC computation
pos=1;
tp_arr = zeros(1,20);
fp_arr = zeros(1,20);
tn_arr = zeros(1,20);
fn_arr = zeros(1,20);

val_data = [t1;t2;t3];

c1_pdf = mvnpdf(val_data,mu1,cov1);
c2_pdf = mvnpdf(val_data,mu2,cov2);
c3_pdf = mvnpdf(val_data,mu3,cov3);
for th=0:0.002:0.1
    tp = 0;    fn = 0;    fp = 0;    tn = 0;
    count=1;
 for i=1:1:300
   % x = t1(i,:);
   % g1 = x*A1*x' + B1'*x' + C1;
   % g2 = x*A2*x' + B2'*x' + C2;
   % g3 = x*A3*x' + B3'*x' + C3;
    if c1_pdf(i,1)>th 
        if(count<101)
            tp = tp+1;
        else
            fp=fp+1;
        end
    elseif c1_pdf(i,1)<th  
        if(count<101)
            fn = fn+1;
        else
            tn = tn+1;
        end
    end
   count = count+1; 
 end
 tp1 = tp;
 fp1 = fp;
 tn1 = tn;
 fn1 = fn;
 tpr1 = tp1/(tp1+fn1);
 fpr1 = fp1/(tn1+fp1);
 fnr1 = fn1/(tp1+fn1);
 
 tp = 0;    fn = 0;    fp = 0;    tn = 0;
 count = 1;
  for i=1:1:300
     % x = t1(i,:);
   % g1 = x*A1*x' + B1'*x' + C1;
   % g2 = x*A2*x' + B2'*x' + C2;
   % g3 = x*A3*x' + B3'*x' + C3;
    if c2_pdf(i,1)>th 
        if(count>100 && count<201)
            tp = tp+1;
        else
            fp=fp+1;
        end
    elseif c2_pdf(i,1)<th  
        if(count>100 && count<201)
            fn = fn+1;
        else
            tn = tn+1;
        end
    end
    count = count+1; 
  end 
   tp2 = tp;
 fp2 = fp;
 tn2 = tn;
 fn2 = fn;
 tpr2 = tp2/(tp2+fn2);
 fpr2 = fp2/(tn2+fp2);
 fnr2 = fn2/(tp2+fn2);
 
 tp = 0;    fn = 0;    fp = 0;    tn = 0;
 count = 1;
   for i=1:1:300
     % x = t1(i,:);
   % g1 = x*A1*x' + B1'*x' + C1;
   % g2 = x*A2*x' + B2'*x' + C2;
   % g3 = x*A3*x' + B3'*x' + C3;
    if c3_pdf(i,1)>th 
        if(count>200 && count<301)
            tp = tp+1;
        else
            fp=fp+1;
        end
    elseif c3_pdf(i,1)<th  
        if(count>200 && count<301)
            fn = fn+1;
        else
            tn = tn+1;
        end
    end
    
    tp3 = tp;
 fp3 = fp;
 tn3 = tn;
 fn3 = fn;
 tpr3 = tp3/(tp3+fn3);
 fpr3 = fp3/(tn3+fp3);
 fnr3 = fn3/(tp3+fn3);
    
    count = count+1; 
   end 
 
 tp = (tpr1+tpr2+tpr3)/3;
 fp = (fpr1+fpr2+fpr3)/3;
 fn = (fnr1+fnr2+fnr3)/3;

 tp_arr(1,pos) = tp; 
 fp_arr(1,pos) = fp; 
 %tn_arr(1,pos) = tn; 
 fn_arr(1,pos) = fn;
 pos = pos+1;
  
end
%plotting ROC
figure
plot(fp_arr,tp_arr);
%plotting DET
figure
plot(fp_arr,fn_arr);


    fid=fopen('ls_c3_fp_arr.txt','wt');
fprintf(fid, '%f ', fp_arr');
fclose(fid);

fid=fopen('ls_c3_tp_arr.txt','wt');
fprintf(fid, '%f ', tp_arr');
fclose(fid);

fid=fopen('ls_c3_fn_arr.txt','wt');
fprintf(fid, '%f ', fn_arr');
fclose(fid);

%plotting PDF and contour for class 1
figure
min1 = min(d1);
max1 = max(d1);
x11 = min1(1,1):.2:max1(1,1);
x12 = min1(1,2):.2:max1(1,2);
[X1,X2] = meshgrid(x11,x12);
F = mvnpdf([X1(:) X2(:)],mu1,cov1);
F = reshape(F,length(x12),length(x11));
surf(x11,x12,F,'FaceColor','green','EdgeColor','none') 
lighting phong
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
hold on

c1_x1 = X1;
c1_x2 = X2;
c1_F = F;

[w,h] = contour(X1,X2,F);
h.ContourZLevel = -0.02;
hold on


%plotting PDF and contour for class 2
min2 = min(d2);
max2 = max(d2);
x21 = min2(1,1):.2:max2(1,1);
x22 = min2(1,2):.2:max2(1,2);
[X1,X2] = meshgrid(x21,x22);
F = mvnpdf([X1(:) X2(:)],mu2,cov2);
F = reshape(F,length(x22),length(x21));
surf(x21,x22,F,'FaceColor','blue','EdgeColor','none')
lighting phong
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
hold on

c2_x1 = X1;
c2_x2 = X2;
c2_F = F;

[w,h] = contour(X1,X2,F);
h.ContourZLevel = -0.02;
hold on

%plotting PDF and contour for class 3
min3 = min(d3);
max3 = max(d3);
x31 = min3(1,1):.2:max3(1,1);
x32 = min3(1,2):.2:max3(1,2);
[X1,X2] = meshgrid(x31,x32);
F = mvnpdf([X1(:) X2(:)],mu3,cov3);
F = reshape(F,length(x32),length(x31));
surf(x31,x32,F,'FaceColor','red','EdgeColor','none') 
lighting phong
xlabel('x1'); ylabel('x2'); zlabel('Probability Density');
hold on

[w,h] = contour(X1,X2,F);
h.ContourZLevel = -0.02;
hold on
c3_x1 = X1;
c3_x2 = X2;
c3_F = F;

legend('class1','class2','class3');

figure

[w,h] = contour(c1_x1,c1_x2,c1_F);
hold on
[c1_eigVec,c1_eigVal] = eig(cov1);
c1_eigVec = 5*c1_eigVec;
%shifting origin of eigenvectors
c1_eigVec(:,1) = c1_eigVec(:,1)+mu1';
c1_eigVec(:,2) = c1_eigVec(:,2)+mu1';
c1_eigVec = c1_eigVec*1;
plot([mu1(1,1) c1_eigVec(1,1)],[mu1(1,2) c1_eigVec(2,1)]);
hold on
plot([mu1(1,1) c1_eigVec(1,2)],[mu1(1,2) c1_eigVec(2,2)]);
hold on

[w,h] = contour(c2_x1,c2_x2,c2_F);
hold on
[c2_eigVec,c2_eigVal] = eig(cov2);
c2_eigVec = 5*c2_eigVec;
c2_eigVec(:,1) = c2_eigVec(:,1)+mu2';
c2_eigVec(:,2) = c2_eigVec(:,2)+mu2';
%c2_eigVec = c2_eigVec.*2;
plot([mu2(1,1) c2_eigVec(1,1)],[mu2(1,2) c2_eigVec(2,1)]);
hold on
plot([mu2(1,1) c2_eigVec(1,2)],[mu2(1,2) c2_eigVec(2,2)]);
hold on

[w,h] = contour(c3_x1,c3_x2,c3_F);
hold on

[c3_eigVec,c3_eigVal] = eig(cov3);
c3_eigVec = 5*c3_eigVec;
c3_eigVec(:,1) = c3_eigVec(:,1)+mu3';
c3_eigVec(:,2) = c3_eigVec(:,2)+mu3';
%c3_eigVec = 2*c3_eigVec;
plot([mu3(1,1) c3_eigVec(1,1)],[mu3(1,2) c3_eigVec(2,1)]);
hold on
plot([mu3(1,1) c3_eigVec(1,2)],[mu3(1,2) c3_eigVec(2,2)]);
hold on
