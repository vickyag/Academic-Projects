function [ pico_user_cordis , pbs_users ] = pico_celledge(pbs , pico , pico_radius)

% Range in which the number of pico users are selected at random.
pbs_users = randi([20 , 30]);

% clf
% axis equal
% hold on

x1 = pico(pbs , 1);
y1 = pico(pbs , 2);

% [x,y,z] = cylinder(pico_radius,200);
% plot(x(1,:)+x1,y(1,:)+y1,'--r','LineWidth',2);

for t= 1 : pbs_users
    
    [x y]=cirrdnPJ(x1,y1,pico_radius);
    pico_user_cordis(t,1)=x;
    pico_user_cordis(t,2)=y;
    
%     uncomment the next 2 lines to see the actual distribution of users in
%     Pico and Macro

%     plot(x,y,'o','MarkerFaceColor','y','MarkerEdgeColor','k','MarkerSize',6);
%     title(['Pico Base Station Number ', num2str(pbs)]);
end

%     uncomment the next line to see the actual distribution of users in
%     Pico and Macro

% plot(pico(pbs,1),pico(pbs,2),'^','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerSize',8);

end