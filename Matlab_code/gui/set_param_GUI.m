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

%% Settings of Hertzian fit
if gui.settings.cb_Hertzian_plot == 1
    set(gui.handles.title_YoungModulus, 'Visible', 'on');
    set(gui.handles.value_YoungModulus, 'Visible', 'on');
    set(gui.handles.unit_YoungModulus, 'Visible', 'on');
    set(gui.handles.title_TipRadius, 'Visible', 'on');
    set(gui.handles.value_TipRadius, 'Visible', 'on');
    set(gui.handles.unit_TipRadius, 'Visible', 'on');
else
    set(gui.handles.title_YoungModulus, 'Visible', 'off');
    set(gui.handles.value_YoungModulus, 'Visible', 'off');
    set(gui.handles.unit_YoungModulus, 'Visible', 'off');
    set(gui.handles.title_TipRadius, 'Visible', 'off');
    set(gui.handles.value_TipRadius, 'Visible', 'off');
    set(gui.handles.unit_TipRadius, 'Visible', 'off');
end

guidata(gcf, gui);

end