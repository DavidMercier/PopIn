%% Copyright 2014 MERCIER David
function [indenter, data, numerics, flag_YAML] = load_YAML_configFile
%% Function used to load YAML configuration file

flag_YAML = 1;

configYAML = sprintf('indenter_config_popin.yaml');
if ~exist(configYAML, 'file')
    errordlg('indenters_config.yaml doesn''t exist !', 'File Error');
    flag_YAML = 0;
else
    indenter = ReadYaml(configYAML);
    
    if ~isfield(indenter, 'YoungModulus_Diamond')
        indenter.YoungModulus_Diamond = 1070; % in GPa
        commandwindow;
        warning('Wrong input for indenter''s Young''s modulus in indenters_config.yaml');
    end
    
    if ~isfield(indenter, 'PoissonRatio_Diamond')
        indenter.PoissonRatio_Diamond = 0.07;
        commandwindow;
        warning('Wrong input for indenter''s Poisson''s ratio in indenters_config.yaml');
    end
end

configYAML = sprintf('data_config_popin.yaml');
if ~exist(configYAML, 'file')
    errordlg('data_config.yaml doesn''t exist !', 'File Error');
    flag_YAML = 0;
else
    data = ReadYaml(configYAML);
    if ~isfield(data, 'data_path')
        data.data_path = '';
    end
end

configYAML = sprintf('numerics_config_popin.yaml');
if ~exist(configYAML, 'file')
    errordlg('numerics_config.yaml doesn''t exist !', 'File Error');
    flag_YAML = 0;
else
    numerics = ReadYaml(configYAML);
    
    if ~isfield(numerics, 'K')
        indenter.K = pi;
        commandwindow;
        warning('Wrong input for K in numerics_config.yaml');
    end
    
    if ~isfield(numerics, 'eta_var')
        indenter.eta_var = 8.9 * 1e23; % in s-1.m-3
        commandwindow;
        warning('Wrong input for neta_var in numerics_config.yaml');
    end
    
    if ~isfield(numerics, 'epsilon_var')
        indenter.epsilon_var = 0.5; %in eV
        commandwindow;
        warning('Wrong input for epsilon_var in numerics_config.yaml');
    end
    
    
    if ~isfield(numerics, 'Vact')
        indenter.Vact = 10; %in Angstrom3
        commandwindow;
        warning('Wrong input for Vact in numerics_config.yaml');
    end
    
    if ~isfield(numerics, 'k_Boltzmann')
        indenter.k_Boltzmann = 1.3806488 * 1e-23; %Boltzmann's constant in  m2.kg.s-2.K-1
        commandwindow;
        warning('Wrong input for k_Boltzmann in numerics_config.yaml');
    end
end

if flag_YAML
    commandwindow;
    display('YAML configuration files correctly loaded...');
end

end