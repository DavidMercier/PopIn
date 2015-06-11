%% Copyright 2014 MERCIER David
function Pe = elasticLoad(ht, R1, R2, E1, E2, varargin)
%% Function giving the Hertzian elastic contact depth in microns
% See K. L. Johnson, "Contact Mechanics" (1987) - ISBN: 9780521347969

% Pe: Applied load in mN
% ht: Total displacement in microns
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
    ht = 0.1; % in microns
end

Ered = reducedValue(E1, E2);
Rred = reducedValue(R1, R2);

Pe = (4/3) .* Ered * Rred.^(0.5) .* ht.^(1.5);

end