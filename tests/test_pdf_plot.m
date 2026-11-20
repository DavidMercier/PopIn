function tests = test_pdf_plot
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
    fullfile(root, 'matlab_code', 'plot')));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
    fullfile(root, 'matlab_code', 'util')));
end

function testPdfTogglePreservesCdfAndRemovesRightAxis(testCase)
for criticalParameter = 1:2
    for model = 1:4
        x = linspace(0.1, 3, 30);
        if model == 2 || model == 4
            x = fliplr(x);
        end
        gui = createPlot(testCase, x, criticalParameter, model);
        plot_cdf;
        originalLimits = ylim(gui.handles.AxisPlot_2);
        testCase.verifyEmpty(findobj(gui.handles.AxisPlot_2, 'Type', 'histogram'));

        set(gui.handles.cb_pdf_plot, 'Value', 1);
        plot_cdf;
        ax = gui.handles.AxisPlot_2;
        hist = findobj(ax, 'Type', 'histogram');
        testCase.verifyNumElements(hist, 1);
        testCase.verifyEqual(hist.Data(:), x(:));
        testCase.verifyEqual(sum(hist.Values .* diff(hist.BinEdges)), 1, ...
            'AbsTol', 1e-12);
        testCase.verifyNumElements(ax.YAxis, 2);
        testCase.verifyEqual(ylim(ax), originalLimits);
        observed = findobj(ax, 'Type', 'line', 'Marker', '+');
        testCase.verifyEqual(observed.XData, x);
        testCase.verifyEqual(observed.YData, [gui.results.ydata]);
        testCase.verifyNumElements(ax.Legend.String, 3);

        set(gui.handles.cb_pdf_plot, 'Value', 0);
        plot_cdf;
        testCase.verifyEmpty(findobj(ax, 'Type', 'histogram'));
        testCase.verifyNumElements(ax.YAxis, 1);
        testCase.verifyNumElements(ax.Legend.String, 2);
    end
end
end

function testPdfHandlesSmallAndConstantSamples(testCase)
for samples = {[1 1 1 1], [0.5 1.5]}
    gui = createPlot(testCase, samples{1}, 1, 1);
    set(gui.handles.cb_pdf_plot, 'Value', 1);
    plot_cdf;
    hist = findobj(gui.handles.AxisPlot_2, 'Type', 'histogram');
    testCase.verifyTrue(all(isfinite(hist.Values)));
    testCase.verifyEqual(sum(hist.Values .* diff(hist.BinEdges)), 1, ...
        'AbsTol', 1e-12);
    limits = xlim(gui.handles.AxisPlot_2);
    testCase.verifyLessThanOrEqual(limits(1), hist.BinEdges(1));
    testCase.verifyGreaterThanOrEqual(limits(2), hist.BinEdges(end));
end
end

function gui = createPlot(testCase, samples, criticalParameter, model)
fig = figure('Visible', 'off');
testCase.addTeardown(@() delete(fig));
gui.handles.MainWindows = fig;
gui.handles.AxisPlot_2 = axes('Parent', fig);
gui.handles.cb_pdf_plot = uicontrol(fig, 'Style', 'checkbox', 'Value', 0);
gui.handles.cb_cdf_lines = uicontrol(fig, 'Style', 'checkbox', 'Value', 1);
gui.handles.value_legendLocation = uicontrol(fig, 'Style', 'popupmenu', ...
    'String', listLocationLegend, 'Value', 6);
gui.settings.grid_plot_value = 1;
gui.settings.value_crit_param = criticalParameter;
gui.settings.cumulFunctionList = char('Weibull (mortal)', ...
    'Weibull (survival)', 'Chechenin (mortal)', 'Chechenin (survival)', 'Mason');
gui.settings.cumulFunction = gui.settings.cumulFunctionList(model, :);
for k = 1:numel(samples)
    gui.results(k).xdata = samples(k);
    gui.results(k).ydata = k / numel(samples);
end
gui.cumulativeFunction.coefEsts = [2; 1];
gui.cumulativeFunction.xdata_cdf = samples;
gui.cumulativeFunction.ydata_cdf = [gui.results.ydata];
guidata(fig, gui);
end
