%% Copyright 2014 MERCIER David
function plot_cdf
%% Function to plot the probability density function or the cumulative distribution function
gui = guidata(gcf);

%% New plot on second axis
set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_2);

cla(gui.handles.AxisPlot_2, 'reset');

max_gui_results_xdata = max([gui.results.xdata]);
max_gui_results_ydata = max([gui.results.ydata]);

if max([gui.results.xdata]) == 0
    max_gui_results_xdata = 1;
elseif max([gui.results.ydata]) == 0
    max_gui_results_ydata = 1;
end

plot(gui.handles.AxisPlot_2, ...
    [gui.results.xdata], [gui.results.ydata], ...
    'b+', 'MarkerSize', 10);
xlim('manual');
ylim('manual');
xlim([0 max_gui_results_xdata]);
ylim([0 max_gui_results_ydata]);

if gui.settings.grid_plot_value == 1
    grid on;
else
    grid off;
end
hold on;

%% Plot of cumulative distribution

coefEsts = gui.cumulativeFunction.coefEsts;

if gui.settings.value_crit_param == 1
    if strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(1,:)) || ...
            strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(2,:)) || ...
            strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(3,:)) || ...
            strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(4,:))
        str_title = ['Mean critical parameter=', ...
            num2str(coefEsts(2) * mean([gui.data(:).mean_sum_L])), ...
            ' & Weibull modulus=', num2str(coefEsts(1))];
        %str_xlabel = 'Critical load (mN)';
        str_xlabel = 'Ratio of the critical load to the average critical load)';
    else
        str_title = strcat('{\eta}=', num2str(coefEsts(1)), ...
            ' & {\epsilon}=', num2str(coefEsts(2)), ...
            ' & V_{act}=', num2str(coefEsts(3)));
        str_xlabel = 'Critical parameter';
    end
    
elseif gui.settings.value_crit_param == 2
    if strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(1,:)) || ...
            strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(2,:)) || ...
            strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(3,:)) || ...
            strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(4,:))
        str_title = strcat('Mean critical parameter=', ...
            num2str(coefEsts(2) * mean([gui.data(:).mean_sum_h])), ...
            ' & Weibull modulus=', num2str(coefEsts(1)));
        %str_xlabel = 'Critical displacement (nm)';
        str_xlabel = 'Ratio of the critical displacement to the average critical displacement)';
    else
        str_title = strcat('{\eta}=', num2str(coefEsts(1)), ...
            ' & {\epsilon}=', num2str(coefEsts(2)), ...
            ' & V_{act}=', num2str(coefEsts(3)));
        str_xlabel = 'Critical parameter';
    end
end

line(gui.cumulativeFunction.xdata_cdf, gui.cumulativeFunction.ydata_cdf, ...
    'Color', 'r', 'LineWidth', 2);

legend({'Row data' 'Weibull model'}, 'Location', 'NorthWest');
xlabel(str_xlabel);
ylabel('Cumulative distribution');
title(str_title);

guidata(gcf, gui);

end