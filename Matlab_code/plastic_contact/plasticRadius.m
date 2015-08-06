%% Copyright 2014 MERCIER David
function ap = plasticRadius(load, yieldStress, varargin)
%% Function giving the Hertzian elastic contact depth in microns
% See Zielinski W. et al. (1993) - DOI: 10.1557/JMR.1993.1300
% See Kramer D. E. et al. (2001) - DOI: 10.1080/01418610108216651

% ap: Radius of the plastic zone below indent in a ductile substrate in microns
% load: Applied load in mN
% yieldStress: Yield stress of the substrate in MPa

if nargin < 2
    yieldStress = 100; % in MPa
end

if nargin < 1
    load = 0.1; % in mN
end

ap = ((3*load)/(2*pi*yieldStress))^0.5;

end