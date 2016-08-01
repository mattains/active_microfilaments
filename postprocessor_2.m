%% Postprocessor
% This script calculates the mean velocity of the filament over time

%% Setup
close all

nn = size(rstore);
timecount = nn(1);

pos_x = zeros(timecount,1);
pos_y = zeros(timecount,1);
pos_z = zeros(timecount,1);

vel_x = zeros(timecount,1);
vel_y = zeros(timecount,1);
vel_z = zeros(timecount,1);

fprintf('Postprocessing...\n\n')
%%
for i = 1:timecount
    pos_x(i) = mean(rstore(i,:,1));
    pos_y(i) = mean(rstore(i,:,2));
    pos_z(i) = mean(rstore(i,:,3));
end

%%
for i = 2:timecount
    vel_x(i) = pos_x(i) - pos_x(i-1);
    vel_y(i) = pos_y(i) - pos_y(i-1);
    vel_z(i) = pos_z(i) - pos_z(i-1);
end

%%
t = 1:1:timecount;

%% Position vs time
figure(1)

hold on
plot(t,pos_x,'color','r')
plot(t,pos_y,'color','b')
plot(t,pos_z,'color','g')
legend('x','y','z')
title('Position')
ylabel('Coordinate')
xlabel('Time')

hold off

%%
figure(2)

plot3(pos_x,pos_y,pos_z,'o')
title('Path')
xlabel('X')
ylabel('Y')
zlabel('Z')

%% Velocity vs time
figure(3)

hold on
plot(t,vel_x,'color','r')
plot(t,vel_y,'color','b')
plot(t,vel_z,'color','g')
legend('x','y','z')
title('Velocity')
ylabel('Velocity')
xlabel('Time')

hold off
