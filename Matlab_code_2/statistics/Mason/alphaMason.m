%% Copyright 2014 MERCIER David
function alpha_var = alphaMason(R1, R2, E1, E2, T, Vact, varargin)
%% Function giving alpha, the parameter made of time-independent terms
% See Mason et al. (2006) DOI: 10.1103/PhysRevB.73.054102

% R1: radius of the 1st body in microns
% R2: radius of the 2nd body in microns
% E1: Young's modulus of the 1st body in GPa
% E1: Young's modulus of the 2nd body in GPa
% T: Temperature of experiments in K
% Vact: Activation volume in Angstrom3

if nargin < 6
    Vact = 10; % in Angstrom3
end

if nargin < 5
    T = 293; % in K
end

if nargin < 4
    E2 = 1070; % in GPa
end

if nargin < 3
    E1 = 160; % in GPa
end

if nargin < 2
    R2 = 1; % in microns
end

if nargin < 1
    R1 = +inf; % in microns
end

k_Boltzmann = 1.3806488e-23; % Boltzmann's constant in  m2.kg.s-2.K-1

Rred = reducedValue(R1, R2) * 1e-6; % in m
Ered = reducedValue(E1, E2) * 1e9; % in N/m2

Vact = Vact * 1e-30; % in m3

alpha_var = (0.47/pi) * ((4*Ered)/(3*Rred))^(2/3) * Vact/(k_Boltzmann * T);

end