% Function to calculate the 3n X 3n (3D) grand mobility matrix M for a
% given configuration R of the n beads. R is a vector of size 2n containing
% the x,y coordinates. The (2*ii - 1)th element is the xcoordinate of the
% ii-th bead
% grand_fric is the (sparse) grand matrix containing the diagonal elements(matrices)
% of the grand mobility matrix.
%
% Version 0.100

function M = grand_mobility(R,grand_fric,filament_param)
%global n eps2
n = filament_param.n;
% eps2 = filament_param.eps2;

M = zeros(3*n,3*n);
%% Calculating each sub-block D_ki via the regularized stokeslet formulation
for ii=1:n % Column index
    for kk=1:(ii-1) % Row index s.t only upper triangular is calculated
        % Leave diagonal blocks to zero, diagonal elements are added
        % separately      
     
        x_1 = (R(3*ii - 2) - R(3*kk - 2))^2;
        y_1 = (R(3*ii - 1) - R(3*kk - 1))^2;
        z_1 = (R(3*ii    ) - R(3*kk    ))^2;
        
        rr = x_1 + y_1 + z_1; % distance between the points squared
        a = rr;
        b =(rr)^(-3/2);
        BB_xy = (R(3*ii - 2) - R(3*kk - 2))*(R(3*ii - 1) - R(3*kk - 1))*b;
        BB_xz = (R(3*ii - 2) - R(3*kk - 2))*(R(3*ii    ) - R(3*kk    ))*b;
        BB_yz = (R(3*ii - 1) - R(3*kk - 1))*(R(3*ii    ) - R(3*kk    ))*b;
        % Elements of D_ki       
        
        %{
        / xx xy xz \
        | xy yy yz | 
        \ xz yz zz /
        %}
        
        M(3*kk - 2,3*ii - 2) = (a + x_1)*b;     % (1,1) xx       
        M(3*kk - 2,3*ii - 1) = BB_xy;           % (1,2) xy
        M(3*kk - 2,3*ii    ) = BB_xz;           % (1,3) xz
        M(3*kk - 1,3*ii - 2) = BB_xy;           % (2,1) xy
        M(3*kk - 1,3*ii - 1) = (a + y_1)*b;     % (2,2) yy
        M(3*kk - 1,3*ii    ) = BB_yz;           % (2,3) yz
        M(3*kk    ,3*ii - 2) = BB_xz;           % (3,1) xz
        M(3*kk    ,3*ii - 1) = BB_yz;           % (3,2) yz
        M(3*kk    ,3*ii - 1) = (a + z_1)*b;     % (3,3) zz
    end
end

%% Add the diagonal elements
M = (M + transpose(M))/(8*pi) + full(grand_fric);   
% pause;
% M = M/(8*pi) + full(grand_fric);
end
