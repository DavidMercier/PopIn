%% Copyright 2014 MERCIER David
function plot_cdf
%% Function to plot the probability density function or the cumulative distribution function
gui = guidata(gcf);

set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_2);

cla(gui.handles.AxisPlot_2, 'reset');

max_gui_results_binCtrs = max([gui.results.binCtrs]);
max_gui_results_data_to_plot = max([gui.results.data_to_plot]);

if max([gui.results.max_binCtrs]) == 0
    max_gui_results_binCtrs = 1;
elseif max([gui.results.data_to_plot]) == 0
    max_gui_results_data_to_plot = 1;
end

% New plot
plot(gui.handles.AxisPlot_2, sort([gui.results(:).binCtrs]), ...
    [gui.results(:).data_to_plot], 'b+', 'MarkerSize', 10);
xlim('manual');
ylim('manual');
xlim([0 max_gui_results_binCtrs]);
ylim([0 max_gui_results_data_to_plot]);

if gui.settings.grid_plot_value == 1
    grid on;
else
    grid off;
end
hold on;

coefEsts = gui.cumulativeFunction.coefEsts;

if gui.settings.value_crit_param == 1
    str_title_Weibull = strcat('Mean critical parameter= ', ...
        num2str(coefEsts(2) * mean([gui.data(:).mean_sum_L])), ...
        ' & Weibull modulus = ', num2str(coefEsts(1)));
elseif gui.settings.value_crit_param == 2
    str_title_Weibull = strcat('Mean critical parameter= ', ...
        num2str(coefEsts(2) * mean([gui.data(:).mean_sum_h])), ...
        ' & Weibull modulus = ', num2str(coefEsts(1)));
end

line(gui.cumulativeFunction.xdata_cdf, gui.cumulativeFunction.ydata_cdf, ...
    'Color', 'r', 'LineWidth', 2);

legend({'Row data' 'Weibull model'}, 'Location', 'NorthWest');
xlabel('Critical parameter / Mean value of critical parameter');
ylabel('Weibull probability');
title(str_title_Weibull);

guidata(gcf, gui);

end