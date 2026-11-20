function tests = test_runtime_compatibility
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.root = root;
testCase.applyFixture(matlab.unittest.fixtures.PathFixture(root));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
    fullfile(root, 'matlab_code', 'util')));
testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
    fullfile(root, 'matlab_code', 'statistics')));
end

function testWorkbookDisplacementAndLoadColumns(testCase)
filename = fullfile(testCase.TestData.root, 'indentation_data', ...
    'mts-XP_Indcon5um_Al2O3-40nm.xls');
[~, sheets] = xlsfinfo(filename);
[data, txt] = read_popin_sheet(filename, sheets{1});
[~, ~, raw] = xlsread(filename, sheets{1});
testCase.verifySize(data, [size(raw, 1)-2, 2]);
testCase.verifyEqual(data(1:8, 1), cell2mat(raw(3:10, 2)));
testCase.verifyEqual(data(1:8, 2), cell2mat(raw(3:10, 3)));
testCase.verifyTrue(all(isfinite(data(1:8, :)), 'all'));
testCase.verifyEqual(txt{1, 1}, 'Segment');
end

function testCorrectedDepthRangeCanBeRetried(testCase)
fig = figure('Visible', 'off');
cleanup = onCleanup(@() delete(fig));
gui.flag.flag_data = 1;
gui.flag.flag_cleaned_data = 0;
gui.settings.min_bound_h_init = 0;
gui.settings.max_bound_h_init = 10;
gui.settings.min_data_h_average = 3;
gui.settings.max_data_h_average = 7;
gui.data(1).data_h = (0:10)';
gui.data(1).data_L = (20:30)';
guidata(fig, gui);

clean_data_popin(1);

gui = guidata(fig);
testCase.verifyEqual(gui.flag.flag_cleaned_data, 1);
testCase.verifyEqual(gui.data(1).data_h_cleaned, (3:6)');
testCase.verifyEqual(gui.data(1).data_L_cleaned, (23:26)');
end

function testPathManagementBootstrapsHelpers(testCase)
root = testCase.TestData.root;
originalPath = path;
originalRoot = getenv('POPIN_TBX_ROOT');
cleanup = onCleanup(@() restoreEnvironment(originalPath, originalRoot));
rmpath(fullfile(root, 'matlab_code', 'util'));

testCase.verifyWarningFree(@() path_management('y'));

testCase.verifyEqual(which('path2cell'), ...
    fullfile(root, 'matlab_code', 'util', 'path2cell.m'));
testCase.verifyEqual(getenv('POPIN_TBX_ROOT'), root);
end

function restoreEnvironment(originalPath, originalRoot)
path(originalPath);
setenv('POPIN_TBX_ROOT', originalRoot);
end

function testDefaultIconUsesSupportedProperty(testCase)
fig = figure('Visible', 'off');
cleanup = onCleanup(@() delete(fig));
testCase.assumeTrue(isprop(fig, 'Icon'));
warningState = warning;

testCase.verifyWarningFree(@() java_icon_popin(fig));

testCase.verifyEqual(get(fig, 'Icon'), fullfile( ...
    testCase.TestData.root, 'docs', '_pictures', 'icon_popin.png'));
testCase.verifyEqual(warning, warningState);
end

function testExplicitIconTargetsRequestedFigure(testCase)
target = figure('Visible', 'off');
targetCleanup = onCleanup(@() delete(target));
testCase.assumeTrue(isprop(target, 'Icon'));
other = figure('Visible', 'off');
otherCleanup = onCleanup(@() delete(other));
otherIcon = get(other, 'Icon');
logo = fullfile(testCase.TestData.root, 'docs', '_pictures', ...
    'GUI_Main_Window.png');

testCase.verifyWarningFree(@() java_icon_popin(target, logo));

testCase.verifyEqual(get(target, 'Icon'), logo);
testCase.verifyEqual(get(other, 'Icon'), otherIcon);
end
