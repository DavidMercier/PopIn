%% Copyright 2014 MERCIER David
function get_param_GUI
%% Function to get values of different variables from the GUI
%% Get data from the GUI
gui = guidata(gcf);

%% Initialization
if gui.flag.flag_data == 0
    helpdlg('Please, select results (.xls file)...', 'Info');
    
else
    %% Getting parameters from the GUI
    gui.settings.set_popin          = get(gui.handles.value_num_popin_GUI, 'Value');
    gui.settings.min_data_h_average = str2double(get(gui.handles.value_mindepth_GUI, 'String'));
    gui.settings.max_data_h_average = str2double(get(gui.handles.value_maxdepth_GUI, 'String'));
    gui.settings.value_crit_param   = get(gui.handles.value_crit_param_GUI, 'Value');
    
end

guidata(gcf, gui);

end