%% Copyright 2014 MERCIER David
function plot_cdf
%% Function to plot the probability density function or the cumulative distribution function
gui = guidata(gcf);

% Clear axis
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

guidata(gcf, gui);
func_Weibull_cdf;
gui = guidata(gcf);

guidata(gcf, gui);

end