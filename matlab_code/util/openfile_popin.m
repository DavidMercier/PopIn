%% Copyright 2014 MERCIER David
function openfile_popin
%% Function used to open a data file and assign experimental results to variables
gui = guidata(gcf);
gui.raw_data = struct();

%% Open window to select file
[filename_data, pathname_data, filterindex_data] = ...
    uigetfile('*.xls;*xlsx', 'File Selector', gui.data_xls.pathname_data);
gui.data_xls.filename_data = filename_data;
gui.data_xls.pathname_data = pathname_data;
fullname_data = fullfile(pathname_data, filename_data);

% Get the number of sheets in the .xls file and the status of the .xls file
[status_xls, sheets_xls] = xlsfinfo(fullname_data);
gui.data_xls.status_xls = status_xls;
gui.data_xls.sheets_xls = sheets_xls;

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
    disp(['User selected', fullname_data]);
    [pathstr, name, ext] = fileparts(filename_data);
end

set(gui.handles.opendata_str, 'String', fullname_data);

%% Set data from .xls or xlsx file (segments, number of sheets...)
if strcmp (ext, '.nul') == 1
    errorLoadingData;
    
elseif strcmp (ext, '.xls') == 1 || strcmp (ext, '.xlsx') == 1
    
    for ii_sheet = 1:1:length(sheets_xls)
        [data_ind, txt_ind] = xlsread(fullname_data, ii_sheet);
        str_endsegment = txt_ind(:,1); %limite
        if ~isempty(str_endsegment)
            break
        end
    end
    
    if isempty(str_endsegment)
        helpdlg('No segment found', 'Info');
    else
        val_endsegment_true = find(strcmp(str_endsegment(:), '') ~= 1);
        str_endsegment_true = str_endsegment(val_endsegment_true);
        
        % Open a list dialog window to select the end segment to crop data
        [s__endsegment, v__endsegment] = ...
            listdlg('PromptString', 'Select an end segment:', ...
            'SelectionMode', 'single',...
            'ListString', str_endsegment_true);
    end
    
    %% Import data from .xls file
    
    %raw_str_endsegment = cell(length(sheets_xls),1);
    y_index = NaN(length(sheets_xls), 1);
    
    % Check and remove empty sheets
    notEmpty_data = NaN(length(sheets_xls));
    gui.handles.h_waitbar = ...
        waitbar(0, 'Check Excel file (remove empty sheets) and import data...'); % Don't move into the for loop
    
    for ii_sheet = 1:1:length(sheets_xls)
        waitbar(ii_sheet / length(sheets_xls), gui.handles.h_waitbar);
        
        [gui.raw_data(ii_sheet).data(:,:), ...
            gui.raw_data(ii_sheet).txt(:,:)] = ...
            xlsread(fullname_data, ii_sheet);
        
        if ~isempty(gui.raw_data(ii_sheet).txt)
            raw_str_endsegment = gui.raw_data(ii_sheet).txt(:,1);
            
            if ~isempty(raw_str_endsegment)
                % Set the y index to crop data in function of chosen segment
                raw_index = find(strcmp(raw_str_endsegment, ...
                    str_endsegment_true(s__endsegment)) == 1);
                if ~isempty(raw_index)
                    y_index(ii_sheet) = raw_index-2;
                    if strcmp(char(str_endsegment_true(s__endsegment)), 'END')
                        y_index(ii_sheet) = y_index(ii_sheet)-1;
                    end
                else
                    y_index(ii_sheet) = [];
                end
            else
                y_index(ii_sheet) = [];
            end
            
            if ~isempty(y_index(ii_sheet)) && ~isnan(y_index(ii_sheet))
                notEmpty_data(ii_sheet) = ii_sheet;
            else
                notEmpty_data(ii_sheet) = [];
                display(strcat('Missing segment for the sheet number_', ...
                    num2str(ii_sheet)));
            end
            
        else
            display('Empty Excel sheet !');
            notEmpty_data(ii_sheet) = [];
        end
    end
    delete(gui.handles.h_waitbar);
    
    notEmpty_data(isnan(notEmpty_data)) = [];
    gui.data_xls.sheets_xls_notEmpty = length(notEmpty_data);
    
    % Preallocation and initialization
    gui.data = struct();
    gui.results = struct();
    gui.cumulativeFunction = struct();
    gui.Hertz = struct();
    
    min_data_h = NaN(gui.data_xls.sheets_xls_notEmpty);
    max_data_h = NaN(gui.data_xls.sheets_xls_notEmpty);
    min_data_L = NaN(gui.data_xls.sheets_xls_notEmpty);
    max_data_L = NaN(gui.data_xls.sheets_xls_notEmpty);
    
    % Import data
    for ii_sheet = 1:1:gui.data_xls.sheets_xls_notEmpty
        
        ii_sheet2read = notEmpty_data(ii_sheet);
        
        if y_index(ii_sheet) ~= 0 && ~isempty(gui.raw_data(ii_sheet2read).data)
            gui.data(ii_sheet).data_h = ...
                gui.raw_data(ii_sheet2read).data(1:y_index(ii_sheet),1);
            gui.data(ii_sheet).data_L = ...
                gui.raw_data(ii_sheet2read).data(1:y_index(ii_sheet),2);
        else
            gui.data(ii_sheet).data_h = NaN;
            gui.data(ii_sheet).data_L = NaN;
        end
        min_data_h(ii_sheet) = round(min(gui.data(ii_sheet).data_h));
        max_data_h(ii_sheet) = round(max(gui.data(ii_sheet).data_h));
        min_data_L(ii_sheet) = min(gui.data(ii_sheet).data_L);
        max_data_L(ii_sheet) = max(gui.data(ii_sheet).data_L);
        
    end
    
    gui.settings.min_bound_h = max(min_data_h(:));
    gui.settings.max_bound_h = min(max_data_h(:));
    gui.settings.min_bound_h_init = max(min_data_h(:));
    gui.settings.max_bound_h_init = min(max_data_h(:));
    gui.settings.min_bound_L = mean(min_data_L(:));
    gui.settings.max_bound_L = mean(max_data_L(:));
    gui.settings.min_bound_L_init = min(min_data_L(:));
    gui.settings.max_bound_L_init = max(max_data_L(:));
    
    % Settings of the GUI
    set(gui.handles.value_mindepth, 'String', ...
        num2str(round(gui.settings.min_bound_h)));
    set(gui.handles.value_maxdepth, 'String', ...
        num2str(round(gui.settings.max_bound_h)));
    set(gui.handles.opendata_str, 'String', filename_data);
    
    % Flag settings
    gui.flag.flag_data = 1;
    gui.flag.flag_cleaned_data = 1;
    set(gui.handles.run_calc, 'BackgroundColor', [0 204/256 0]);
    guidata(gcf, gui); % Don't move because of the following helpdlg !
    
    % Message to the user
    helpdlg('Data imported ! Set parameters for statistic analysis and run the calculations...', 'Info');
    
end

end