%% Copyright 2014 MERCIER David
function edit_YAMLconfigFile
%% Function used to edit YAML configuration file
[YAML_filename, YAML_pathname] = ...
    uigetfile(['yaml_config_files\', '*.yaml'], 'File Selector');

if YAML_filename == 0
    YAML_filename = '';
end
if YAML_pathname == 0
    YAML_pathname = '';
end

if isequal(YAML_filename, 0) || isempty(YAML_filename)
    disp('User selected Cancel');
else
    disp(['User selected', fullfile(YAML_pathname, YAML_filename)]);
    edit([YAML_pathname, YAML_filename]);
end

end