%% Copyright 2014 MERCIER David
function gui_handle = demo
%% Function to run the Matlab GUI for the analysis of the pop-in statistics

%% YAML config. files
gui = struct();
gui.config = struct();
gui.config.indenter = struct();
gui.config.data = struct();
gui.config.numerics = struct();
gui.data_xls.filename_data = 'mts-XP_Indcon5um_Al2O3-40nm.xls';
gui.data_xls.pathname_data = fullfile(pwd, 'indentation_data');

%% Paths Management
% Don't move before definition of 'gui' as a struct()
try
    gui.config.POPINroot = get_popin_root; % ensure that environment is set
catch
    [startdir, dummy1, dummy2] = fileparts(mfilename('fullpath'));
    cd(startdir);
    commandwindow;
    path_management;
end

[gui.config.indenter, gui.config.data, ...
    gui.config.numerics, flag_YAML] = load_YAMLconfigFile;

%% Set Toolbox version and help paths
gui.config.name_toolbox = 'PopIn';
gui.config.version_toolbox = '3.0';
gui.config.url_help = 'http://popin.readthedocs.org/en/latest/';
gui.config.pdf_help = 'https://media.readthedocs.org/pdf/popin/latest/popin.pdf';

%% Main Window Coordinates Configuration
scrsize = get(0, 'ScreenSize');   % Get screen size
WX = 0.05 * scrsize(3);           % X Position (bottom)
WY = 0.10 * scrsize(4);           % Y Position (left)
WW = 0.90 * scrsize(3);           % Width
WH = 0.80 * scrsize(4);           % Height

%% Main Window Configuration
gui.handles.MainWindows = figure('Name', ...
    strcat(gui.config.name_toolbox, '_Version_', gui.config.version_toolbox),...
    'NumberTitle', 'off',...
    'PaperUnits', get(0, 'defaultfigurePaperUnits'),...
    'Color', [0.9 0.9 0.9],...
    'Colormap', get(0,'defaultfigureColormap'),...
    'toolBar', 'figure',...
    'InvertHardcopy', get(0, 'defaultfigureInvertHardcopy'),...
    'PaperPosition', [0 7 50 15],...
    'Position', [WX WY WW WH]);

%% Title of the GUI
gui.handles.title_1 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.325 0.96 0.55 0.04],...
    'String', 'Statistical analysis of the pop-in distribution through cumulative distribution',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

gui.handles.title_2 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.325 0.93 0.55 0.03],...
    'String', ['Version ', gui.config.version_toolbox, ...
    ' - Copyright 2014 MERCIER David'],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

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
    'Callback', 'openfile');

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
    3, gui.settings.ListLoadUnits, 'get_and_plot', gcf);

[gui.handles.title_unitDisp, gui.handles.unitDisp] = ...
    set_popupmenu('Displacement :', [0.093 0.885 0.055 0.02], ...
    1, gui.settings.ListDispUnits, 'get_and_plot', gcf);

%% Young's modulus of the material in GPa
[gui.handles.title_YoungModulus, gui.handles.value_YoungModulus, ...
    gui.handles.unit_YoungModulus] = ...
    set_inputs_boxes('Young''s modulus :', '160', 'GPa', ...
    [x_coord 0.825 0.1 0.025], 'get_and_plot', 0.65, gcf);

%% Poisson's ratio of the material
[gui.handles.title_PoissonRatio, gui.handles.value_PoissonRatio, ...
    gui.handles.unit_PoissonRatio] = ...
    set_inputs_boxes('Poisson'' s ratio :', '0.3', '', ...
    [x_coord 0.795 0.1 0.025], 'get_and_plot', 0.65, gcf);

%% Radius of the spherical indenter tip in um
[gui.handles.title_TipRadius, gui.handles.value_TipRadius, ...
    gui.handles.unit_TipRadius] = ...
    set_inputs_boxes('Tip radius :', '1', 'um', ...
    [x_coord 0.765 0.1 0.025], 'get_and_plot', 0.65, gcf);

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
    'get_and_plot', gcf);

%% Parameters to plot on x and y axis
[gui.handles.title_param2plotinxaxis, gui.handles.value_param2plotinxaxis] = ...
    set_popupmenu('Parameter to plot ==> x axis', [x_coord 0.40 0.10 0.03], ...
    1, 'Displ.(h)|Load(L)|dh|ddh|dL|ddL', 'get_and_plot', gcf);

[gui.handles.title_param2plotinyaxis, gui.handles.value_param2plotinyaxis] = ...
    set_popupmenu('Parameter to plot ==> y axis', [x_coord 0.34 0.10 0.03], ...
    2, 'Displ.(h)|Load(L)|dh|ddh|dL|ddL', 'get_and_plot', gcf);

%% Options of the plot
gui.handles.cb_log_plot = set_checkbox('Log', [x_coord 0.27 0.03 0.03], ...
    0, 'get_and_plot', gcf);

gui.handles.cb_grid_plot = set_checkbox('Grid', [0.06 0.27 0.03 0.03], ...
    1, 'get_and_plot', gcf);

% Plot Hertzian fit
gui.handles.cb_Hertzian_plot = set_checkbox('Hertzian fit', ...
    [0.1 0.27 0.05 0.03], 1, 'get_and_plot;', gcf);

% Plot cdf lines
gui.handles.cb_cdf_lines = set_checkbox('cdf lines', ...
    [0.16 0.27 0.05 0.03], 1, 'get_and_plot;', gcf);

%% Get values from plot
gui.handles.cb_get_values = set_pushbutton(...
    'Get values x and y values', [x_coord 0.225 0.10 0.03], ...
    'plot_get_values', gcf);

[gui.handles.title_x_values, gui.handles.value_x_values, ...
    gui.handles.unit_x_values] = ...
    set_inputs_boxes('X value :', '', '', ...
    [x_coord 0.19 0.07 0.03], '', 0.5, gcf);

[gui.handles.title_y_values, gui.handles.value_y_values, ...
    gui.handles.unit_yy_values] = ...
    set_inputs_boxes('Y value :', '', '', ...
    [x_coord 0.16 0.07 0.03], '', 0.5, gcf);

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

%% Axis properties
positionVector1 = [0.25 0.06 0.325 0.8];
gui.handles.AxisPlot_1 = subplot('Position', positionVector1);

positionVector2 = [0.65 0.06 0.325 0.8];
gui.handles.AxisPlot_2 = subplot('Position', positionVector2);

%% YAML and Help menus
customized_menu(gcf);

%% Set flags;
gui.flag.flag_data = 0;
gui.flag.flag_cleaned_data = 0;

if flag_YAML
    %% Encapsulation of data into the GUI
    guidata(gcf, gui);
    gui_handle = ishandle(gcf);

else
    fprintf(['<a href="https://code.google.com/p/yamlmatlab/">', ...
        'Please download YAML Matlab code first...!</a>']);
    dos('start https://code.google.com/p/yamlmatlab/ ');
    errordlg(['Please download YAML Matlab code first... --> ', ...
        'https://code.google.com/p/yamlmatlab/'], 'Error');
end

end