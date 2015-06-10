%% Copyright 2014 MERCIER David
function openfile
%% Function used to open a data file and assign experimental results to variables
gui = guidata(gcf);

%% Open window to select file
[filename_data, pathname_data, filterindex_data] = uigetfile('*.xls', 'File Selector');
gui.data_xls.filename_data = filename_data;
gui.data_xls.pathname_data = pathname_data;

%% Handle canceled file selection
if filename_data == 0
    filename_data = '';
end

if pathname_data == 0
    pathname_data = '';
end

if isequal(filename_data,'')
    disp('User selected Cancel');
    filename_data = 'no_data';
    ext = '.nul';
    
else
    disp(['User selected', fullfile(pathname_data, filename_data)]);
    [pathstr, name, ext] = fileparts(filename_data);
    
end

%% Set data from .xls file (segments, number of sheets...)
if strcmp (ext, '.nul') == 1
    gui.flag.flag_data = 0;
    helpdlg('Please, select results (.xls file)...', 'Info');
    
elseif strcmp (ext, '.xls') == 1
    sheet = 1;
    [gui.data, txt] = xlsread(filename_data, sheet);
    str_endsegment = txt(:,1); %limite
    
    if isempty(str_endsegment)
        helpdlg('No segment found', 'Info');
    
    else
        val_endsegment_true = find(strcmp(str_endsegment(:), '') ~= 1);
        str_endsegment_true = str_endsegment(val_endsegment_true);
        
        % Open a list dialog window to select the end segment to crop data
        [s__endsegment, v__endsegment] = listdlg('PromptString', 'Select an end segment:', ...
            'SelectionMode', 'single',...
            'ListString', str_endsegment_true);
        
        % Get the number of sheets in the .xls file
        [status_xls, sheets_xls] = xlsfinfo(filename_data);
        gui.data_xls.status_xls = status_xls;
        gui.data_xls.sheets_xls = sheets_xls;
        
    end
    
    %% Import data from .xls file
    gui.flag.flag_data = 1;
    guidata(gcf, gui);
    gui.handles.h_waitbar = waitbar(0, 'Import of data in progress...');
    
    % Preallocation and initialization
    gui.data = struct();
    min_data_h = NaN(length(sheets_xls));
    max_data_h = NaN(length(sheets_xls));
    
    for ii_sheet = 1:1:length(sheets_xls)
        waitbar(ii_sheet / length(sheets_xls), gui.handles.h_waitbar);
        
        [data, txt] = xlsread(filename_data, ii_sheet);
        raw_str_endsegment = txt(:,1);
        
        % Set the y index to crop data in function of chosen segment
        y_index = find(strcmp(raw_str_endsegment, str_endsegment_true(s__endsegment)) == 1);
        
        data_index = sprintf('%c%d:%c%d', 'B', 1, 'C', y_index);
        
        [data_cropped, txt_cropped] = xlsread(filename_data, ii_sheet, data_index);
        
        % Import data
        gui.data(ii_sheet).data_h = data_cropped(:, 1);
        gui.data(ii_sheet).data_L = data_cropped(:, 2);
        min_data_h(ii_sheet) = round(min(gui.data(ii_sheet).data_h));
        max_data_h(ii_sheet) = round(max(gui.data(ii_sheet).data_h));
    end
    guidata(gcf, gui);
    delete(gui.handles.h_waitbar);
    
    gui.settings.min_bound_h = max(min_data_h(:));
    gui.settings.max_bound_h = min(max_data_h(:));
    gui.settings.min_bound_h_init = max(min_data_h(:));
    gui.settings.max_bound_h_init = min(max_data_h(:));
    guidata(gcf, gui);
    
    % Settings of the GUI
    set(gui.handles.value_mindepth_GUI, 'String', num2str(round(gui.settings.min_bound_h)));
    set(gui.handles.value_maxdepth_GUI, 'String', num2str(round(gui.settings.max_bound_h)));
    set(gui.handles.opendata_str_GUI, 'String', filename_data);
    
    % Message to the user
    helpdlg('Data imported ! Set parameters for statistic analysis and run the calculations...', 'Info');
    gui.flag.flag_cleaned_data = 0;
    
end

guidata(gcf, gui);

end