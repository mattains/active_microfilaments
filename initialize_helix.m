%% Initialise helix
%  Generates the coordinates for a helix

function [r,init_type] = initialize_helix(filament_param,driving)
%% Global dels n amp k
dels    = filament_param.dels;
n       = filament_param.n;
radius  = driving.rad;
h       = driving.h_step;

% Preallocate
r       = zeros(3*n,1);
r_rad   = zeros(n,1);

% Set initialization type
% 3 for helix
init_type = 3;

%% Generate helix using radial coordinates and then converting to cartesian

theta = (dels^2+h^2)^0.5/radius; % Change in angle per step

for ii = 1:n
    r_rad(ii) = theta*(ii-1);
    r(3*ii-2) = radius*cos(r_rad(ii));
    r(3*ii-1) = radius*sin(r_rad(ii));
    r(3*ii)   = h*(ii-1);
end

%% 3d plot of generated spiral
temp = zeros(n,3);
for ii = 1:n
    temp(ii,1) =  r(3*ii-2);
    temp(ii,2) =  r(3*ii-1);
    temp(ii,3) =  r(3*ii  );
end
plot3(temp(:,1),temp(:,2),temp(:,3))

