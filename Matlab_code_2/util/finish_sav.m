%% Copyright 2014 MERCIER David
function finish_sav
%% Function to open an exit dialog box and to save all data before to close all figures

pushbutton = questdlg('Ready to quit?', ...
    'Exit Dialog','Yes','No','No');

switch pushbutton
    case 'Yes',
        disp('Exiting MATLAB');
        %Save variables to test.mat
        clear all; close all; clear classes;
        delete(findall(0,'Type','figure'));
    case 'No',
        quit cancel;
end

end