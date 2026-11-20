%% Copyright 2014 MERCIER David
function clean_data_popin(ii_sheet)
%% Function used to correct data (minimum displacement, CSM correction...)
gui = guidata(gcf);

% Correction of data (minimum and maximum depths)
if gui.flag.flag_data == 0
    helpdlg('Import data first !','!!!');
    
else
    if ~isempty(gui.data(ii_sheet).data_h)
        %% Initialization
        gui.data(ii_sheet).data_h_cleaned = [];
        gui.data(ii_sheet).data_L_cleaned = [];
        
        %% Set warnings if wrong settings
        if isnan(gui.settings.max_data_h_average) == 0 && ...
                isnan(gui.settings.min_data_h_average) == 0 && ...
                isempty(gui.settings.max_data_h_average) == 0 && ...
                isempty(gui.settings.min_data_h_average) == 0
            if gui.settings.min_data_h_average < gui.settings.max_data_h_average ...
                    && gui.settings.min_data_h_average + 1 >= gui.settings.min_bound_h_init ...
                    && gui.settings.max_data_h_average > 0 ...
                    && gui.settings.max_data_h_average - 1 <= gui.settings.max_bound_h_init
                gui.settings.min_bound_h = gui.settings.min_data_h_average;
                gui.settings.max_bound_h = gui.settings.max_data_h_average;
                gui.flag.flag_cleaned_data = 1;
            else
                gui.flag.flag_cleaned_data = 0;
            end
            
        else
            gui.flag.flag_cleaned_data = 0;
        end
        
        if gui.flag.flag_cleaned_data
            h = gui.data(ii_sheet).data_h(:, 1);
            load = gui.data(ii_sheet).data_L(:, 1);
            selected = isfinite(h) & isfinite(load) & ...
                h >= gui.settings.min_bound_h & h < gui.settings.max_bound_h;
            if nnz(selected) < 3
                error('PopIn:InsufficientDepthRange', ...
                    'Select a depth range containing at least three finite displacement/load samples.');
            end
            gui.data(ii_sheet).data_h_cleaned = h(selected); % in nm
            gui.data(ii_sheet).data_L_cleaned = load(selected); % in mN
            gui.flag.flag_cleaned_data = 1;
        else
            delete(gui.handles.h_waitbar);
            gui.settings.min_bound_h = gui.settings.min_bound_h_init;
            gui.settings.max_bound_h = gui.settings.max_bound_h_init;
            set(gui.handles.value_mindepth, 'String', ...
                num2str(round(gui.settings.min_bound_h)));
            set(gui.handles.value_maxdepth, 'String', ...
                num2str(round(gui.settings.max_bound_h)));
            warndlg('Wrong inputs for minimum and maximum depth values !', ...
                'Input Error');
        end
    end
    
end

guidata(gcf, gui);

end