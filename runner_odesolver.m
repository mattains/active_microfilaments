%% 
% Routine to call the ODE solver with velocityfunction.m as the RHS
% function
%
% Version 0.100

clc
clear
close all

tic

%% Parameters;
parameters_bendingnondim;
filament_param = struct('n',n,'dels',dels,'eps2',eps2,'n_p',n_p,'dels_p',dels_p);
stiffness = struct('s1',s1,'s2',s2);
driving = struct('k',k,'w',w,'amp',amp,'h_step',h_step,'rad',rad);    
flags = struct('bendflag',bendflag,'stretchflag',stretchflag);

% Time span for integration
tspan = 0:timestep:time;
 
%% Initialization
% [R0,init_type] = initialize_sine(filament_param,driving);     % 1
% [R0,init_type] = initialize_straight(filament_param);         % 2
[R0,init_type] = initialize_helix(filament_param,driving);    % 3
% [R0,init_type] = initialize_bent(filament_param);             % 4

[FP0] = initialize_fluid_field(filament_param);

% Create the local friction matrix
grandfric = grand_friction(filament_param,delta);

%% Integrate the position update ODEs, march in time
%opts = odeset('RelTol',1e-12,'AbsTol',1e-16);
[T,Rfinal] = ode15s(@(t,R)velocityfunction_mobmatrix(t,R,grandfric,sig0,filament_param,stiffness,driving,flags),tspan,R0);

%% Convert R to rstore for postprocessing
% i-th row of R contains solution at timestep i 
rstore = zeros(timeno+1,n,3);
for i=1:timeno+1
   for j=1:n
    rstore(i,j,1) = Rfinal(i,3*j - 2);
    rstore(i,j,2) = Rfinal(i,3*j - 1);
    rstore(i,j,3) = Rfinal(i,3*j);
   end
end
activity = sig0/(len*s2);
fprintf('Activity number:\t%f\n',activity')

toc
time_total = toc;