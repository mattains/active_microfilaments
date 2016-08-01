% Function to calculate the velocities at all n points at time t. Right
% hand side of the position update differential equation; for use in the
% ODE solver
% R --> column vector that contains the x,y cordinates of each point, size
% 2n
% t --> time
% V --> column vector that contains x,y components of velocity of each
% point, size 2n
function V = velocityfunction_mobmatrix(~,R,grandfric,sig0,filament_param,stiffness,~,flags)

%% Calculate bending forces
if(flags.bendflag == 1)
    fb = bending_force_2(R,stiffness.s2,filament_param);
else
    fb = 0;
end

%% Calculate stretching forces
if(flags.stretchflag == 1)
    fstr = stretch_force_2(R,stiffness.s1,filament_param);
else
    fstr = 0;
end

%% Total force & stress
F = (fb + fstr);
S = stress_force(R,sig0,filament_param);

%% Velocity calculation
% Oseen Tensor
mob = grand_mobility(R,grandfric,filament_param);

% Doublet Tensor
mob_d = grand_mobility_doublet(R,filament_param);    

%filename = 'mob_d.xlsx';
%xlswrite(filename,(mob_d(:,:,1)))

V_1 = mob*F;
V_2 = zeros(length(S),1);
for ii = 1:length(S)
    V_2(ii) = ...
        mob_d(ii,:,1)*S(:,1) + ...
        mob_d(ii,:,2)*S(:,2) + ...
        mob_d(ii,:,3)*S(:,3);
end

%% Put in a thing here to detect 2D vs 3D
%{
%convert V_2 to 2D from 3D
V_2_temp = zeros(length(V_1),1);
for ii = 1: length(V_2)/3
    V_2_temp(2*ii-1) = V_2(3*ii-2);
    V_2_temp(2*ii) = V_2(3*ii-1);    
end
V_2 = V_2_temp; %%
%}

% S
% mob_d(:,:,1)
% mob_d(:,:,2)
% V_1
% V_2
% filename = 'mob_d.xlsx';
% xlswrite(filename,mob_d(:,:,1));
% V_1
% sum(V_1)
% V_2
% sum(V_2)

V = V_1 + V_2;

% V(1)=0;
% V(2) =0;
% V(3)=0;


end

