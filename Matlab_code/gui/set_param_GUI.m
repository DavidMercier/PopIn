%% Copyright 2014 MERCIER David
function set_param_GUI
%% Function used to set the pop-up menu in the GUI
% Get data from the GUI
gui = guidata(gcf);

%% Settings of units
gui.settings.LoadUnitSelected = ...
    gui.settings.ListLoadUnits(gui.settings.unitLoad, :);

gui.settings.DispUnitSelected = ...
    gui.settings.ListDispUnits(gui.settings.unitDisp, :);

set(gui.handles.unit_mindepth, 'String', gui.settings.DispUnitSelected);
set(gui.handles.unit_maxdepth, 'String', gui.settings.DispUnitSelected);

if gui.settings.x_value == 1 && gui.settings.y_value == 2
    set(gui.handles.cb_Hertzian_plot, 'Visible', 'on');
else
    set(gui.handles.cb_Hertzian_plot, 'Visible', 'off');
    gui.settings.cb_Hertzian_plot = 0;
end

guidata(gcf, gui);

end