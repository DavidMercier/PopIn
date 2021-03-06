%% Copyright 2014 MERCIER David
function set_PopInGui
%% Definition of the GUI and buttons
gui = guidata(gcf);

%% Title of the GUI
gui.handles.title_1 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.325 0.96 0.55 0.04],...
    'String', 'Statistical analysis of the pop-in distribution through cumulative distribution',...
    'FontSize', 12);

gui.handles.title_2 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.325 0.93 0.55 0.03],...
    'String', ['Version ', gui.config.version_toolbox, ...
    ' - Copyright 2014 MERCIER David'],...
    'FontSize', 10);

set([gui.handles.title_1, gui.handles.title_2], ...
    'FontWeight', 'bold',...  
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red')

%% Date / Time
gui.handles.date = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'String', datestr(datenum(clock),'mmm.dd,yyyy HH:MM'),...
    'Position', [0.92 0.975 0.075 0.02]);

%% Variables definition
x_coord = 0.018;

%% Buttons to browse in files
gui.handles.opendata = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [x_coord 0.94 0.06 0.05],...
    'String', 'Select file',...
    'FontSize', 10,...
    'FontWeight','bold',...
    'BackgroundColor', [0.745 0.745 0.745],...
    'Callback', 'openfile_popin');

gui.handles.opendata_str = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.078 0.94 0.2 0.05],...
    'String', gui.data_xls.pathname_data,...
    'FontSize', 8,...
    'BackgroundColor', [0.9 0.9 0.9]);

gui.handles.typedata = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [x_coord 0.91 0.26 0.03],...
    'String', '.xls ==> 3 columns : Segments / Displacement / Load ',...
    'HorizontalAlignment', 'left');

%% Units definition
gui.settings.ListLoadUnits = {'nN';'uN';'mN'};
gui.settings.ListDispUnits = {'nm';'um';'mm'};

[gui.handles.title_unitLoad, gui.handles.unitLoad] = ...
    set_popupmenu('Load :', [x_coord 0.885 0.055 0.02], ...
    3, gui.settings.ListLoadUnits, 'get_and_plot_popin', gcf);

[gui.handles.title_unitDisp, gui.handles.unitDisp] = ...
    set_popupmenu('Displacement :', [0.093 0.885 0.055 0.02], ...
    1, gui.settings.ListDispUnits, 'get_and_plot_popin', gcf);

%% Pop-in detection criteria
gui.settings.ListCriterion = {'diff(h,1)';'diff(h,2)';'diff(h,3)';...
    '1st derivative';'2nd derivative';'dL/ddh'};

[gui.handles.title_popinDet, gui.handles.popinDet] = ...
    set_popupmenu('Criterion :', [0.168 0.885 0.055 0.02], ...
    2, gui.settings.ListCriterion, '', gcf);

%% Pop-in detection criteria
gui.settings.ListDeltaCriterion = {'Max - 2Mean';'Max - Mean';'Max - Mean/2';...
    'Max'};

[gui.handles.title_popinDeltaDet, gui.handles.popinDeltaDet] = ...
    set_popupmenu('Delta :', [0.168 0.825 0.055 0.02], ...
    1, gui.settings.ListDeltaCriterion, '', gcf);

%% Young's modulus of the material in GPa
[gui.handles.title_YoungModulus, gui.handles.value_YoungModulus, ...
    gui.handles.unit_YoungModulus] = ...
    set_inputs_boxes('Young''s modulus :', '160', 'GPa', ...
    [x_coord 0.825 0.1 0.025], 'get_and_plot_popin', 0.65, gcf);

%% Poisson's ratio of the material
[gui.handles.title_PoissonRatio, gui.handles.value_PoissonRatio, ...
    gui.handles.unit_PoissonRatio] = ...
    set_inputs_boxes('Poisson'' s ratio :', '0.3', '', ...
    [x_coord 0.795 0.1 0.025], 'get_and_plot_popin', 0.65, gcf);

%% Radius of the spherical indenter tip in um
[gui.handles.title_TipRadius, gui.handles.value_TipRadius, ...
    gui.handles.unit_TipRadius] = ...
    set_inputs_boxes('Tip radius :', '1', 'um', ...
    [x_coord 0.765 0.1 0.025], 'get_and_plot_popin', 0.65, gcf);

%% Definition of temperature of experiments
[gui.handles.title_temperature, gui.handles.value_temperature, ...
    gui.handles.unit_temperature] = ...
    set_inputs_boxes('Temperature :', '20', '�C', ...
    [x_coord 0.735 0.1 0.025], '', 0.65, gcf);

%% Definition of load rate of experiments
[gui.handles.title_loadrate, gui.handles.value_loadrate, ...
    gui.handles.unit_loadrate] = ...
    set_inputs_boxes('Load rate :', '0.05', 'mN/s', ...
    [x_coord 0.705 0.1 0.025], '', 0.65, gcf);

