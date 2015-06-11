%% Copyright 2014 MERCIER David
function he = elasticDisp(load, R1, R2, E1, E2, varargin)
%% Function giving the Hertzian elastic contact depth in microns
% See K. L. Johnson, "Contact Mechanics" (1987) - ISBN: 9780521347969

% he: Elastic displacement in microns
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

Rred = reducedValue(R1, R2);

ae = elasticRadius(load, R1, R2, E1, E2);

he = (ae.^2)./Rred;

end