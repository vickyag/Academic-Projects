function [ pico_sinrlist , temp_sinrlist_pico ] = gen_pico_sinr(pbs , pbs_users , mac , pico , pico_user_cordis , dbm_macro , dbm_pico, sinr2bit)

pico_sinrlist = [] ;
temp_sinrlist_pico = [] ;

 for i = 1 : pbs_users
     
     nr = dbm2wat(dbm_pico) / ( (norm(pico_user_cordis(i,:)-pico(pbs,:)))^2 );
     
     dr = dbm2wat(dbm_macro) / ( ( norm(mac(1,:)-pico_user_cordis(i,:)) )^2 );
       
     pico_sinrlist(i,1) = 10 * log10(nr / dr);
 end
 
 temp_sinrlist_pico(1,1) = pbs_users;
 
 count=0;
 sum = 0;
 for s = 1 : pbs_users
     if(pico_sinrlist(s,1) < 0 )
         sum = sum + pico_sinrlist(s,1);
         count = count +1;
     end
 end
 
if(count ~= 0) 
    temp_sinrlist_pico(1,2) = sum / count ;
else
    temp_sinrlist_pico(1,2) = 0 ;
end

temp_sinrlist_pico(1,3) = count;

user1024 = floor(count/10);
user512 = floor(count*2/10);
user256 = floor(count*3/10);
user128 = count - user1024 - user512 - user256;

i=1;
while( temp_sinrlist_pico(1,2) > sinr2bit(i,1) )
    i = i + 1 ;
end
bps = sinr2bit(i,2);

rb128 = ceil((1280 / (75*bps))*user128);
rb256 = ceil((2560 / (75*bps))*user256);
rb512 = ceil((5120 / (75*bps))*user512);
rb1024 = ceil((10240 / (75*bps))*user1024);

temp_sinrlist_pico(1,4) = rb128 + rb256 + rb512 + rb1024 ;

end
 