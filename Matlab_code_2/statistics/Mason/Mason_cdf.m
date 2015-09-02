%% Copyright 2014 MERCIER David
function Mason_cdf(OPTIONS, xdata_fit, ydata_fit)
%% Function giving the cumulative distribution in function of the temperature and the loadrate
% See Mason et al. (2006) - DOI: 10.1103/PhysRevB.73.054102

gui = guidata(gcf);

gui.cumulativeFunction.xdata_cdf = xdata_fit; % Load in mN

E1 = gui.config.indenter.YoungModulus_Diamond;
E2 = gui.settings.value_YoungModulus;
R1 = gui.settings.value_TipRadius;
R2 = +inf;
T = gui.settings.value_temperature; % in Celsius degrees
loadrate = gui.settings.value_loadrate;
k_Boltzmann = gui.config.numerics.k_Boltzmann; % in m2.kg.s-2.K-1
K = gui.config.numerics.K;

Rred = reducedValue(R1, R2) * 1e-6; % in m
Ered = reducedValue(E1, E2) * 1e9; % in N/m2

T = Celsius2Kelvin(T);
loadrate = loadrate * 1e-3; % in N/s
epsilon_var = gui.config.numerics.epsilon_var * 1.60217657*1e-19;  % in J = in kg.m2.s-2

% Model (survival function)
mason_cdf_s =  @(p,x) ...
    (1 - exp(-((9*K*Rred*p(1)) ./ ...
    (4.*Ered.*loadrate.*(alphaMason(R1, R2, E1, E2, T, p(3))).^6)) .* ...
    exp(-(p(2)./(k_Boltzmann.*T))) .* ...
    betaMason(x, R1, R2, E1, E2, T, p(3))));

% Model (mortality function)
% mason_cdf_m =  @(p,x) ...
%     (1 - exp(-((9*K*Rred*p(1)) ./ ...
%     (4*Ered*loadrate*alphaMason(R1, R2, E1, E2, T, p(3))^6)) .* ...
%     exp(-(p(2)/(k_Boltzmann*T))) .* ...
%     betaMason(load, R1, R2, E1, E2, T, p(3))));

% Make a starting guess of coefficients p(1), p(2) and p(3)
gui.cumulativeFunction.p0 = ...
    [gui.config.numerics.eta_var ; ...
    epsilon_var ; ...
    gui.config.numerics.Vact];

[gui.cumulativeFunction.coefEsts, ...
    gui.cumulativeFunction.resnorm, ...
    gui.cumulativeFunction.residual, ...
    gui.cumulativeFunction.exitflag, ...
    gui.cumulativeFunction.output, ...
    gui.cumulativeFunction.lambda, ...
    gui.cumulativeFunction.jacobian] =...
    lsqcurvefit(mason_cdf_s, gui.cumulativeFunction.p0, ...
    gui.cumulativeFunction.xdata_cdf, ydata_fit, ...
    [0 ; 0 ; 0], ...
    [gui.config.numerics.eta_var * 1e2 ; ...
    gui.config.numerics.epsilon_var * 1e2 ; ...
    gui.config.numerics.Vact * 1e2], ...
    OPTIONS);

gui.cumulativeFunction.coefEsts(1) = ...
    real(gui.cumulativeFunction.coefEsts(1));
gui.cumulativeFunction.coefEsts(2) = ...
    real(gui.cumulativeFunction.coefEsts(2));
gui.cumulativeFunction.coefEsts(3) = ...
    real(gui.cumulativeFunction.coefEsts(3));

gui.cumulativeFunction.ydata_cdf = ...
    cumulativeFraction(gui.cumulativeFunction.xdata_cdf, loadrate * 1e3, R1, R2, E1, E2, ...
    T, gui.cumulativeFunction.coefEsts(3), gui.cumulativeFunction.coefEsts(2)/1.60217657e-19, gui.cumulativeFunction.coefEsts(1), K);

guidata(gcf, gui);

end