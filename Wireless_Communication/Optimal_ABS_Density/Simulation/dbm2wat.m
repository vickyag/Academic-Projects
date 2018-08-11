function [ x ] = dbm2wat(p)

x = (10 ^(p/10)) / 1000;

end

% function that returns the power in Watt when given in dbm.