%% Copyright 2014 MERCIER David
function p0 = maxPressure(load, R1, R2, E1, E2, varargin)
%% Function giving the maximum pressure in an Hertzian contact in GPa
% See K. L. Johnson, "Contact Mechanics" (1987) - ISBN: 9780521347969

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

% Rred = reducedValue(R1, R2);
% Ered = reducedValue(E1, E2);
% pm = (3/2) .* (1/pi) .* ((4*Ered)/(3*Rred))^(2/3) .* load.^(1/3);
% ae = elastic_radius(load, R1, R2, E1, E2);
% p0 = (3/2) .* load ./ (pi .* ae.^2);

p0 = (3/2) .* meanPressure(load, R1, R2, E1, E2);

end