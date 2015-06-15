%% Copyright 2014 MERCIER David
function initializedGUI
%% Function used to initialize the GUI
gui = guidata(gcf);

set(gui.handles.cb_Hertzian_plot, 'Value', 1);
set(gui.handles.cb_log_plot, 'Value', 0);
set(gui.handles.cb_grid_plot, 'Value', 1);
set(gui.handles.gui.handles.value_param2plotinxaxis, 'Value', 1);
set(gui.handles.gui.handles.value_param2plotinyaxis, 'Value', 2);
set(gui.handles.gui.handles.value_num_popin, 'Value', 1);
set(gui.handles.gui.handles.value_crit_param, 'Value', 1);
set(gui.handles.gui.handles.unitLoad, 'Value', 1);
set(gui.handles.gui.handles.unitDisp, 'Value', 1);

guidata(gcf, gui);

end