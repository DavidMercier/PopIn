%% Copyright 2014 MERCIER David
function plot_load_disp_set
%% Function to plot load vs. displacement curves on main window
%% Get data from the GUI
gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Please, select results (.xls file)...', 'Info');
    
elseif gui.flag.flag_cleaned_data == 0
    % Calculations have to be performed once at least !
    gui.flag.flag_plot = 1;
    guidata(gcf, gui);
    get_and_plot;
    gui = guidata(gcf); guidata(gcf, gui);
    
else
    
    %% Get parameters from the GUI
    gui.settings.log_plot_value  = get(gui.handles.cb_log_plot_GUI,             'Value');
    gui.settings.grid_plot_value = get(gui.handles.cb_grid_plot_GUI,            'Value');
    gui.settings.x_value_GUI     = get(gui.handles.value_param2plotinxaxis_GUI, 'Value');
    gui.settings.y_value_GUI     = get(gui.handles.value_param2plotinyaxis_GUI, 'Value');
    
    cla(gui.handles.AxisPlot_GUI_1, 'reset');
    set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI_1);
    
    guidata(gcf, gui);
    plot_load_disp;
    gui = guidata(gcf);
    
end

guidata(gcf, gui);

end