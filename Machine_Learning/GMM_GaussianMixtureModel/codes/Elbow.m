d1 = load('Assign-3 data\synthetic\C_1_Valid.txt');
[size_ c] = size(d1);
for k=1:1:40
[id1,mu1] = kmeans(d1,k);

s = 0;     
for i=1:k   
    index = 1;
    cluster_point = [];
    for j=1:size_        
       if(id1(j,1) == i)
           cluster_point(index,1) = 0;
           for dim=1:c
           cluster_point(index,1) = cluster_point(index,1)+(d1(j,dim)-mu1(i,dim))^2;
           end
           index = index+1;
       end
    end    
      s = s + sum(cluster_point);    
end
  summ(k,1) = s;
end
x = 1:1:k;
plot(x,summ);