%% Copyright 2014 MERCIER David
function pstr = cell2path(p_cstr)
%% Joins a Matlab search path cell string with the pathseparator and returns the
% result as a string

if ~iscellstr(p_cstr)
    error('Only accepts CELLSTR');
end

pstr = '';

for item_idx = 1:numel(p_cstr)
    item = p_cstr(item_idx);
    pstr = [pstr, pathsep, item{1}];
end

end