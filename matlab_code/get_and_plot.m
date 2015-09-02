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
                waitbar(ii_sheet / gui.data_xls.sheets_xls_notEmpty, ...
                    gui.handles.h_waitbar);
            end
            
            % Cleaning and cropping of data from min and max depth set by user
            clean_data(ii_sheet);
            gui = guidata(gcf); guidata(gcf, gui);
            
            if gui.flag.flag_cleaned_data == 1
                %% Calculation of the number of pop-in
                % Determination of the maximum displacement from cleaned and cropped data
                max_h = gui.settings.max_bound_h;
                
                for uu = max_h-2:1:max_h
                    if rem(uu, 1) == 0
                        umax(ii_sheet) = uu;
                    end
                end
                
                % Calculation of 1st derivative
                gui.data(ii_sheet).data_dh_cleaned = ...
                    diff(gui.data(ii_sheet).data_h_cleaned);
                gui.data(ii_sheet).data_dL_cleaned = ...
                    diff(gui.data(ii_sheet).data_L_cleaned);
                gui.data(ii_sheet).data_dh_cleaned(length(gui.data(ii_sheet).data_dh_cleaned)+1) = ...
                    gui.data(ii_sheet).data_dh_cleaned(length(gui.data(ii_sheet).data_dh_cleaned));
                gui.data(ii_sheet).data_dL_cleaned(length(gui.data(ii_sheet).data_dL_cleaned)+1) = ...
                    gui.data(ii_sheet).data_dL_cleaned(length(gui.data(ii_sheet).data_dL_cleaned));
                
                % Calculation of 2nd derivative
                gui.data(ii_sheet).data_ddh_cleaned = ...
                    diff(gui.data(ii_sheet).data_dh_cleaned);
                gui.data(ii_sheet).data_ddL_cleaned = ...
                    diff(gui.data(ii_sheet).data_dL_cleaned);
                gui.data(ii_sheet).data_ddh_cleaned(length(gui.data(ii_sheet).data_ddh_cleaned)+1) = ...
                    gui.data(ii_sheet).data_ddh_cleaned(length(gui.data(ii_sheet).data_ddh_cleaned));
                gui.data(ii_sheet).data_ddL_cleaned(length(gui.data(ii_sheet).data_ddL_cleaned)+1) = ...
                    gui.data(ii_sheet).data_ddL_cleaned(length(gui.data(ii_sheet).data_ddL_cleaned));
                
                delta_data = ...
                    max(gui.data(ii_sheet).data_ddh_cleaned(:)) - ...
                    mean(gui.data(ii_sheet).data_ddh_cleaned(:));
                
                [maxpeak, minpeak] = ...
                    peakdet(gui.data(ii_sheet).data_ddh_cleaned(:), ...
                    delta_data);
                
                % Attribution of pop-in indice(s) for each load-disp curve
                % (for each Excel sheet)...
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
                (gui.data_xls.sheets_xls_notEmpty+1))+1) / ...
                (gui.data_xls.sheets_xls_notEmpty+1));
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
            
            % Extraction of values of load or disp at the pop-in
            % indice obtained from peak detection (see above)
            if gui.settings.value_crit_param == 1
                gui.data(ii_sheet).sum_L = ...
                    gui.data(ii_sheet).data_L_cleaned(ind_popin);
                
            elseif gui.settings.value_crit_param == 2
                gui.data(ii_sheet).sum_h = ...
                    gui.data(ii_sheet).data_h_cleaned(ind_popin);
                
            end
            guidata(gcf, gui);
        end
        delete(gui.handles.h_waitbar);
        
        %% Set the data to plot
        Func = gui.settings.cumulFunction;
        FuncList = gui.settings.cumulFunctionList;
        
        if gui.settings.value_crit_param == 1
            
            for ii = 1:1:length(gui.data)
                gui.results(ii).binCtrs_init = gui.data(ii).sum_L;
                sorted_sumL = sort([gui.data.sum_L]);
                if strcmp(Func, FuncList(1,:)) || ...
                        strcmp(Func, FuncList(2,:))
                    gui.results(ii).binCtrs = gui.data(ii).sum_L / ...
                        mean([gui.data.sum_L]);
                elseif strcmp(Func, FuncList(3,:)) || ...
                        strcmp(Func, FuncList(4,:))
                    gui.results(ii).binCtrs = gui.data(ii).sum_L / ...
                        sorted_sumL(gui.data_xls.sheets_xls_notEmpty/2);
                end
            end
            gui.resultsMax_binCtrs = max([gui.data.sum_L]);
        elseif gui.settings.value_crit_param  == 2
            for ii = 1:1:length(gui.data)
                gui.results(ii).binCtrs_init = gui.data(ii).sum_h;
                sorted_sumh = sort([gui.data.sum_h]);
                if strcmp(Func, FuncList(1,:)) || ...
                        strcmp(Func, FuncList(2,:))
                    gui.results(ii).binCtrs = gui.data(ii).sum_h / ...
                        mean([gui.data.sum_h]);
                elseif strcmp(Func, FuncList(3,:)) || ...
                        strcmp(Func, FuncList(4,:))
                    gui.results(ii).binCtrs = gui.data(ii).sum_h / ...
                        sorted_sumh(gui.data_xls.sheets_xls_notEmpty/2);
                end
            end
            gui.resultsMax_binCtrs = max([gui.data.sum_h]);
        end
        
        if strcmp(Func, FuncList(1,:)) || ...
                strcmp(Func, FuncList(3,:))
            xdata_init = sort([gui.results(:).binCtrs_init]);
            xdata = sort([gui.results(:).binCtrs]);
            
        elseif strcmp(Func, FuncList(2,:)) || ...
                strcmp(Func, FuncList(4,:))
            xdata_init = sort([gui.results(:).binCtrs_init],'descend');
            xdata = sort([gui.results(:).binCtrs],'descend');
            
        else
            xdata = sort([gui.data(:).sum_L]);
            xdata_init = xdata;
            for ii = 1:1:length(gui.data)
                if xdata(ii) < 0
                    xdata(ii) = 0;
                end
            end
            
        end
        for ii = 1:1:length(gui.data)
            gui.results(ii).xdata_init = xdata_init(ii);
            gui.results(ii).xdata = xdata(ii);
        end
        
        for ii = 1:1:length(gui.data)
            gui.results(ii).ydata = gui.results(ii).prob;
        end
        guidata(gcf, gui);
        
        % Options settings
        OPTIONS = optimset('lsqcurvefit');
        OPTIONS = optimset(OPTIONS, 'TolFun',  ...
            gui.config.numerics.TolFun_value);
        OPTIONS = optimset(OPTIONS, 'TolX',    ...
            gui.config.numerics.TolX_value);
        OPTIONS = optimset(OPTIONS, 'MaxIter', ...
            gui.config.numerics.MaxIter_value);
        
        % Calculations of the cumulative function
        if strcmp(Func, FuncList(1,:))
            weibull_cdf(OPTIONS, ...
                [gui.results.xdata_init],[gui.results.ydata]);
        elseif strcmp(Func, FuncList(2,:))
            weibull_cdf_survival(OPTIONS, ...
                [gui.results.xdata_init],[gui.results.ydata]);
        elseif strcmp(Func, FuncList(3,:))
            weibull_modified_cdf(OPTIONS, ...
                [gui.results.xdata_init],[gui.results.ydata]);
        elseif strcmp(Func, FuncList(4,:))
            weibull_modified_cdf_survival(OPTIONS, ...
                [gui.results.xdata_init],[gui.results.ydata]);
        elseif strcmp(Func, FuncList(5,:))
            mason_cdf(OPTIONS, ...
                [gui.results.xdata],[gui.results.ydata]);
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
            
            gui.Hertz.elasticLoad = elasticLoad(...
                gui.Hertz.elasticDisp, ...
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