%% Definition of the minimum/maximum depth
[gui.handles.title_mindepth, gui.handles.value_mindepth, ...
    gui.handles.unit_mindepth] = ...
    set_inputs_boxes('Min depth :', '', 'nm', ...
    [x_coord 0.675 0.07 0.025], '', 0.6, gcf);

[gui.handles.title_maxdepth, gui.handles.value_maxdepth, ...
    gui.handles.unit_maxdepth] = ...
    set_inputs_boxes('Max depth :', '', 'nm', ...
    [x_coord+0.095 0.675 0.07 0.025], '', 0.6, gcf);

%% Number of pop-in
[gui.handles.title_num_popin, gui.handles.value_num_popin] = ...
    set_popupmenu('Which pop-in to analyze ?', [x_coord 0.64 0.15 0.03], ...
    1, '1st pop-in|2nd pop-in', '', gcf);

%% Set the critical parameter
[gui.handles.title_crit_param, gui.handles.value_crit_param] = ...
    set_popupmenu('Which critical parameter to analyze ?', ...
    [x_coord 0.58 0.15 0.03], 1, 'Load|Displacement', '', gcf);

%% Set the critical parameter
[gui.handles.title_cumulFunction, gui.handles.value_cumulFunction] = ...
    set_popupmenu('Which cumulative function ?', ...
    [x_coord 0.52 0.15 0.03], 1, ...
    'Weibull (mortal)|Weibull (survival)|Chechenin (mortal)|Chechenin (survival)|Mason', ...
    '', gcf);

%% Run calculation if new parameters set
gui.handles.run_calc = set_pushbutton(...
    'RUN CALCULATIONS and PLOT', [x_coord 0.445 0.15 0.04], ...
    'get_and_plot_popin', gcf);

%% Parameters to plot on x and y axis
[gui.handles.title_param2plotinxaxis, gui.handles.value_param2plotinxaxis] = ...
    set_popupmenu('Parameter to plot ==> x axis', [x_coord 0.40 0.10 0.03], ...
    1, 'Displ.(h)|Load(L)|dh|ddh|dL|ddL', 'get_and_plot_popin', gcf);

[gui.handles.title_param2plotinyaxis, gui.handles.value_param2plotinyaxis] = ...
    set_popupmenu('Parameter to plot ==> y axis', [x_coord 0.34 0.10 0.03], ...
    2, 'Displ.(h)|Load(L)|dh|ddh|dL|ddL', 'get_and_plot_popin', gcf);

%% Options of the plot
gui.handles.cb_log_plot = set_checkbox('Log', [x_coord 0.27 0.03 0.03], ...
    0, 'get_and_plot_popin', gcf);

gui.handles.cb_grid_plot = set_checkbox('Grid', [0.06 0.27 0.03 0.03], ...
    1, 'get_and_plot_popin', gcf);

% Plot Hertzian fit
gui.handles.cb_Hertzian_plot = set_checkbox('Hertzian fit', ...
    [0.1 0.27 0.05 0.03], 1, 'get_and_plot_popin;', gcf);

% Plot cdf lines
gui.handles.cb_cdf_lines = set_checkbox('cdf lines', ...
    [0.16 0.27 0.05 0.03], 1, 'get_and_plot_popin;', gcf);

%% Get values from plot
gui.handles.cb_get_values = set_pushbutton(...
    'Get x and y values', [x_coord 0.225 0.09 0.03], ...
    'plot_get_values', gcf);

[gui.handles.title_x_values, gui.handles.value_x_values, ...
    gui.handles.unit_x_values] = ...
    set_inputs_boxes('X value :', '', '', ...
    [x_coord 0.19 0.07 0.03], '', 0.5, gcf);

[gui.handles.title_y_values, gui.handles.value_y_values, ...
    gui.handles.unit_yy_values] = ...
    set_inputs_boxes('Y value :', '', '', ...
    [x_coord 0.16 0.07 0.03], '', 0.5, gcf);

%% Legend locations
[gui.handles.title_legendLocation, gui.handles.value_legendLocation] = ...
    set_popupmenu('Legend location', [x_coord+0.1 0.225 0.08 0.03], ...
    6, listLocationLegend, 'get_and_plot_popin', gcf);

%% Help
gui.handles.help = set_pushbutton(...
    'HELP', [x_coord 0.095 0.095 0.05], ...
    'gui = guidata(gcf); web(gui.config.url_help,''-browser'')', gcf);

%% Save
gui.handles.save = set_pushbutton(...
    'SAVE', [x_coord+0.1 0.095 0.095 0.05], ...
    'save_figures_set', gcf);

%% Quit
gui.handles.quit = set_pushbutton(...
    'QUIT', [x_coord 0.04 0.195 0.04], ...
    'finish_sav', gcf);

guidata(gcf, gui);

end