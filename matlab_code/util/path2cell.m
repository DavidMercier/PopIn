%% Copyright 2014 MERCIER David
function pcell = path2cell(path_str)
%% Splits a Matlab search path string at the pathseparator and returns the
%result as a cellstr
pcell = regexp(path_str, pathsep, 'split');

end