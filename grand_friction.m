% Function to create the grand friction matrix (diagonal elements of the
% grand mobility matrix). 
%
% Version 0.100

function gf = grand_friction(filament_param,delta)
%global n eps   
n = filament_param.n;
%% Isotropic bead friction 4*pi*eps 
        %aa =eps;
        %aa = 1;
        zeta = 4*pi*delta;
        gff = (1/zeta)*eye(3*n,3*n);
%         gff = zeros(3*n,3*n);
        gf = sparse(gff);       
end

%% Anisotropic bead friction (resistive force theory)
