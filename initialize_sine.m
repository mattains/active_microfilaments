function [r,init_type] = initialize_sine(filament_param,driving)
%%global dels n amp k
dels = filament_param.dels;
n = filament_param.n;
k = driving.k;
amp = driving.amp;
xcord = 0;
r = zeros(3*n,1);

% Set initialization type
% 1 for Sine wave
init_type = 1;

%%
for i=1:n
    r(3*i - 2) = xcord;
    r(3*i - 1) = (amp/6)*sin(k*r(3*i-2));
    dydx = k*(amp/6)*cos(k*r(3*i-2)); 
    incr = dels*sqrt(1/(1+dydx^2));
    xcord = xcord + incr;
end

%{
R_temp = zeros(length(2*n),1);
for ii = 1: length(r)/3
    R_temp(2*ii-1) = r(3*ii-2);
    R_temp(2*ii) = r(3*ii-1);    
end
r = R_temp; %%
%}




