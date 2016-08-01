function [r, init_type] = initialize_straight(filament_param)
%global dels n amp k
dels = filament_param.dels;
n = filament_param.n;
r = zeros(3*n,1);

% Set initialization type
% 2 for helix
init_type = 2;

for i=1:n   
    r(3*i-2) = (i-1)*(dels);
    r(3*i-1) = 0;
    r(3*i  ) = 0;
end