%% Copyright 2014 MERCIER David
function Weibull_modified_cdf
%% Function giving the modified Weibull cumulative distribution function
% See Chechenin N. G. et al. (1995) - DOI: 10.1016/S0040-6090(94)06494-6
gui = guidata(gcf);

% Definition of tolerances % Initialization
tol_inf = 0.001;
tol_sup = 1000;
gui.flag.flag_error = 0;

% Model (survival function)
weibull_cdf_s =  @(p,x) (1 - exp(-log(2) .* ((x./p(2)).^p(1))));

% Model (mortality function)
%weibull_cdf_m =  @(p,x) (exp(-log(2) .* ((x./p(2)).^p(1))));

% Initialization of coefficients p(1) and p(2)
% p(1) = Weibull modulus
% p(1) --> 10 when good homogeneity in size defect distribution
% p(2) = Mean critical value
startingVals = [3 1];

% Estimation of coefficients to fit
try
    [coefEsts, R, J, COVB, MSE] = nlinfit(sort([gui.results(:).binCtrs]), ...
        [gui.results(:).data_to_plot], weibull_cdf_s, startingVals);
    
catch err
    display(err.message);
    coefEsts = startingVals;
    gui.flag.flag_error = 1;
end

if coefEsts(1) < tol_inf || coefEsts(1) > tol_sup
    coefEsts(1) = tol_inf;
    
elseif coefEsts(2) < tol_inf || coefEsts(2) > tol_sup
    coefEsts(2) = tol_sup;
    
end

coefEsts(1) = real(coefEsts(1));
coefEsts(2) = real(coefEsts(2));

gui.cumulativeFunction.xdata_cdf = ...
    linspace(0, max([gui.results.binCtrs]), 200);
gui.cumulativeFunction.ydata_cdf = ...
    weibull_cdf_s(coefEsts, gui.cumulativeFunction.xdata_cdf);

if gui.flag.flag_error
    helpdlg(err.message);
end

gui.cumulativeFunction.coefEsts = coefEsts;
gui.cumulativeFunction.R = R;
gui.cumulativeFunction.J = J;
gui.cumulativeFunction.COVB = COVB;
gui.cumulativeFunction.MSE = MSE;

guidata(gcf, gui);

end