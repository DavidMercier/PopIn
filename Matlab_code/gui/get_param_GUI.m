%% Copyright 2014 MERCIER David
function get_param_GUI
%% Function to get values of different variables from the GUI
gui = guidata(gcf);

%% Initialization
if gui.flag.flag_data == 0
    errorLoadingData;
else
    %% Getting parameters from the GUI
    gui.settings.unitLoad           = get(gui.handles.unitLoad, 'Value');
    gui.settings.unitDisp           = get(gui.handles.unitDisp, 'Value');
    gui.settings.value_temperature  = str2double(get(gui.handles.value_temperature, 'String'));
    gui.settings.value_loadrate     = str2double(get(gui.handles.value_loadrate, 'String'));
    gui.settings.cb_Hertzian_plot   = get(gui.handles.cb_Hertzian_plot, 'Value');
    gui.settings.value_YoungModulus = str2double(get(gui.handles.value_YoungModulus, 'String'));
    gui.settings.value_TipRadius    = str2double(get(gui.handles.value_TipRadius, 'String'));
    gui.settings.set_popin          = get(gui.handles.value_num_popin, 'Value');
    gui.settings.set_popin          = get(gui.handles.value_num_popin, 'Value');
    gui.settings.min_data_h_average = str2double(get(gui.handles.value_mindepth, 'String'));
    gui.settings.max_data_h_average = str2double(get(gui.handles.value_maxdepth, 'String'));
    gui.settings.value_crit_param   = get(gui.handles.value_crit_param, 'Value');
end

guidata(gcf, gui);

end