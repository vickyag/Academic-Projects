function [ X ] = pmfGenerator()

 A = 3/pi^2;
u = rand(1);

sum = 0;
if(u < 0.5)
    k = 1;
    while(true)
         sum = sum + A/k^2;
        if(0.5 - sum  < u)
           X = -k;
           break;
        end
        k = k+1;
    end
elseif(u >= 0.5)
        k = 1;
    while(true)
         sum = sum + A/k^2;
        if(sum + 0.5 > u)
           X = k;
           break;
        end
        k = k+1;
    end
end

end

