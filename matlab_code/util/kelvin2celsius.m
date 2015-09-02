%% Copyright 2014 MERCIER David
function TC = Kelvin2Celsius(TK, varargin)
%% Function to convert temperature in °C to temperature in K

% TC: Temperature in °C
% TK: Temperature in K

if nargin < 1
    TK = 293.15;
end

TC = TK - 273.15;

end