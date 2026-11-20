function tests = test_popin_energy
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
    fullfile(root, 'matlab_code', 'statistics')));
end

function testConstantLoadJumpAndMissingPhysics(testCase)
r = popin_energy([0 10 30 40]' * 1e-9, ones(4, 1) * 2e-3, 2, 3);
testCase.verifyEqual(r.length_nm, 20, 'AbsTol', 1e-12);
testCase.verifyEqual(r.external_work_nJ, 0.04, 'AbsTol', 1e-12);
testCase.verifyTrue(isnan(r.dissipated_energy_nJ));
testCase.verifyTrue(isnan(r.K_estimate_MPa_sqrt_m));
end

function testIntegrationUsesAllSamplesAndAcquisitionOrder(testCase)
r = popin_energy([0 10 30] * 1e-9, [1 3 2] * 1e-3, 1, 3);
testCase.verifyEqual(r.external_work_nJ, 0.07, 'AbsTol', 1e-12);
% Preserve small unloading segments, rather than sorting penetration values.
r = popin_energy([0 20 10 30] * 1e-9, [1 3 2 4] * 1e-3, 1, 4);
testCase.verifyEqual(r.external_work_nJ, 0.075, 'AbsTol', 1e-12);
end

function testExplicitElasticEnergyChange(testCase)
o.deltaElasticEnergy_J = 1e-11;
r = popin_energy([0 20] * 1e-9, [2 2] * 1e-3, 1, 2, o);
testCase.verifyEqual(r.dissipated_energy_nJ, 0.03, 'AbsTol', 1e-12);
testCase.verifyTrue(isnan(r.fracture_energy_nJ));
o.deltaElasticEnergy_J = -1e-11;
r = popin_energy([0 20] * 1e-9, [2 2] * 1e-3, 1, 2, o);
testCase.verifyEqual(r.dissipated_energy_nJ, 0.05, 'AbsTol', 1e-12);
end

function testFracturePartitionAreaAndStressState(testCase)
o = fracture_options();
r = popin_energy([0 20] * 1e-9, [2 2] * 1e-3, 1, 2, o);
testCase.verifyEqual(r.fracture_energy_nJ, 0.02, 'AbsTol', 1e-12);
testCase.verifyEqual(r.Gc_J_m2, 10, 'AbsTol', 1e-12);
testCase.verifyEqual(r.K_estimate_MPa_sqrt_m, 1, 'AbsTol', 1e-12);
o.stressState = 'plane strain';
r = popin_energy([0 20] * 1e-9, [2 2] * 1e-3, 1, 2, o);
testCase.verifyEqual(r.K_estimate_MPa_sqrt_m, sqrt(1 / 0.91), 'AbsTol', 1e-12);
o.fractureFraction = 0;
r = popin_energy([0 20] * 1e-9, [2 2] * 1e-3, 1, 2, o);
testCase.verifyEqual(r.K_estimate_MPa_sqrt_m, 0);
end

function testRejectsUnphysicalAndIncompleteEnergyBalances(testCase)
h = [0 20] * 1e-9;
P = [2 2] * 1e-3;
o.deltaElasticEnergy_J = 5e-11;
testCase.verifyError(@() popin_energy(h, P, 1, 2, o), 'PopIn:NegativeDissipation');
o = struct('fractureArea_m2', 1e-12);
testCase.verifyError(@() popin_energy(h, P, 1, 2, o), 'PopIn:MissingEnergyInputs');
o.fractureFraction = 1;
testCase.verifyError(@() popin_energy(h, P, 1, 2, o), 'PopIn:MissingEnergyInputs');
o.deltaElasticEnergy_J = 0;
testCase.verifyError(@() popin_energy(h, P, 1, 2, o), 'PopIn:MissingFractureInputs');
testCase.verifyError(@() popin_energy(fliplr(h), P, 1, 2), 'PopIn:InvalidEvent');
testCase.verifyError(@() popin_energy(h, -P, 1, 2), 'PopIn:InvalidEvent');
end

function testRejectsInvalidIntervalsAndGeometry(testCase)
h = [0 20] * 1e-9;
P = [2 2] * 1e-3;
testCase.verifyError(@() popin_energy(h, P, 0, 2), 'PopIn:InvalidInterval');
testCase.verifyError(@() popin_energy(h, P, 2, 1), 'PopIn:InvalidInterval');
testCase.verifyError(@() popin_energy(h, P, 1, 3), 'PopIn:InvalidInterval');
testCase.verifyError(@() popin_energy([0 NaN], P, 1, 2), 'MATLAB:expectedFinite');
o = fracture_options();
o.fractureArea_m2 = 0;
testCase.verifyError(@() popin_energy(h, P, 1, 2, o), 'MATLAB:expectedPositive');
o = fracture_options();
o.fractureFraction = 1.1;
testCase.verifyError(@() popin_energy(h, P, 1, 2, o), 'MATLAB:notLessEqual');
end

function testMissingEnergyInputsIdentifyFieldsAndRecovery(testCase)
o = fracture_options();
cases = { ...
    rmfield(o, 'fractureFraction'), 'fracture fraction'; ...
    rmfield(o, 'fractureArea_m2'), 'fracture area'; ...
    rmfield(o, 'deltaElasticEnergy_J'), 'elastic energy change'; ...
    struct('fractureArea_m2', 2e-12), 'elastic energy change, fracture fraction'};
for k = 1:size(cases, 1)
    message = '';
    try
        popin_energy([0 20] * 1e-9, [2 2] * 1e-3, 1, 2, cases{k, 1});
    catch exception
        if ~strcmp(exception.identifier, 'PopIn:MissingEnergyInputs')
            rethrow(exception);
        end
        message = exception.message;
    end
    testCase.verifySubstring(message, ['Missing for fracture estimation: ', cases{k, 2}, '.']);
    testCase.verifySubstring(message, 'both fracture fields left blank');
    testCase.verifySubstring(message, 'For applied work only, leave all three blank.');
end
end

function testRejectsFractionalOrMissingSampleIndices(testCase)
h = [0 10 20] * 1e-9;
P = [2 2 2] * 1e-3;
bounds = {[1 2.5], [1 NaN], [NaN 3], [1 Inf], [1.5 3]};
for k = 1:numel(bounds)
    pair = bounds{k};
    testCase.verifyError(@() popin_energy(h, P, pair(1), pair(2)), ...
        'PopIn:InvalidInterval');
end
end

function o = fracture_options()
o.deltaElasticEnergy_J = -1e-11;
o.fractureArea_m2 = 2e-12;
o.fractureFraction = 0.4;
o.youngModulus_Pa = 100e9;
o.poissonRatio = 0.3;
o.stressState = 'plane stress';
end
