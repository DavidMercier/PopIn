%% Copyright 2014 MERCIER David
function errorLoadingData
%% Function used to display a message in case data are not correctly loaded
gui = guidata(gcf);

gui.flag.flag_data = 0;
gui.flag.flag_cleaned_data = 0;

helpdlg('Please, select results (.xls file)...', 'Info');
set(gui.handles.run_calc, 'BackgroundColor', [1 0 0]);

initializedGUI;

guidata(gcf, gui);

end