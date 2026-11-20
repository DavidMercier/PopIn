%% Copyright 2014 MERCIER David
function plot_cdf
%% Function to plot the probability density function or the cumulative distribution function
gui = guidata(gcf);

if ~isfield(gui, 'cumulativeFunction') || ...
        ~isfield(gui.cumulativeFunction, 'coefEsts')
    helpdlg('Run calculations before plotting the distribution.', 'Info');
    return;
end

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

% Plot of experimental results
h_data = plot(gui.handles.AxisPlot_2, ...
    [gui.results.xdata], [gui.results.ydata], ...
    'b+', 'MarkerSize', 10);

% Plot options
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

if strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(1,:)) || ...
        strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(2,:)) || ...
        strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(3,:)) || ...
        strcmp(gui.settings.cumulFunction, gui.settings.cumulFunctionList(4,:))
    str_title = ['Mean critical parameter = ', ...
        num2str(coefEsts(2)), ...
        ' / Weibull modulus = ', num2str(coefEsts(1))];
    if gui.settings.value_crit_param == 1
        %str_xlabel = 'Critical load (mN)';
        str_xlabel = 'Ratio of the critical load to the average critical load';
    else
        %str_xlabel = 'Critical displacement (nm)';
        str_xlabel = 'Ratio of the critical displacement to the average critical displacement';
    end
else
    str_title = strcat('$\eta$ = ', num2str(coefEsts(1)), ...
        ' / $\epsilon$ =', num2str(coefEsts(2)), ...
        ' / $V$(act) = ', num2str(coefEsts(3)));
    str_xlabel = 'Critical parameter';
end

% Plot of fitting distribution function
h_fit = line(gui.cumulativeFunction.xdata_cdf./gui.cumulativeFunction.coefEsts(2), ...
    gui.cumulativeFunction.ydata_cdf, ...
    'Color', 'r', 'LineWidth', 2);

% Legend and axis
listLoc = listLocationLegend;
value_legendLocation = get(gui.handles.value_legendLocation, 'Value');

Func = gui.settings.cumulFunction;
FuncList = gui.settings.cumulFunctionList;
legend_handles = [h_data, h_fit];

if strcmp(Func, FuncList(1,:)) || ...
        strcmp(Func, FuncList(2,:))
    legend_labels = {'Row data', 'Weibull model'};
elseif strcmp(Func, FuncList(3,:)) || ...
        strcmp(Func, FuncList(4,:))
    legend_labels = {'Row data', 'Weibull model modified by Chechenin'};
else
    legend_labels = {'Row data', 'Mason''s model'};
end

if get(gui.handles.cb_pdf_plot, 'Value')
    yyaxis(gui.handles.AxisPlot_2, 'right');
    h_pdf = histogram(gui.handles.AxisPlot_2, [gui.results.xdata], ...
        'Normalization', 'pdf', 'BinMethod', 'fd', ...
        'FaceColor', [0.2 0.6 0.8], 'FaceAlpha', 0.25, ...
        'EdgeColor', [0.2 0.6 0.8]);
    ylabel(gui.handles.AxisPlot_2, 'Probability density');
    ylim(gui.handles.AxisPlot_2, 'auto');
    xlim(gui.handles.AxisPlot_2, ...
        [min(0, h_pdf.BinEdges(1)), max(max_gui_results_xdata, h_pdf.BinEdges(end))]);
    legend_handles(end+1) = h_pdf;
    legend_labels{end+1} = 'PDF histogram';
    yyaxis(gui.handles.AxisPlot_2, 'left');
end

h_legend = legend(legend_handles, legend_labels, ...
    'Location', char(listLoc(value_legendLocation)));
if isprop(h_legend, 'AutoUpdate')
    set(h_legend, 'AutoUpdate', 'off');
end

h_xlabel = xlabel(str_xlabel);
h_ylabel = ylabel('Cumulative distribution');
h_title = title(str_title);

set([h_legend, h_xlabel, h_ylabel, h_title], 'Interpreter', 'Latex');

%% Plot of lines
if get(gui.handles.cb_cdf_lines, 'value') == 1
    xBoundary_1 = zeros(1,11)+1;
    yBoundary_1 = 0:0.1:1;
    plot(xBoundary_1, yBoundary_1, '--k'); hold on;
    
    xBoundary_2 = 0:100:1000;
    yBoundary_2 = zeros(1,11)+0.5;
    plot(xBoundary_2, yBoundary_2, '--k'); hold on;
end

guidata(gcf, gui);

end