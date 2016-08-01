% Function to calculate the 2n X 2n (2D) grand mobility matrix M for a
% given configuration R of the n beads. R is a vector of size 2n containing
% the x,y coordinates. The (2*ii - 1)th element is the xcoordinate of the
% ii-th bead
% grand_fric is the (sparse) grand matrix containing the diagonal elements(matrices)
% of the grand mobility matrix.
%
% Version 0.100

function M = grand_mobility_doublet(R,filament_param)
%global n eps2
n = filament_param.n;

M = zeros(3*n,3*n,3);
%% Calculating each sub-block D_ki via the regularized stresslet formulation
 % Depth index goes here, working in 2D, assume z=0 at all points
    for ii=1:n % Column index
        for kk=1:n % Row index s.t only upper triangular is calculated
            if kk ~= ii
                %% Leave diagonal blocks to zero, diagonal elements are added
                
                x_1 = R(3*ii - 2) - R(3*kk - 2);    % X distance
                y_1 = R(3*ii - 1) - R(3*kk - 1);    % Y distance
                z_1 = R(3*ii    ) - R(3*kk    );   	% Z distance               
                
                rr = x_1^2 + y_1^2 + z_1^2;             % Distance between the points squared
                
                a = -rr;
                b =(rr)^(-5/2);
                
                BB_x2y = 3.*(y_1*x_1^2)*b;                      % xxy
                BB_x2z = 3.*(z_1*x_1^2)*b;                      % xxz
                BB_xy2 = 3.*(x_1*y_1^2)*b;                      % xyy
                BB_xyz = 3.*(x_1*y_1*z_1)*b;                    % xyz
                BB_xz2 = 3.*(x_1*z_1^2)*b;                      % xzz
                BB_y2z = 3.*(z_1*y_1^2)*b;                      % xzz
                BB_yz2 = 3.*(y_1*z_1^2)*b;                      % xzz
                
                
                %%
                M(3*kk-2,3*ii-2,1) = (a*x_1 + 3.*x_1^3)*b;      % (1,1,1)
                M(3*kk-2,3*ii-1,1) = BB_x2y;                    % (1,2,1)
                M(3*kk-2,3*ii  ,1) = BB_x2z;                    % (1,3,1)               
                M(3*kk-1,3*ii-2,1) = BB_x2y;                    % (2,1,1)
                M(3*kk-1,3*ii-1,1) = a*x_1*b + BB_xy2;          % (2,2,1)
                M(3*kk-1,3*ii  ,1) = BB_xyz;                    % (2,3,1)
                M(3*kk  ,3*ii-2,1) = BB_x2z;                    % (3,1,1)
                M(3*kk  ,3*ii-1,1) = BB_xyz;                    % (3,2,1)
                M(3*kk  ,3*ii  ,1) = a*x_1*b + BB_xz2;          % (3,3,1)
                
                %%             
                M(3*kk-2,3*ii-2,2) = a*y_1*b + BB_x2y;          % (1,1,2)
                M(3*kk-2,3*ii-1,2) = BB_xy2;                    % (1,2,2)
                M(3*kk-2,3*ii  ,2) = BB_xyz;                    % (1,3,2)               
                M(3*kk-1,3*ii-2,2) = BB_xy2;                    % (2,1,2)
                M(3*kk-1,3*ii-1,2) = (a*y_1 + 3.*y_1^3)*b;      % (2,2,2)
                M(3*kk-1,3*ii  ,2) = BB_y2z;                    % (2,3,2)
                M(3*kk  ,3*ii-2,2) = BB_xyz;                    % (3,1,2)
                M(3*kk  ,3*ii-1,2) = BB_y2z;                    % (3,2,2)
                M(3*kk  ,3*ii  ,2) = a*y_1*b + BB_yz2;          % (3,3,2)
                
                %%
                M(3*kk-2,3*ii-2,3) = a*z_1*b + BB_x2z;          % (1,1,3)
                M(3*kk-2,3*ii-1,3) = BB_xyz;                    % (1,2,3)
                M(3*kk-2,3*ii  ,3) = BB_xz2;                    % (1,3,3)               
                M(3*kk-1,3*ii-2,3) = BB_xyz;                    % (2,1,3)
                M(3*kk-1,3*ii-1,3) = a*z_1*b + BB_y2z;          % (2,2,3)
                M(3*kk-1,3*ii  ,3) = BB_yz2;                    % (2,3,3)
                M(3*kk  ,3*ii-2,3) = BB_xz2;                    % (3,1,3)
                M(3*kk  ,3*ii-1,3) = BB_yz2;                    % (3,2,3)
                M(3*kk  ,3*ii  ,3) = (a*z_1 + 3.*z_1^3)*b;      % (3,3,3)
                
            end
        end
    end


M = M/(8*pi);
end