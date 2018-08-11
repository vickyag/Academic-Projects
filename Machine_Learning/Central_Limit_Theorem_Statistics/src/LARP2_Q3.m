N_mat = [10;100;1000;10000];
count_confidence = zeros(4,1);
mean_99_01 = zeros(4,1);
mean_90_10 = zeros(4,1);
actual_mean = 10;
for k=1:4
    N = N_mat(k);
    sample_mean = zeros(10000,1);   
    for j=1:10000
        sample=[];
        for i=1:N
            sample(i) = poissonGenerator();
            sample_mean(j) = sample_mean(j) + sample(i) ;
        end
        sample_mean(j) = sample_mean(j)/N;
        sample_std = std(sample);
        lower_limit = sample_mean(j)-(1.96*sample_std)/sqrt(N);
        upper_limit = sample_mean(j)+(1.96*sample_std)/sqrt(N);
        if(actual_mean > upper_limit || actual_mean < lower_limit)
            count_confidence(k) = count_confidence(k) + 1;
        end
        if(sample_mean(j) >= 9.99 && sample_mean(j) <= 10.01)
           mean_99_01(k) = mean_99_01(k) + 1; 
        end
        if(sample_mean(j) >= 9.9 && sample_mean(j) <= 10.1)
           mean_90_10(k) = mean_90_10(k) + 1; 
        end
    end
    figure
    histogram(sample_mean,1000);
end

