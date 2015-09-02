%% Copyright 2014 MERCIER David
function get_and_plot
%% Function used to get and plot data
gui = guidata(gcf);

if gui.flag.flag_data == 0
    errorLoadingData;
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
    for ii_sheet = 1:1:gui.data_xls.sheets_xls_notEmpty
        gui = guidata(gcf);
        if gui.flag.flag_cleaned_data
            if ishandle(gui.handles.h_waitbar)
                waitbar(ii_sheet / gui.data_xls.sheets_xls_notEmpty, gui.handles.h_waitbar);
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
                    warndlg('No pop-in detected !');
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
        gui.results(1, 1).prob = (1/gui.data_xls.sheets_xls_notEmpty);
        for ii = 1:(gui.data_xls.sheets_xls_notEmpty-1),
            gui.results(ii+1, 1).prob = (((gui.results(ii, 1).prob * ...
                (gui.data_xls.sheets_xls_notEmpty+1))+1)/(gui.data_xls.sheets_xls_notEmpty+1));
        end
        
        %% Sum of data for statistic analysis and plot of pop-in distribution + fit
        gui.handles.h_waitbar = waitbar(0, 'Plots in progress...'); % Don't move into the loop !
        
        for ii_sheet = 1:1:gui.data_xls.sheets_xls_notEmpty
            waitbar(ii_sheet / gui.data_xls.sheets_xls_notEmpty);
            
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
        
        % Set data
        %% Set the data to plot
        if gui.settings.value_crit_param == 1
            for ii = 1:1:length(gui.data)
                gui.results(ii).binCtrs = gui.data(ii).sum_L / mean([gui.data.mean_sum_L]);
                gui.results(ii).max_binCtrs = max([gui.data(ii).sum_L]);
            end
        elseif gui.settings.value_crit_param  == 2
            for ii = 1:1:length(gui.data)
                gui.results(ii).binCtrs = gui.data(ii).sum_h / mean([gui.data.mean_sum_h]);
                gui.results(ii).max_binCtrs = max([gui.data(ii).sum_h]);
            end
        end
        
        if strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(1,:)) || ...
                strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(3,:))
            xdata = sort([gui.results(:).binCtrs]);
            for ii = 1:1:length(gui.data)
                gui.results(ii).xdata = xdata(ii);
            end
            
        elseif strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(2,:)) || ...
                strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(4,:))
            xdata = sort([gui.results(:).binCtrs],'descend');
            for ii = 1:1:length(gui.data)
                gui.results(ii).xdata = xdata(ii);
            end
            
        else
            xdata = sort([gui.data(:).sum_L]);
            for ii = 1:1:length(gui.data)
                if xdata(ii) < 0
                    xdata(ii) = 0;
                end
                gui.results(ii).xdata = xdata(ii);
            end
        end
        
        for ii = 1:1:length(gui.data)
            gui.results(ii).ydata = gui.results(ii).prob;
        end
        guidata(gcf, gui);
        
        % Options settings
        OPTIONS = optimset('lsqcurvefit');
        OPTIONS = optimset(OPTIONS, 'TolFun',  gui.config.numerics.TolFun_value);
        OPTIONS = optimset(OPTIONS, 'TolX',    gui.config.numerics.TolX_value);
        OPTIONS = optimset(OPTIONS, 'MaxIter', gui.config.numerics.MaxIter_value);
        
        % Calculations of the cumulative function
        if strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(1,:))
            weibull_cdf(OPTIONS, [gui.results.xdata],[gui.results.ydata]);
        elseif strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(2,:))
            weibull_cdf_survival(OPTIONS, [gui.results.xdata],[gui.results.ydata]);
        elseif strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(3,:))
            weibull_modified_cdf(OPTIONS, [gui.results.xdata],[gui.results.ydata]);
        elseif strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(4,:))
            weibull_modified_cdf_survival(OPTIONS, [gui.results.xdata],[gui.results.ydata]);
        elseif strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(5,:))
            mason_cdf(OPTIONS, [gui.results.xdata],[gui.results.ydata]);
        end
        gui = guidata(gcf); guidata(gcf, gui);
        
        %% Plot of L-h curves
        % Calculations of Hertzian displacement and Hertzian load
        if gui.settings.cb_Hertzian_plot == 1
            gui.Hertz.elasticDisp_init = ...
                gui.settings.min_bound_h:0.1:gui.settings.max_bound_h;
            
            if strcat(gui.settings.unitDisp, 'nm');
                gui.Hertz.elasticDispUnit = 'nm';
                gui.Hertz.elasticDisp = gui.Hertz.elasticDisp_init * 1e-3;
            elseif strcat(gui.settings.unitDisp, 'um');
                gui.Hertz.elasticDispUnit = 'um';
                gui.Hertz.elasticDisp = gui.Hertz.elasticDisp_init;
            elseif strcat(gui.settings.unitDisp, 'mm');
                gui.Hertz.elasticDispUnit = 'mm';
                gui.Hertz.elasticDisp = gui.Hertz.elasticDisp_init * 1e3;
            end
            
            gui.Hertz.elasticLoad = elasticLoad(gui.Hertz.elasticDisp, ...
                gui.settings.value_TipRadius, 0, ...
                gui.settings.value_YoungModulus);
        end
        guidata(gcf, gui);
        plot_load_disp;
        gui = guidata(gcf); guidata(gcf, gui);
        
        guidata(gcf, gui);
        
        %% Plot cumulative distribution curves
        plot_cdf;
        gui = guidata(gcf); guidata(gcf, gui);
        
    end
end

guidata(gcf, gui);

end