%% Copyright 2014 MERCIER David
function Weibull_cdf
%% Function giving the Weibull cumulative distribution function
% See http://de.mathworks.com/help/stats/cdf.html
gui = guidata(gcf);

[coefEsts_1, coefEsts_2] = wblfit([gui.results(:).data_to_plot]);

gui.cumulativeFunction.xdata_cdf = ...
    linspace(0, max([gui.results.binCtrs]), 200);
gui.cumulativeFunction.ydata_cdf = ...
    cdf('Weibull', gui.cumulativeFunction.xdata_cdf, coefEsts_1(1), coefEsts_1(2));

if gui.flag.flag_error
    helpdlg(err.message);
end

gui.Weibull.coefEsts = coefEsts_1;
gui.Weibull.coefEsts2 = coefEsts_2;

guidata(gcf, gui);

end