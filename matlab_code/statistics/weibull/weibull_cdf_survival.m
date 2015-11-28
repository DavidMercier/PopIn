%% Copyright 2014 MERCIER David
function weibull_cdf_survival(OPTIONS, xdata_fit, ydata_fit)
%% Function giving the Weibull cumulative distribution function
% See http://de.mathworks.com/help/stats/wblcdf.html
% See Weibull W., “A statistical distribution function of wide applicability”, J. Appl. Mech.-Trans. ASME (1951), 18(3).

gui = guidata(gcf);

gui.cumulativeFunction.xdata_cdf = xdata_fit;

% Model (survival function)
weibull_cdf_s = @(p,x) (exp(-(x./p(2)).^p(1)));

% Make a starting guess of coefficients p(1) and p(2)
% p(1) = Weibull modulus --> 10 when good homogeneity in size defect distribution
% p(2) = Mean critical value
gui.cumulativeFunction.p0 = [1 ; mean(xdata_fit)];

if gui.config.licenceFlag
    [gui.cumulativeFunction.coefEsts, ...
        gui.cumulativeFunction.resnorm, ...
        gui.cumulativeFunction.residual, ...
        gui.cumulativeFunction.exitflag, ...
        gui.cumulativeFunction.output, ...
        gui.cumulativeFunction.lambda, ...
        gui.cumulativeFunction.jacobian] =...
        lsqcurvefit(weibull_cdf_s, gui.cumulativeFunction.p0, ...
        gui.cumulativeFunction.xdata_cdf, ydata_fit, ...
        [gui.config.numerics.Min_mWeibull ; 0], ...
        [gui.config.numerics.Max_mWeibull ; max(xdata_fit)], ...
        OPTIONS);
else
    model = @LMS;
    gui.cumulativeFunction.coefEsts = fminsearch(model, gui.cumulativeFunction.p0);
    warning('No Optimization toolbox available !');
end

    function [sse, FittedCurve] = LMS(params)
        p(1) = params(1);
        p(2) = params(2);
        FittedCurve = (exp(-(gui.cumulativeFunction.xdata_cdf./p(2)).^p(1)));
        ErrorVector = FittedCurve - ydata_fit;
        sse = sum(ErrorVector .^ 2);
    end

gui.cumulativeFunction.coefEsts(1) = ...
    real(gui.cumulativeFunction.coefEsts(1));
gui.cumulativeFunction.coefEsts(2) = ...
    real(gui.cumulativeFunction.coefEsts(2));

gui.cumulativeFunction.ydata_cdf = ...
    exp(-(gui.cumulativeFunction.xdata_cdf./gui.cumulativeFunction.coefEsts(2)) ...
    .^ gui.cumulativeFunction.coefEsts(1));

guidata(gcf, gui);

end