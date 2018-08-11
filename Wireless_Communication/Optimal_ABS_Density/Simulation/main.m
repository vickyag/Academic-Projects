clear all;

% Power of macro and pico in dbm 
dbm_macro = 46 ;
dbm_pico = 30 ; 

inter_base_macro = 1500;
macro_radius = inter_base_macro/2;

% pico base station radius
pico_radius = 100;

% setting coodinates of 19 Macros assuming Hexagonal Structure of Cells
macrolist(1,:) = [0.0,0.0];
macrolist(2,:) = [(sqrt(3)*macro_radius)/2 , 1.5*macro_radius];
macrolist(3,:) = [sqrt(3)*macro_radius, 0.0];
macrolist(4,:) = [(sqrt(3)*macro_radius)/2 , -1.5*macro_radius];
macrolist(5,:) = [-(sqrt(3)*macro_radius)/2 , -1.5*macro_radius];
macrolist(6,:) = [-sqrt(3)*macro_radius, 0.0];
macrolist(7,:) = [-(sqrt(3)*macro_radius)/2 , 1.5*macro_radius];
macrolist(8,:) = [0.0, 3*macro_radius];
macrolist(9,:) = [sqrt(3)*macro_radius , 3*macro_radius];
macrolist(10,:) = [1.5*sqrt(3)*macro_radius , 1.5*macro_radius];
macrolist(11,:) = [2*sqrt(3)*macro_radius , 0.0];
macrolist(12,:) = [1.5*sqrt(3)*macro_radius , -1.5*macro_radius];
macrolist(13,:) = [sqrt(3)*macro_radius , -3*macro_radius];
macrolist(14,:) = [0.0, -3*macro_radius];
macrolist(15,:) = [-sqrt(3)*macro_radius , -3*macro_radius];
macrolist(16,:) = [-1.5*sqrt(3)*macro_radius , -1.5*macro_radius];
macrolist(17,:) = [-2*sqrt(3)*macro_radius , 0.0];
macrolist(18,:) = [-1.5*sqrt(3)*macro_radius , 1.5*macro_radius];
macrolist(19,:) = [-sqrt(3)*macro_radius , 3*macro_radius];

% Setting the predefined SINR to Bits per symbol table
sinr2bit(1,:) = [-6.50 , 0.15];
sinr2bit(2,:) = [-4.00 , 0.23];
sinr2bit(3,:) = [-2.60 , 0.38];
sinr2bit(4,:) = [-1.00 , 0.60];
sinr2bit(5,:) = [1.00 , 0.88];
sinr2bit(6,:) = [3.00 , 1.18];
sinr2bit(7,:) = [6.60 , 1.48];
sinr2bit(8,:) = [10.00 , 1.91];
sinr2bit(9,:) = [11.40 , 2.41];
sinr2bit(10,:) = [11.80 , 2.73];
sinr2bit(11,:) = [13.00 , 3.32];
sinr2bit(12,:) = [13.80 , 3.90];
sinr2bit(13,:) = [15.60 , 4.52];
sinr2bit(14,:) = [16.80 , 5.12];
sinr2bit(15,:) = [17.60 , 5.55];

avg_sinrlist_macro = [] ;
avg_sinrlist_pico1 = [] ;
avg_sinrlist_pico2 = [] ;
avg_sinrlist_pico3 = [] ;

% 'simulation' is the number of simulations
for simulation = 1 : 500
    simulation
 macro_sinrlist = [] ;
 physical_setup;
 
 for i = 1 : mbs_users
     
     nr = dbm2wat(dbm_macro) / (norm(macro_user_cordis(i,:)-mac(1,:)))^2;
     dr1 = 0;
     dr2 = 0;
     
     % interference from other Macros
          for j = 2 : 7
                 dr1 = dr1 + ( dbm2wat(dbm_macro) / ( (norm(macrolist(j,:)-macro_user_cordis(i,:))) )^2.15 );
          end 
          
     % interference from own picos
          for k = 1 : 3
                 dr2 = dr2 + ( dbm2wat(dbm_pico)/ ( norm(pico(k,1)-macro_user_cordis(i,:)) )^2.15 );
          end
          
          macro_sinrlist(i,1) = 10 * log10(nr / (dr1 + dr2));
 end
          temp = mean(macro_sinrlist);
          avg_sinrlist_macro(simulation,2) = temp;
          avg_sinrlist_macro(simulation,1) = mbs_users;
          
