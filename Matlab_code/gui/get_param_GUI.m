%% Copyright 2014 MERCIER David
function get_param_GUI
%% Function to get values of different variables from the GUI
gui = guidata(gcf);

%% Initialization
if gui.flag.flag_data == 0
    helpdlg('Please, select results (.xls file)...', 'Info');
else
    %% Getting parameters from the GUI
    gui.settings.unitLoad_GUI       = get(gui.handles.unitLoad_GUI, 'Value');
    gui.settings.unitDisp_GUI       = get(gui.handles.unitDisp_GUI, 'Value');
    gui.settings.value_temperature  = get(gui.handles.value_temperature, 'Value');
    gui.settings.set_popin          = get(gui.handles.value_num_popin_GUI, 'Value');
    gui.settings.set_popin          = get(gui.handles.value_num_popin_GUI, 'Value');
    gui.settings.min_data_h_average = str2double(get(gui.handles.value_mindepth_GUI, 'String'));
    gui.settings.max_data_h_average = str2double(get(gui.handles.value_maxdepth_GUI, 'String'));
    gui.settings.value_crit_param   = get(gui.handles.value_crit_param_GUI, 'Value');
end

guidata(gcf, gui);

end