%% Copyright 2014 MERCIER David
function gui_handle = demo
%% Function to run the Matlab GUI for the analysis of the pop-in statistics

%% Check License of Optimization Toolbox
license_msg = ['Sorry, no license found for the Matlab ', ...
    'Optimization Toolbox™ !'];
if  license('checkout', 'Optimization_Toolbox') == 0
    warning(license_msg);
    licenceFlag = 0;
else
    licenceFlag = 1;
end

%% Define gui structure variable
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
    gui.config.POPINroot = get_popin_root; % ensure that environment is set
end

[gui.config.indenter, gui.config.data, ...
    gui.config.numerics, flag_YAML] = load_YAML_configFile;

%% Set Toolbox version and help paths
gui.config.name_toolbox = 'PopIn';
gui.config.version_toolbox = '3.2';
gui.config.url_help = 'http://popin.readthedocs.org/en/latest/';
gui.config.pdf_help = 'https://media.readthedocs.org/pdf/popin/latest/popin.pdf';
gui.config.licenceFlag = licenceFlag;

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

guidata(gcf, gui);

%% Set buttons and popup menus
set_PopInGui;
gui = guidata(gcf); guidata(gcf, gui);

%% Axis properties
positionVector1 = [0.25 0.06 0.325 0.8];
gui.handles.AxisPlot_1 = subplot('Position', positionVector1);

positionVector2 = [0.65 0.06 0.325 0.8];
gui.handles.AxisPlot_2 = subplot('Position', positionVector2);

%% YAML and Help menus
customized_menu_popin(gcf);

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

java_icon_popin;

end