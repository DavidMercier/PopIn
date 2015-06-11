%% Copyright 2014 MERCIER David
function set_param_GUI
%% Function used to set the pop-up menu in the GUI
% Get data from the GUI
gui = guidata(gcf);

% Settings of units
gui.settings.LoadUnitSelected = ...
    gui.settings.ListLoadUnits(gui.settings.unitLoad_GUI, :);

gui.settings.DispUnitSelected = ...
    gui.settings.ListDispUnits(gui.settings.unitDisp_GUI, :);

set(gui.handles.unit_mindepth_GUI, 'String', gui.settings.DispUnitSelected);
set(gui.handles.unit_maxdepth_GUI, 'String', gui.settings.DispUnitSelected);

guidata(gcf, gui);

end