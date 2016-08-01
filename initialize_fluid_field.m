function [fp] = initialize_fluid_field(filament_param)

% Setup
dels_p = filament_param.dels_p;
n_p = filament_param.n_p;

fp = zeros(n_p(1)*n_p(2)*n_p(3),4); % [x,y,z,id]

% Create initial fluid field
for kk = 1:n_p(3)           % z
    for jj = 1:n_p(2)       % y
        for ii = 1:n_p(1)   % x
            xyz = (kk-1)*n_p(2)*n_p(1) + (jj-1)*n_p(1) + ii;
            fp(xyz,1) = dels_p(1)*(ii - 1);    % x
            fp(xyz,2) = dels_p(2)*(jj - 1);    % y
            fp(xyz,3) = dels_p(3)*(kk - 1);    % z
            fp(xyz,4) = xyz;    % id
        end
    end    
end

% Centre the field on (0,0)
fp(:,1) = fp(:,1) - (n_p(1)-1)*dels_p(1)/2;    % x
fp(:,2) = fp(:,2) - (n_p(2)-1)*dels_p(2)/2;    % y
fp(:,3) = fp(:,3) - (n_p(3)-1)*dels_p(3)/2;    % z
