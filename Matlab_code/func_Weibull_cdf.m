%% Copyright 2014 MERCIER David
function func_Weibull_cdf
%% Function giving the Weibull probability density function and the Weibull cumulative distribution function
gui = guidata(gcf);

% Definition of tolerances % Initialization
tol_inf = 0.001;
tol_sup = 1000;
gui.flag.flag_error = 0;

%% Script to calculate the weibull cumulative distribution function
% Chechenin N. G. et al. (1995)

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
    [coefEsts, R, J, COVB, MSE]  = nlinfit(sort([gui.results(:).binCtrs]), [gui.results(:).data_to_plot], weibull_cdf_s, startingVals);
    
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

if gui.settings.value_crit_param == 1
    str_title_Weibull = strcat('Mean critical parameter= ', num2str(coefEsts(2) * mean([gui.data(:).mean_sum_L])), ' & Weibull modulus = ', num2str(coefEsts(1)));
elseif gui.settings.value_crit_param == 2
    str_title_Weibull = strcat('Mean critical parameter= ', num2str(coefEsts(2) * mean([gui.data(:).mean_sum_h])), ' & Weibull modulus = ', num2str(coefEsts(1)));
end

xgrid_cdf = linspace(0, max([gui.results.binCtrs]), 200);
line(xgrid_cdf, weibull_cdf_s(coefEsts, xgrid_cdf), 'Color', 'r', 'LineWidth', 2);

legend({'Row data' 'Weibull model'}, 'Location', 'NorthWest');
xlabel('Critical parameter / Mean value of critical parameter');
ylabel('Weibull probability');
title(str_title_Weibull);

if gui.flag.flag_error
    helpdlg(err.message);
end

gui.Weibull.coefEsts = coefEsts;
gui.Weibull.R = R;
gui.Weibull.J = J;
gui.Weibull.COVB = COVB;
gui.Weibull.MSE = MSE;

guidata(gcf, gui);

end
