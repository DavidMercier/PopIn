%% Copyright 2014 MERCIER David
function weibull_modified_cdf_survival(OPTIONS, xdata_fit, ydata_fit)
%% Function giving the modified Weibull cumulative distribution function
% See Chechenin N. G. et al. (1995) - DOI: 10.1016/S0040-6090(94)06494-6
gui = guidata(gcf);

gui.cumulativeFunction.xdata_cdf = xdata_fit;

% Model (survival function)
weibull_cdf_s = @(p,x) (exp(-log(2) .* ((x./p(2)).^p(1))));

% Make a starting guess of coefficients p(1) and p(2)
% p(1) = Weibull modulus --> 10 when good homogeneity in size defect distribution
% p(2) = Mean critical value
gui.cumulativeFunction.p0 = ...
    [1 ; mean(xdata_fit)];

[gui.cumulativeFunction.coefEsts, ...
    gui.cumulativeFunction.resnorm, ...
    gui.cumulativeFunction.residual, ...
    gui.cumulativeFunction.exitflag, ...
    gui.cumulativeFunction.output, ...
    gui.cumulativeFunction.lambda, ...
    gui.cumulativeFunction.jacobian] =...
    lsqcurvefit(weibull_cdf_s, gui.cumulativeFunction.p0, ...
    gui.cumulativeFunction.xdata_cdf, ydata_fit, ...
    [gui.config.numerics.Min_mChechenin ; 0], ...
    [gui.config.numerics.Max_mChechenin ; max(xdata_fit)], ...
    OPTIONS);

gui.cumulativeFunction.coefEsts(1) = ...
    real(gui.cumulativeFunction.coefEsts(1));
gui.cumulativeFunction.coefEsts(2) = ...
    real(gui.cumulativeFunction.coefEsts(2));

gui.cumulativeFunction.ydata_cdf = ...
    exp(-log(2) .* (gui.cumulativeFunction.xdata_cdf./gui.cumulativeFunction.coefEsts(2)) ...
    .^ gui.cumulativeFunction.coefEsts(1));

guidata(gcf, gui);

end