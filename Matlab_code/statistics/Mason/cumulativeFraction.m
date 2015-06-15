%% Copyright 2014 MERCIER David
function cumFrac = cumulativeFraction(load, loadrate, R1, R2, E1, E2, ...
    T, Vact, epsilon_var, neta_var, K, varargin)
%% Calculation of the cumulative fraction function
% See Mason et al. (2006) DOI: 10.1103/PhysRevB.73.054102

% load: Applied load in mN
% loadrate: Constant loading rate in mN/s
% R1: radius of the 1st body in microns
% R2: radius of the 2nd body in microns
% E1: Young's modulus of the 1st body in GPa
% E1: Young's modulus of the 2nd body in GPa
% T: Temperature of experiments in K
% Vact: Activation volume in Angstrom3
% epsilon_var: Activation enthalpy in eV
% neta_var: Pre-exponential frequency factor in s-1.m-3
% K: Proportionality constant

if nargin < 11
    K = pi;
end

if nargin < 10
    neta_var = 8.9 * 1e23; % in s-1.m-3
end

if nargin < 9
    epsilon_var = 0.5; % in eV
end

if nargin < 8
    Vact = 10; % in Angstrom3
end

if nargin < 7
    T = 293; % in K (=20°C)
end

if nargin < 6
    E2 = 1070; % in GPa
end

if nargin < 5
    E1 = 60; % in GPa
end

if nargin < 4
    R2 = 0.45; % in microns
end

if nargin < 3
    R1 = 0; % in microns
end

if nargin < 2
    loadrate = 0.05; % in mN/s
end

if nargin < 1
    load = 0.1; % in mN
end

alpha_var = alphaMason(R1, R2, E1, E2, T, Vact);
beta_var = betaMason(load, R1, R2, E1, E2, T, Vact);

Rred = reducedValue(R1, R2) * 1e-6; % in m
Ered = reducedValue(E1, E2) * 1e9; % in N/m2

loadrate = loadrate * 1e-3; % in N/s
epsilon_var = epsilon_var * 1.60217657*1e-19;  % in J = in kg.m2.s-2

k_Boltzmann = 1.3806488 * 1e-23; % Boltzmann's constant in  m2.kg.s-2.K-1

cumFrac = 1 - exp(-((9*K*Rred*neta_var)/(4*Ered*loadrate*alpha_var^6)) * ...
    exp(-(epsilon_var/(k_Boltzmann*T))) * beta_var);

end