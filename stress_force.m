% Function to calculate the stress due to stresslets in an elastic filament
% for a configuration r
%
% Version 0.100

function stress = stress_force(R,sig0,filament_param)

n = filament_param.n;
stress = zeros(3*n,3);
d = 1/3; % d = 1/3 for 3D
% d = 1/2; % d = 1/2 for 2D

for i=1:n           
    % i:i+1 for i == 1
    if i == 1
        t_x = R(3*(i+1) - 2) - R(3*(i) - 2);    % x
        t_y = R(3*(i+1) - 1) - R(3*(i) - 1);    % y
        t_z = R(3*(i+1)    ) - R(3*(i)    );    % z
                
    % i-1:i for i == n
    elseif i == n
        t_x = R(3*(i) - 2) - R(3*(i-1) - 2);    % x
        t_y = R(3*(i) - 1) - R(3*(i-1) - 1);    % y
        t_z = R(3*(i)    ) - R(3*(i-1)    );    % z

    else
    % i-1:i+1 for all else
        t_x = R(3*(i+1) - 2) - R(3*(i-1) - 2);  % x
        t_y = R(3*(i+1) - 1) - R(3*(i-1) - 1);  % y
        t_z = R(3*(i+1)    ) - R(3*(i-1)    );  % z
    end
    
    % Magnitude of the distance between points, to the power of -1 to
    % increase calculation efficiency
    
    mag = (t_x^2 + t_y^2 + t_z^2)^-0.5;
    
    % x,y,z components of the distance of the unit vector    
    t_x = mag*t_x;
    t_y = mag*t_y;
    t_z = mag*t_z;

    t_xy = t_x*t_y;
    t_xz = t_x*t_z;
    t_yz = t_y*t_z;
    
    % Stress(i) = Sig0*(t(i).t(i) - I/d)
    % 
    %                   / |t_xx t_xy t_xz|   | d  0  0 | \
    % Stress(i) = Sig0* | |t_xy t_yy t_yz| - | 0  d  0 | |
    %                   \ |t_xz t_yz t_zz|   | 0  0  d | /

    stress(3*i-2,1) = t_x^2 - d;    % (1,1)
    stress(3*i-2,2) = t_xy;         % (1,2)
    stress(3*i-2,3) = t_xz;         % (1,3)

    stress(3*i-1,1) = t_xy;         % (2,1)
    stress(3*i-1,2) = t_y^2 - d;    % (2,2)
    stress(3*i-1,3) = t_yz;         % (2,3)

    stress(3*i  ,1) = t_xz;         % (3,1)
    stress(3*i  ,2) = t_yz;     	% (3,2)
    stress(3*i  ,3) = t_z^2 - d;    % (3,3)
end
% fprintf('sum of stresses: \n')
stress = sig0*stress;
% sum(stress)
% sum(sum(stress))

end






