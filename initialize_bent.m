%% initialize_bent
% Generates 3D coordinates of a line bent 90* in the middle

function [r,init_type] = initialize_bent(filament_param)
%% global dels n amp k
dels = filament_param.dels;
n = filament_param.n;
r = zeros(3*n,1);

% Set initialization type
% 4 for Bent line
init_type = 4;

%% Generation coordinates
for i=1:ceil(n/2)
    r(3*i-2) = (i-1)*dels;
    r(3*i-1) = 0;
    r(3*i  ) = 0;
end

for i= ceil(n/2):n
    r(3*i-2) = (ceil(n/2)-1)*dels;
    r(3*i-1) = (i-ceil(n/2))*dels;
    r(3*i  ) = 0;
end