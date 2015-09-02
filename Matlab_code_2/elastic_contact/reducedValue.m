%% Copyright 2014 MERCIER David
function Vred = reducedValue(V1, V2, varargin)
%% Function giving the reduced form of 2 similar variables
% See K. L. Johnson, "Contact Mechanics" (1987) - ISBN: 9780521347969

% V1: variable of the 1st body
% V2: variable of the 2nd body

if V1 ~= 0 && V2 ~= 0
    Vred = ((1/V1)+(1/V2))^(-1);
elseif V1 == 0
    Vred = V2;
elseif V2 == 0
    Vred = V1;
end

end