%     uncomment the next 2 lines to see the actual distribution of users in
%     Pico and Macro

% [x,y,z] = cylinder(macro_radius,200);
% plot(x(1,:)+x1,y(1,:)+y1,'b','LineWidth',2);

          k=1;
          while( temp > sinr2bit(k,1) )
              k = k + 1 ;
          end
          avg_sinrlist_macro(simulation,3) = sinr2bit(k,2);
          
    user1024 = floor(mbs_users/10);
    user512 = floor(mbs_users*2/10);
    user256 = floor(mbs_users*3/10);
    user128 = mbs_users - user1024 - user512 - user256;
    
    rb128 = ceil((1280 / (75*avg_sinrlist_macro(simulation,3)))*user128);
    rb256 = ceil((2560 / (75*avg_sinrlist_macro(simulation,3)))*user256);
    rb512 = ceil((5120 / (75*avg_sinrlist_macro(simulation,3)))*user512);
    rb1024 = ceil((10240 / (75*avg_sinrlist_macro(simulation,3)))*user1024);

    demands_macro(simulation,1) = user128 ;
    demands_macro(simulation,2) = rb128 ;
    
    demands_macro(simulation,3) = user256 ;
    demands_macro(simulation,4) = rb256 ;
    
    demands_macro(simulation,5) = user512 ;
    demands_macro(simulation,6) = rb512 ;
    
    demands_macro(simulation,7) = user1024 ;
    demands_macro(simulation,8) = rb1024 ;
    
    demands_macro(simulation,9) = rb128 + rb256 + rb512 + rb1024 ;
    
    avg_sinrlist_macro(simulation,4) = rb128 + rb256 + rb512 + rb1024 ;

% figure;
[ pico_1_users , pbs_users ] = pico_celledge(1,pico,pico_radius);
[ pico_1_sinrlist , temp1 ] = gen_pico_sinr(1 , pbs_users , mac , pico , pico_1_users , dbm_macro , dbm_pico , sinr2bit);
avg_sinrlist_pico1 = [avg_sinrlist_pico1 ; temp1 ];

% figure;
[ pico_2_users , pbs_users ] = pico_celledge(2,pico,pico_radius);
[ pico_2_sinrlist , temp2 ] = gen_pico_sinr(2 , pbs_users , mac , pico , pico_2_users , dbm_macro , dbm_pico , sinr2bit);
avg_sinrlist_pico2 = [avg_sinrlist_pico2 ; temp2 ];

% figure;
[ pico_3_users , pbs_users ] = pico_celledge(3,pico,pico_radius);
[ pico_3_sinrlist , temp3 ] = gen_pico_sinr(3 , pbs_users , mac , pico , pico_3_users , dbm_macro , dbm_pico , sinr2bit);
avg_sinrlist_pico3 = [avg_sinrlist_pico3 ; temp3];
end

avg_sinr_macro = mean(avg_sinrlist_macro(:,2));
avg_sinr_pico1 = mean(avg_sinrlist_pico1(:,2));
avg_sinr_pico2 = mean(avg_sinrlist_pico2(:,2));
avg_sinr_pico3 = mean(avg_sinrlist_pico3(:,2));

i=1;
while( avg_sinr_macro > sinr2bit(i,1) )
    i = i + 1 ;
end
bps_macro = sinr2bit(i,2);

% gathering demands of RB's from all Pico's
    reqd_rbs = [];
    
    [r,c] = size(avg_sinrlist_pico1);
    
for j = 1 : r
    reqd_rbs(j,1) = avg_sinrlist_pico1(j,4);
    reqd_rbs(j,2) = avg_sinrlist_pico2(j,4);
    reqd_rbs(j,3) = avg_sinrlist_pico3(j,4);
    
    reqd_rbs(j,4) = min(reqd_rbs(j,1:3));
    reqd_rbs(j,5) = max(reqd_rbs(j,1:3));
    reqd_rbs(j,6) = ceil(mean(reqd_rbs(j,1:3)));
end

for i = 1 : simulation
    ax(i,1) = i;
    theoritical_sinr_macro(i,1) = 3.65;
    theoritical_sinr_pico(i,1) = -0.165;
    practical_sinr_macro(i,1) = mean(avg_sinrlist_macro(:,2));
    pico1(i,1) = avg_sinr_pico1;
    pico2(i,1) = avg_sinr_pico2;
    pico3(i,1) = avg_sinr_pico3;
end

graphs;