%% Copyright 2014 MERCIER David
function beta_var = betaMason(load, R1, R2, E1, E2, T, Vact, varargin)
%% Function giving beta, the complex but weak function of load
% See Mason et al. (2006) DOI: 10.1103/PhysRevB.73.054102

% load: Applied load in mN
% R1: radius of the 1st body in microns
% R2: radius of the 2nd body in microns
% E1: Young's modulus of the 1st body in GPa
% E1: Young's modulus of the 2nd body in GPa
% T: Temperature of experiments in K
% Vact: Activation volume in Angstrom3

if nargin < 7
    Vact = 10; % in Angstrom3
end

if nargin < 6
    T = 293; % in K
end

if nargin < 5
    E2 = 1070; % in GPa
end

if nargin < 4
    E1 = 160; % in GPa
end

if nargin < 3
    R2 = 1; % in microns
end

if nargin < 2
    R1 = +inf; % in microns
end

if nargin < 1
    load = 0.1; % in mN
end

load = load * 1e-3; % in N

alpha_var = alphaMason(R1, R2, E1, E2, T, Vact);

beta_var = 120 .* exp(-load.^(1/3) .* alpha_var) + ...
    ((load.^(5/3) .* alpha_var.^5) - (5*load.^(4/3) .* alpha_var.^4) + ...
    (20*load .* alpha_var.^3) - (60*load.^(2/3) .* alpha_var.^2)  + ...
    (120*load.^(1/3) .* alpha_var) - 120);

end