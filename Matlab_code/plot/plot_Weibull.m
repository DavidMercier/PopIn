%% Copyright 2014 MERCIER David
function plot_Weibull
%% Function to plot the probability density function or the cumulative distribution function
% obtained with Gauss or Weibull models...
gui = guidata(gcf);

set(gui.handles.MainWindows, 'CurrentAxes', gui.handles.AxisPlot_GUI_2);

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

for ii = 1:1:length(gui.data)
    gui.results(ii).data_to_plot = gui.results(ii).prob;
end

guidata(gcf, gui);
plot_cdf;
gui = guidata(gcf);

guidata(gcf, gui);

end
