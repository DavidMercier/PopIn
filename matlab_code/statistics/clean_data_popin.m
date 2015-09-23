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
            else
                gui.flag.flag_cleaned_data = 0;
            end
            
        else
            gui.flag.flag_cleaned_data = 0;
        end
        
        if gui.flag.flag_cleaned_data
            %% Remove data below a minimum displacement
            h_set_min = (gui.data(ii_sheet).data_h(:, 1) >=  gui.settings.min_bound_h);
            
            clear [row, col];
            for ii = 1:length(h_set_min)
                [row, col] = find(h_set_min >= 1);
            end
            
            % Preallocation
            h_int = NaN(max(row), 1);
            L_int = NaN(max(row), 1);
            
            for ii = row(1):(max(row))
                h_int(ii-row(1)+1) = gui.data(ii_sheet).data_h(ii, 1);
                L_int(ii-row(1)+1) = gui.data(ii_sheet).data_L(ii, 1);
            end
            
            %% Remove data below a maximum displacement
            h_set_max = (h_int <  gui.settings.max_bound_h);
            
            clear [row, col];
            for ii = 1:length(h_set_max)
                [row, col] = find(h_set_max == 1);
                
            end
            
            % Preallocation
            h_final = NaN(max(row), 1);
            L_final = NaN(max(row), 1);
            
            for ii = row(1):(max(row))
                h_final(ii) = h_int(ii);
                L_final(ii) = L_int(ii);
                
            end
            
            gui.data(ii_sheet).data_h_cleaned(:, 1) = h_final; % in nm
            gui.data(ii_sheet).data_L_cleaned(:, 1) = L_final; % in mN
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