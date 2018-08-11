%to test the function
% clf
% axis equal
% hold on
x1=0;
y1=0;

%  Taking Macro at (0,0) for simulation purpose
mac = [0 , 0];

max_pico_center = macro_radius-pico_radius;

%     uncomment the next 2 lines to see the actual distribution of users in
%     Macro

% [x,y,z] = cylinder(macro_radius,200);
% plot(x(1,:)+x1,y(1,:)+y1,'b','LineWidth',2);

% Range between which number of Macro Users are Selected at random
mbs_users = randi([40 , 60]);

for t= 1 : mbs_users
    
    [x y]=cirrdnPJ(x1,y1,macro_radius);
    macro_user_cordis(t,1)=x;
    macro_user_cordis(t,2)=y;
%     plot(x,y,'o','MarkerFaceColor','g','MarkerEdgeColor','k','MarkerSize',6);

end

temp = [] ;

%for first pico center
[x y]=cirrdnPJ(x1,y1,max_pico_center);
    temp(1,1) = x;
    temp(1,2) = y;
while(norm(temp(1,:)-mac(1,:)) < macro_radius/2 )
    [x y]=cirrdnPJ(x1,y1,max_pico_center);
    temp(1,1) = x;
    temp(1,2) = y;
end
    pico(1,1)=x;
    pico(1,2)=y;
    
%for second pico center
[x y]=cirrdnPJ(x1,y1,max_pico_center);
    temp(1,1) = x;
    temp(1,2) = y;
while(norm(pico(1,:)-temp(1,:)) < 2*pico_radius  || norm(temp(1,:)-mac(1,:)) < macro_radius/2)
    [x y]=cirrdnPJ(x1,y1,max_pico_center);
    temp(1,1) = x;
    temp(1,2) = y;
end
    pico(2,1)=x;
    pico(2,2)=y;
    
%for third pico center
[x y]=cirrdnPJ(x1,y1,max_pico_center);
    temp(1,1) = x;
    temp(1,2) = y;
while(norm(pico(1,:)-temp(1,:)) < 2*pico_radius || norm(pico(2,:)-temp(1,:)) < 2*pico_radius || norm(temp(1,:)-mac(1,:)) < macro_radius/2)
    [x y]=cirrdnPJ(x1,y1,max_pico_center);
    temp(1,1) = x;
    temp(1,2) = y;
end
    pico(3,1)=x;
    pico(3,2)=y;

% plot(pico(:,1),pico(:,2),'^','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',8);
% plot(mac(:,1),mac(:,2),'h','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',12);
% 
% [x,y,z] = cylinder(pico_radius,200);
% plot(x(1,:)+pico(1,1),y(1,:)+pico(1,2),'--r','LineWidth',2);
% 
% [x,y,z] = cylinder(pico_radius,200);
% plot(x(1,:)+pico(2,1),y(1,:)+pico(2,2),'--r','LineWidth',2);
% 
% [x,y,z] = cylinder(pico_radius,200);
% plot(x(1,:)+pico(3,1),y(1,:)+pico(3,2),'--r','LineWidth',2);
