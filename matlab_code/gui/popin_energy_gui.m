function popin_energy_gui(main)
if nargin < 1
    main = gcf;
end
gui = guidata(main);
if ~isfield(gui, 'data') || ~isfield(gui.data, 'data_h_cleaned')
    helpdlg('Run calculations before extracting a pop-in interval.', 'Info');
    return;
end
answer = inputdlg(sprintf('Curve number (1 to %d):', numel(gui.data)), ...
    'Pop-in length and energy', 1, {'1'});
if isempty(answer)
    return;
end
curve = str2double(answer{1});
validateattributes(curve, {'numeric'}, ...
    {'scalar', 'integer', 'positive', '<=', numel(gui.data)});
h = gui.data(curve).data_h_cleaned;
P = gui.data(curve).data_L_cleaned;
if numel(h) < 2
    error('PopIn:InsufficientData', 'The selected curve has fewer than two samples.');
end
startHint = '';
endHint = '';
if isfield(gui.data, 'num_popin_int')
    candidates = gui.data(curve).num_popin_int;
    candidates = candidates(candidates >= 1 & candidates < numel(h));
    if ~isempty(candidates)
        startHint = num2str(candidates(1));
    end
end
factors = [1e-9, 1e-6, 1e-3];
depthFactor = factors(get(gui.handles.unitDisp, 'Value'));
loadFactor = factors(get(gui.handles.unitLoad, 'Value'));
preview = figure('Name', 'Review event boundaries by cleaned sample index', ...
    'NumberTitle', 'off');
previewCleanup = onCleanup(@() delete(preview));
ax = axes('Parent', preview);
yyaxis(ax, 'left');
plot(ax, h * depthFactor * 1e9, '.-');
ylabel(ax, 'Displacement (nm)');
yyaxis(ax, 'right');
plot(ax, P * loadFactor * 1e3, '.-');
ylabel(ax, 'Load (mN)');
xlabel(ax, 'Sample index (cleaned curve)');
title(ax, 'Choose the full burst; detected peaks are only hints');
if ~isempty(startHint)
    hint = str2double(startHint);
    xlim(ax, [max(1, hint-20), min(numel(h), hint+80)]);
end
grid(ax, 'on');
drawnow;
prompts = { ...
    sprintf('Start sample INDEX (whole number, 1 to %d; NOT displacement):', numel(h)), ...
    sprintf('End sample INDEX (whole number, greater than start, at most %d):', numel(h)), ...
    'Elastic energy change, U_after - U_before (nJ; blank = unknown; 0 assumes none):', ...
    'Incremental projected fracture area (um^2; blank = no toughness):', ...
    'Fraction of dissipation due to fracture (0 to 1; blank = unknown):', ...
    'Specimen Young''s modulus (GPa):', ...
    'Specimen Poisson''s ratio:', ...
    'LEFM constraint: plane strain or plane stress:'};
defaults = {startHint, endHint, '', '', '', ...
    get(gui.handles.value_YoungModulus, 'String'), ...
    get(gui.handles.value_PoissonRatio, 'String'), 'plane strain'};
while true
    answer = popin_energy_input(prompts, defaults);
    if isempty(answer)
        return;
    end
    options = struct();
    if ~isempty(strtrim(answer{3}))
        options.deltaElasticEnergy_J = str2double(answer{3}) * 1e-9;
    end
    if ~isempty(strtrim(answer{4}))
        options.fractureArea_m2 = str2double(answer{4}) * 1e-12;
    end
    if ~isempty(strtrim(answer{5}))
        options.fractureFraction = str2double(answer{5});
    end
    options.youngModulus_Pa = str2double(answer{6}) * 1e9;
    options.poissonRatio = str2double(answer{7});
    options.stressState = answer{8};
    try
        result = popin_energy(h * depthFactor, P * loadFactor, ...
            str2double(answer{1}), str2double(answer{2}), options);
    catch exception
        switch exception.identifier
            case 'PopIn:InvalidInterval'
                errorTitle = 'Invalid pop-in interval';
            case {'PopIn:MissingEnergyInputs', 'PopIn:MissingFractureInputs'}
                errorTitle = 'Incomplete energy / toughness inputs';
            otherwise
                rethrow(exception);
        end
        defaults = answer;
        uiwait(errordlg(exception.message, errorTitle, 'modal'));
        continue;
    end
    break;
end
result.curve = curve;
result.source_file = fullfile(gui.data_xls.pathname_data, gui.data_xls.filename_data);
clear previewCleanup;

fig = figure('Name', 'PopIn - event length, work and conditional toughness', ...
    'NumberTitle', 'off', 'Position', [100 100 1100 650]);
ax = axes('Parent', fig, 'Position', [0.08 0.16 0.50 0.70]);
plot(ax, h * depthFactor * 1e9, P * loadFactor * 1e3, 'b.-');
hold(ax, 'on');
indices = result.start_index:result.end_index;
plot(ax, h(indices) * depthFactor * 1e9, ...
    P(indices) * loadFactor * 1e3, 'r.-', 'LineWidth', 2);
plot(ax, h(indices([1 end])) * depthFactor * 1e9, ...
    P(indices([1 end])) * loadFactor * 1e3, 'ko', 'MarkerSize', 8);
xlabel(ax, 'Displacement (nm)');
ylabel(ax, 'Load (mN)');
title(ax, sprintf('Curve %d, samples %d to %d: review event boundaries', ...
    curve, result.start_index, result.end_index));
grid(ax, 'on');
names = fieldnames(result);
values = struct2cell(result);
for k = 1:numel(values)
    if isnumeric(values{k})
        if isnan(values{k})
            values{k} = 'not calculated';
        else
            values{k} = sprintf('%.8g', values{k});
        end
    end
end
uitable('Parent', fig, 'Units', 'normalized', ...
    'Position', [0.64 0.17 0.35 0.70], ...
    'Data', [names, values], 'ColumnName', {'Quantity (units in name)', 'Value'}, ...
    'RowName', [], 'ColumnWidth', {220, 130});
uicontrol(fig, 'Style', 'text', 'Units', 'normalized', ...
    'Position', [0.03 0.90 0.94 0.07], ...
    'String', {result.status, ...
    'Quasi-static balance only. Plasticity, kinetics and machine compliance require independent assessment.'});
uicontrol(fig, 'Style', 'pushbutton', 'Units', 'normalized', ...
    'Position', [0.64 0.05 0.16 0.06], 'String', 'Extract another interval', ...
    'Callback', @(~, ~) popin_energy_gui(main));
uicontrol(fig, 'Style', 'pushbutton', 'Units', 'normalized', ...
    'Position', [0.83 0.05 0.15 0.06], 'String', 'Export event CSV', ...
    'Callback', @(~, ~) export_event(result));
end

function export_event(result)
[filename, folder] = uiputfile('*.csv', 'Export pop-in energy', 'popin_energy.csv');
if isequal(filename, 0)
    return;
end
writetable(struct2table(result), fullfile(folder, filename));
end
