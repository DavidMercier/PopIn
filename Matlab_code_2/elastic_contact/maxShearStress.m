%% Copyright 2014 MERCIER David
function tau_max = maxShearStress(load, R1, R2, E1, E2, varargin)
%% Function giving the maximum shear stress beneath the indenter in GPa
% at a rough position of (0.48-0.5)times elastic radius beneath the indenter
% for a material with a Poisson's coefficient of 0.33
% See K. L. Johnson, "Contact Mechanics" (1987) - ISBN: 9780521347969
% Details p.95

% tau_max: Maximum shear stress in GPa
% load: Applied load in mN
% R1: radius of the 1st body in microns
% R2: radius of the 2nd body in microns
% E1: Young's modulus of the 1st body in GPa
% E1: Young's modulus of the 2nd body in GPa

if nargin < 5
    E2 = 1070; % in GPa
end

if nargin < 4
    E1 = 60; % in GPa
end

if nargin < 3
    R2 = 0.45; % in microns
end

if nargin < 2
    R1 = 0; % in microns
end

if nargin < 1
    load = 0.1; % in mN
end

% tau_max = 0.31 * maxPressure(load, R1, R2, E1, E2);
% tau_max = 0.31 * (3/2) * meanPressure(load, R1, R2, E1, E2);
tau_max = 0.47 * meanPressure(load, R1, R2, E1, E2);

end