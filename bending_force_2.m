%% Function to calculate the bending force for an actively driven elastic
%  filament with configuration r at time t
%
% Version 0.100

function fb = bending_force_2(R,s2,filament_param)
% global dels k w n s2 s1 amp
dels = filament_param.dels;
n = filament_param.n;
% w = driving.w;

fb = zeros(3*n,1);
b_m = zeros(n-1,3);
a_m = zeros(n-1,1);
d_m = zeros(n,3);

%% Bending Forces
%%
for ii = 1:(n-1)
    % Bond vector
    b_m(ii,:) =  [R(3*(ii+1) - 2), R(3*(ii+1) - 1), R(3*(ii+1))] - [R(3*ii - 2), R(3*ii - 1), R(3*ii    )];
end

% ii = 1 and ii = n forces are just zero?

for ii = 2:(n-1)    
    % a_m = (a.b/|A|*|B|) = cos(-)
    a_m(ii) = dot(b_m(ii-1,:),b_m(ii,:))/((sum(b_m(ii-1,:).^2)^0.5)*(sum(b_m(ii,:).^2)^0.5));
    
    % Direction of forcing
    d_mid = ([R(3*(ii+1) - 2), R(3*(ii+1) - 1), R(3*(ii+1))] + [R(3*(ii-1) - 2), R(3*(ii-1) - 1), R(3*(ii-1))])/2;
    d_m(ii,:) = d_mid - [R(3*ii - 2), R(3*ii - 1), R(3*ii)];
    d_m_mag = d_m(ii,1)^2 + d_m(ii,2)^2 + d_m(ii,3)^2;
    if d_m_mag ~= 0
        d_m(ii,:) = d_m(ii,:) * d_m_mag^-0.5;
    end
    
    % Magnitude of the force
    fb_mag = (1 - a_m(ii));

    % Apply the force on the middle bead
    fb(3*ii - 2) = fb(3*ii - 2) - fb_mag * d_m(ii,1);
    fb(3*ii - 1) = fb(3*ii - 1) - fb_mag * d_m(ii,2);
    fb(3*ii    ) = fb(3*ii    ) - fb_mag * d_m(ii,3);
    
    % Apply forcing on peripheral beads
    % Previous bead
    fb(3*ii - 5) = fb(3*ii - 5) + fb_mag * d_m(ii,1) / 2;
    fb(3*ii - 4) = fb(3*ii - 4) + fb_mag * d_m(ii,2) / 2;
    fb(3*ii - 3) = fb(3*ii - 3) + fb_mag * d_m(ii,3) / 2;
    
    % Next bead
    fb(3*ii + 1) = fb(3*ii + 1) + fb_mag * d_m(ii,1) / 2;
    fb(3*ii + 2) = fb(3*ii + 2) + fb_mag * d_m(ii,2) / 2;
    fb(3*ii + 3) = fb(3*ii + 3) + fb_mag * d_m(ii,3) / 2;
end
      
fb =  -s2*fb/dels;
% fprintf('sum of bending: %f\n',sum(fb))
end
        
        
















