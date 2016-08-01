%% Scaling with bending force: 
% $Length scale (L) = l (filament length)
% Force scale (F) = S_2 * l^3 (bending force)
% Velocity scale (V) = F/(mu * L) = S_2 * l^2/mu (Stokes drag)
% Timescale (T) = L/V = mu/(S_2*l)$ 

%% Scales (SI units)
mu = 1e-3; 
lenscale = 1e-4;
S_2 = 1e6; 
timescale = mu/(S_2*lenscale);
velscale = lenscale/timescale;

%% Scaled parameters
len         = 5;           % Length of the filament
n           = 10;           % Number of beads in the filament
dels        = len/(n-1);    % Distance between two beads with zero spring force
delta       = 1e-5;         % Friction factor

n_p         = 5.*[1,1,1];   % Number of fluid particles (x,y,z)
dels_p      = [5,5,5];      % Initial distance between fluid particles (x,y,z)

% For sine initilization
k           = pi/3;     % Wave number nondim
w           = 2*pi;     %-2*pi; % Frequency nondim
amp         = 0.45/2;   % scaled amplitude

% For helix initilization
rad         = 1;    % Radius
h_step      = 0.4;  % Height per step

% Spring Stiffnesses
s1          = 1e0;       % scaled spring stiffness, $sigma_s = S_1/(S_2 * L^2)$
s2          = 1e0;       % scaled bending stiffnesss

S_1         = s1*S_2*lenscale^2;

S_2_cont    = S_2 * dels^5;
S_1_cont    = S_1 * dels;

% Forcing
sig0        = 1e3;      % Activity coefficient

% rhi         = n-1;      % Hydrodynamic interaction radius, n-1 --> full HI, 1 --> adjacent only
eps         = 0;        % Regularized Stokeslet smoothing parameter = diameter of the filament
eps2        = eps^2;

% Time Settings
dim_time    = 0.2;          % Dimesional simulation time, seconds
time        = 100;            %dim_time/timescale; % non-dim time of simulation
timeno      = 300;          % no of sampling timesteps
timestep    = time/timeno;  % non-dim sampling timestep

bendflag    = 1; % Turn bending on or off; ON = 1, OFF = 0
stretchflag = 1; % Turn stretching on or off; ON = 1, OFF = 0