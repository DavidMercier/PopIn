function result = popin_energy(depth_m, load_N, first, last, options)
% Quasi-static event energy balance; all inputs use SI units.
if nargin < 5
    options = struct();
end
validateattributes(depth_m, {'numeric'}, {'real', 'vector', 'finite'});
validateattributes(load_N, {'numeric'}, {'real', 'vector', 'finite', ...
    'numel', numel(depth_m)});
if ~is_sample_index(first) || ~is_sample_index(last) || ...
        first < 1 || last <= first || last > numel(depth_m)
    error('PopIn:InvalidInterval', ...
        ['Start and end must be whole-number sample indices, not displacement values. ' ...
        'Use 1 <= start < end <= %d. Neither field may be blank.'], numel(depth_m));
end
validateattributes(options, {'struct'}, {'scalar'});
h = depth_m(first:last);
P = load_N(first:last);
if h(end) <= h(1) || any(P < 0)
    error('PopIn:InvalidEvent', ...
        'The event must have positive net penetration and nonnegative loads.');
end

result.start_index = first;
result.end_index = last;
result.start_depth_nm = h(1) * 1e9;
result.end_depth_nm = h(end) * 1e9;
result.length_nm = (h(end) - h(1)) * 1e9;
result.start_load_mN = P(1) * 1e3;
result.end_load_mN = P(end) * 1e3;
result.external_work_nJ = trapz(h(:), P(:)) * 1e9;
result.delta_elastic_energy_nJ = NaN;
result.dissipated_energy_nJ = NaN;
result.fracture_fraction = NaN;
result.fracture_area_um2 = NaN;
result.fracture_energy_nJ = NaN;
result.Gc_J_m2 = NaN;
result.young_modulus_GPa = NaN;
result.poisson_ratio = NaN;
result.stress_state = 'not specified';
result.K_estimate_MPa_sqrt_m = NaN;
result.status = 'Work only: elastic energy change not supplied';

hasElastic = isfield(options, 'deltaElasticEnergy_J');
hasArea = isfield(options, 'fractureArea_m2');
hasFraction = isfield(options, 'fractureFraction');
if hasArea ~= hasFraction || ((hasArea || hasFraction) && ~hasElastic)
    missing = {'elastic energy change', 'fracture area', 'fracture fraction'};
    missing = missing(~[hasElastic, hasArea, hasFraction]);
    error('PopIn:MissingEnergyInputs', ...
        ['Missing for fracture estimation: %s. Supply elastic energy change, ' ...
        'fracture area and fracture fraction together. For dissipation only, ' ...
        'supply elastic energy change with both fracture fields left blank. ' ...
        'For applied work only, leave all three blank. ' ...
        'Do not invent values for unknown inputs.'], strjoin(missing, ', '));
end
if hasElastic
    validateattributes(options.deltaElasticEnergy_J, {'numeric'}, ...
        {'real', 'finite', 'scalar'});
    result.delta_elastic_energy_nJ = options.deltaElasticEnergy_J * 1e9;
    result.dissipated_energy_nJ = result.external_work_nJ - ...
        result.delta_elastic_energy_nJ;
    if result.dissipated_energy_nJ < 0
        error('PopIn:NegativeDissipation', ...
            'Elastic energy change exceeds applied work; review the event and energy model.');
    end
    result.status = 'Dissipation only: fracture inputs not supplied';
end
if hasArea
    validateattributes(options.fractureArea_m2, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'positive'});
    validateattributes(options.fractureFraction, {'numeric'}, ...
        {'real', 'finite', 'scalar', '>=', 0, '<=', 1});
    required = {'youngModulus_Pa', 'poissonRatio', 'stressState'};
    if ~all(isfield(options, required))
        error('PopIn:MissingFractureInputs', ...
            'Supply specimen Young''s modulus, Poisson''s ratio and plane stress/strain state.');
    end
    validateattributes(options.youngModulus_Pa, {'numeric'}, ...
        {'real', 'finite', 'scalar', 'positive'});
    validateattributes(options.poissonRatio, {'numeric'}, ...
        {'real', 'finite', 'scalar', '>', -1, '<', 0.5});
    state = validatestring(options.stressState, {'plane strain', 'plane stress'});
    effectiveModulus = options.youngModulus_Pa;
    if strcmp(state, 'plane strain')
        effectiveModulus = effectiveModulus / (1 - options.poissonRatio^2);
    end
    result.fracture_fraction = options.fractureFraction;
    result.fracture_area_um2 = options.fractureArea_m2 * 1e12;
    result.fracture_energy_nJ = result.dissipated_energy_nJ * options.fractureFraction;
    result.Gc_J_m2 = result.fracture_energy_nJ * 1e-9 / options.fractureArea_m2;
    result.young_modulus_GPa = options.youngModulus_Pa * 1e-9;
    result.poisson_ratio = options.poissonRatio;
    result.stress_state = state;
    result.K_estimate_MPa_sqrt_m = sqrt(effectiveModulus * result.Gc_J_m2) * 1e-6;
    result.status = 'Conditional LEFM estimate, not a validated KIc measurement';
end
end

function valid = is_sample_index(index)
valid = isnumeric(index) && isreal(index) && isscalar(index) && ...
    isfinite(index) && index == fix(index);
end
