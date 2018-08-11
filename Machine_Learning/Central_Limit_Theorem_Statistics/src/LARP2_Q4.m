N_mat = [1000;10000];
count_confidence = zeros(2,1);
actual_mean = 0;

for k=1:2
    N = N_mat(k);  
    sample_mean = zeros(10000,1);   
    for j=1:10000
        sample=[];
        for i=1:N
            sample(i) = pmf();
            sample_mean(j) = sample_mean(j) + sample(i) ;
        end
        sample_mean(j) = sample_mean(j)/N;
        sample_std = std(sample);
        lower_limit = sample_mean(j)-(1.96*sample_std)/sqrt(N);
        upper_limit = sample_mean(j)+(1.96*sample_std)/sqrt(N);
        interval(j,1,k) = lower_limit;
        interval(j,2,k) = upper_limit;
        if(actual_mean > upper_limit || actual_mean < lower_limit)
            count_confidence(k) = count_confidence(k) + 1;
        end
    end
    figure
    histogram(sample_mean,1000);
end

