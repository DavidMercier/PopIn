%% Copyright 2014 MERCIER David
function plot_load_disp
%% Function to plot load vs. displacement curves on main window
% Get data from the GUI
gui = guidata(gcf);

for ii_sheet = 1:1:length(gui.data_xls.sheets_xls)
    %% Set x data to plot
    if gui.settings.x_value == 1
        x_value_to_plot = gui.data(ii_sheet).data_h_cleaned(:, 1);
        axis_x_min = gui.settings.min_data_h_average;
        axis_x_max = gui.settings.max_data_h_average;
        xlabel_str = strcat('Displacement (', ...
            gui.settings.DispUnitSelected, ')');
        
    elseif gui.settings.x_value == 2
        x_value_to_plot = gui.data(ii_sheet).data_L_cleaned(:, 1);
        axis_x_min = min(gui.data(ii_sheet).data_L_cleaned(:, 1));
        axis_x_max = max(gui.data(ii_sheet).data_L_cleaned(:, 1));
        xlabel_str = strcat('Load (', ...
            gui.settings.LoadUnitSelected, ')');
        
    elseif gui.settings.x_value == 3
        x_value_to_plot = gui.data(ii_sheet).data_dh_cleaned(:, 1);
        axis_x_min = min(gui.data(ii_sheet).data_dh_cleaned(:, 1));
        axis_x_max = max(gui.data(ii_sheet).data_dh_cleaned(:, 1));
        xlabel_str = strcat('1st derivative of displacement (', ...
            gui.settings.DispUnitSelected, ')');
        
    elseif gui.settings.x_value == 4
        x_value_to_plot = gui.data(ii_sheet).data_ddh_cleaned(:, 1);
        axis_x_min = min(gui.data(ii_sheet).data_ddh_cleaned(:, 1));
        axis_x_max = max(gui.data(ii_sheet).data_ddh_cleaned(:, 1));
        xlabel_str = strcat('2nd derivative of displacement (', ...
            gui.settings.DispUnitSelected, ')');
        
    elseif gui.settings.x_value == 5
        x_value_to_plot = gui.data(ii_sheet).data_dL_cleaned(:, 1);
        axis_x_min = min(gui.data(ii_sheet).data_dL_cleaned(:, 1));
        axis_x_max = max(gui.data(ii_sheet).data_dL_cleaned(:, 1));
        xlabel_str = strcat('1st derivative of load (', ...
            gui.settings.LoadUnitSelected, ')');
        
    elseif gui.settings.x_value == 6
        x_value_to_plot = gui.data(ii_sheet).data_ddL_cleaned(:, 1);
        axis_x_min = min(gui.data(ii_sheet).data_ddL_cleaned(:, 1));
        axis_x_max = max(gui.data(ii_sheet).data_ddL_cleaned(:, 1));
        xlabel_str = strcat('2nd derivative of load (', ...
            gui.settings.LoadUnitSelected, ')');
        
    end
    
    %% Set y data to plot
    if gui.settings.y_value == 1
        y_value_to_plot = gui.data(ii_sheet).data_h_cleaned(:, 1);
        axis_y_min = gui.settings.min_data_h_average;
        axis_y_max = gui.settings.max_data_h_average;
        ylabel_str = strcat('Displacement (', ...
            gui.settings.DispUnitSelected, ')');
        
    elseif gui.settings.y_value == 2
        y_value_to_plot = gui.data(ii_sheet).data_L_cleaned(:, 1);
        axis_y_min = min(gui.data(ii_sheet).data_L_cleaned(:, 1));
        axis_y_max = max(gui.data(ii_sheet).data_L_cleaned(:, 1));
        ylabel_str = strcat('Load (', ...
            gui.settings.LoadUnitSelected, ')');
        
    elseif gui.settings.y_value == 3
        y_value_to_plot = gui.data(ii_sheet).data_dh_cleaned(:, 1);
        axis_y_min = min(gui.data(ii_sheet).data_dh_cleaned(:, 1));
        axis_y_max = max(gui.data(ii_sheet).data_dh_cleaned(:, 1));
        ylabel_str = strcat('1st derivative of displacement (', ...
            gui.settings.DispUnitSelected, ')');
        
    elseif gui.settings.y_value == 4
        y_value_to_plot = gui.data(ii_sheet).data_ddh_cleaned(:, 1);
        axis_y_min = min(gui.data(ii_sheet).data_ddh_cleaned(:, 1));
        axis_y_max = max(gui.data(ii_sheet).data_ddh_cleaned(:, 1));
        ylabel_str = strcat('2nd derivative of displacement (', ...
            gui.settings.DispUnitSelected, ')');
        
    elseif gui.settings.y_value == 5
        y_value_to_plot = gui.data(ii_sheet).data_dL_cleaned(:, 1);
        axis_y_min = min(gui.data(ii_sheet).data_dL_cleaned(:, 1));
        axis_y_max = max(gui.data(ii_sheet).data_dL_cleaned(:, 1));
        ylabel_str = strcat('1st derivative of load (', ...
            gui.settings.LoadUnitSelected, ')');
        
    elseif gui.settings.y_value == 6
        y_value_to_plot = gui.data(ii_sheet).data_ddL_cleaned(:, 1);
        axis_y_min = min(gui.data(ii_sheet).data_ddL_cleaned(:, 1));
        axis_y_max = max(gui.data(ii_sheet).data_ddL_cleaned(:, 1));
        ylabel_str = strcat('2nd derivative of load (', ...
            gui.settings.LoadUnitSelected, ')');
        
    end
    
    %% Set plot properties
    if gui.settings.log_plot_value == 0
        plot(gui.handles.AxisPlot_1, x_value_to_plot, y_value_to_plot);
        hold on;
        axis([axis_x_min axis_x_max axis_y_min axis_y_max]);
        
    elseif gui.settings.log_plot_value == 1
        loglog(gui.handles.AxisPlot_1, x_value_to_plot, y_value_to_plot);
        hold on;
        
    end
    
    xlabel(xlabel_str);
    ylabel(ylabel_str);
    
    if gui.settings.grid_plot_value == 1
        grid on;
    else
        grid off;
    end
    
end

if gui.settings.cb_Hertzian_plot == 1
    HertzianHandle = plot(gui.handles.AxisPlot_1, gui.Hertz.elasticDisp_init, ...
        gui.Hertz.elasticLoad, ':b', 'linewidth', 2.5);
    legend(HertzianHandle, 'Hertzian fit', 'Location', 'northwest');
end

guidata(gcf, gui);
plot_cdf;
gui = guidata(gcf);

guidata(gcf, gui);

end