%% Function to calculate the stretching forces in an elastic filament for a
%  configuration r

function fstr = stretch_force_2(R,s1,filament_param)
%global dels k w n s2 s1 amp
dels = filament_param.dels;
n = filament_param.n;
fstr = zeros(3*n,1);
vector = zeros(n-1,3);
dist = zeros(n-1,1);

%%
for ii = 1:n-1
    % Matrix of displacement vectors
    vector(ii,:) = [R(3*(ii+1) - 2), R(3*(ii+1) - 1), R(3*(ii+1))] - [R(3*ii - 2), R(3*ii - 1), R(3*ii)];
    % Matrix of the magnitudes of above vectors
    dist(ii) = (vector(ii,1)^2 + vector(ii,2)^2 + vector(ii,3)^2)^0.5;
    % Convert to unit vector
    for jj = 1:3
        vector(ii,jj) = vector(ii,jj)/dist(ii);
    end
end

%% i = 2:(n-1)                  
for ii = 2:(n-1)         
    
    %   beads (n)
    %   1   2   3
    %   O---O---O
    %     1   2
    %  links (dist)

    mag_1 = dist(ii-1) - dels;  % Link 1 
    mag_2 = dist(ii  ) - dels;  % Link 2

    fstr(3*ii - 2) = -mag_1*vector(ii-1,1) + mag_2*vector(ii,1);   % x 
    fstr(3*ii - 1) = -mag_1*vector(ii-1,2) + mag_2*vector(ii,2);   % y
    fstr(3*ii    ) = -mag_1*vector(ii-1,3) + mag_2*vector(ii,3);   % z    
end

%% i = 1
mag_1 = dist(1) - dels;

fstr(1) = mag_1*vector(1,1);   % x
fstr(2) = mag_1*vector(1,2);   % y
fstr(3) = mag_1*vector(1,3);   % z


%% i = n
mag_2 = dist(n-1) - dels;

fstr(3*n-2) = -mag_2*vector(n-1,1);   % x
fstr(3*n-1) = -mag_2*vector(n-1,2);   % y
fstr(3*n  ) = -mag_2*vector(n-1,3);   % z

%%
fstr = s1*fstr;

end























