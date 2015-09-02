%% Copyright 2014 MERCIER David
function nims_root = get_popin_root
%% Get environment variable for PopIn

nims_root = getenv('POPIN_TBX_ROOT');

if isempty(nims_root)
    msg = 'Run the path_management.m script !';
    commandwindow;
    display(msg);
    %errordlg(msg, 'File Error');
    error(msg);
end

end