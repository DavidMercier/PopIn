%% Copyright 2014 MERCIER David
function get_and_plot
%% Function used to get and plot data
gui = guidata(gcf);

if gui.flag.flag_data == 0
    helpdlg('Please, select results (.xls file)...', 'Info');
    set(gui.handles.run_calc, 'BackgroundColor', [0.745 0.745 0.745]);
else
    gui.handles.h_waitbar = waitbar(0, 'Calculations in progress...');
    guidata(gcf, gui);
    
    get_param_GUI;
    gui = guidata(gcf); guidata(gcf, gui);
    
    set_param_GUI;
    gui = guidata(gcf); guidata(gcf, gui);
    
    % Preallocation
    umax = NaN(length(gui.data_xls.sheets_xls));
    
    guidata(gcf, gui);
    %% Import data
    for ii_sheet = 1:1:length(gui.data_xls.sheets_xls)
        gui = guidata(gcf);
        if gui.flag.flag_cleaned_data
            if ishandle(gui.handles.h_waitbar)
                waitbar(ii_sheet / length(gui.data_xls.sheets_xls), gui.handles.h_waitbar);
            end
            
            % Cleaning and cropping of data from min and max depth set by user
            clean_data(ii_sheet);
            gui = guidata(gcf); guidata(gcf, gui);
            
            if gui.flag.flag_cleaned_data == 1
                %% Calculation of the number of pop-in
                % Determination of the maximum displacement from cleaned and cropped data
                for uu = gui.settings.max_bound_h-2:1:gui.settings.max_bound_h
                    if rem(uu, 1) == 0
                        umax(ii_sheet) = uu;
                    end
                end
                
                % Calculation of 1st derivative
                gui.data(ii_sheet).data_dh_cleaned = diff(gui.data(ii_sheet).data_h_cleaned);
                gui.data(ii_sheet).data_dL_cleaned = diff(gui.data(ii_sheet).data_L_cleaned);
                gui.data(ii_sheet).data_dh_cleaned(length(gui.data(ii_sheet).data_dh_cleaned)+1) = gui.data(ii_sheet).data_dh_cleaned(length(gui.data(ii_sheet).data_dh_cleaned));
                gui.data(ii_sheet).data_dL_cleaned(length(gui.data(ii_sheet).data_dL_cleaned)+1) = gui.data(ii_sheet).data_dL_cleaned(length(gui.data(ii_sheet).data_dL_cleaned));
                
                % Calculation of 2nd derivative
                gui.data(ii_sheet).data_ddh_cleaned = diff(gui.data(ii_sheet).data_dh_cleaned);
                gui.data(ii_sheet).data_ddL_cleaned = diff(gui.data(ii_sheet).data_dL_cleaned);
                gui.data(ii_sheet).data_ddh_cleaned(length(gui.data(ii_sheet).data_ddh_cleaned)+1) = gui.data(ii_sheet).data_ddh_cleaned(length(gui.data(ii_sheet).data_ddh_cleaned));
                gui.data(ii_sheet).data_ddL_cleaned(length(gui.data(ii_sheet).data_ddL_cleaned)+1) = gui.data(ii_sheet).data_ddL_cleaned(length(gui.data(ii_sheet).data_ddL_cleaned));
                
                delta_data = max(gui.data(ii_sheet).data_ddh_cleaned(:)) - mean(gui.data(ii_sheet).data_ddh_cleaned(:));
                
                [maxpeak, minpeak] = peakdet(gui.data(ii_sheet).data_ddh_cleaned(:), delta_data);
                
                gui.data(ii_sheet).num_popin_int = maxpeak(:, 1);
                
                if gui.data(ii_sheet).num_popin_int == -1;
                    delete(gui.handles.h_waitbar);
                    helpdlg('No pop-in detected !');
                    return;
                end
                guidata(gcf, gui);
            else
                delete(gui.handles.h_waitbar);
            end
        end
    end
    
    if gui.flag.flag_cleaned_data == 1
        delete(gui.handles.h_waitbar);
        
        %% Calculation of probability for Weibull cumulative distribution function
        gui.results(1, 1).prob = (1/length(gui.data_xls.sheets_xls));
        for ii = 1:(length(gui.data_xls.sheets_xls)-1),
            gui.results(ii+1, 1).prob = (((gui.results(ii, 1).prob * ...
                (length(gui.data_xls.sheets_xls)+1))+1)/(length(gui.data_xls.sheets_xls)+1));
        end
        
        %% Sum of data for statistic analysis and plot of pop-in distribution + fit
        if gui.flag.flag_plot ~=1
            gui.handles.h_waitbar = waitbar(0, 'Plots in progress...');
            
            for ii_sheet = 1:1:length(gui.data_xls.sheets_xls)
                waitbar(ii_sheet / length(gui.data_xls.sheets_xls));
                
                ind_popin_all = gui.data(ii_sheet).num_popin_int(:);
                
                if gui.settings.set_popin == 1
                    if isempty(ind_popin_all)
                        ind_popin_all(1) = gui.settings.max_bound_h_init;
                    end
                    ind_popin = ind_popin_all(1);
                    
                else
                    
                    if length(ind_popin_all) == 1
                        ind_popin_all(2) = gui.settings.max_bound_h_init;
                    end
                    ind_popin = ind_popin_all(2);
                    
                end
                
                if gui.settings.value_crit_param == 1
                    gui.data(ii_sheet).sum_L = ...
                        gui.data(ii_sheet).data_L_cleaned(ind_popin);
                    
                    gui.data(ii_sheet).mean_sum_L = ...
                        mean(gui.data(ii_sheet).sum_L);
                    
                elseif gui.settings.value_crit_param == 2
                    gui.data(ii_sheet).sum_h = ...
                        gui.data(ii_sheet).data_h_cleaned(ind_popin);
                    
                    gui.data(ii_sheet).mean_sum_h = ...
                        mean(gui.data(ii_sheet).sum_h);
                    
                end
                guidata(gcf, gui);
            end
            delete(gui.handles.h_waitbar);
            
        end
        %% Plot of L-h curves
        guidata(gcf, gui);
        plot_load_disp_set;
        gui = guidata(gcf); guidata(gcf, gui);
        
    end
end

guidata(gcf, gui);

end