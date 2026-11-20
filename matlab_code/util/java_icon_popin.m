%% Copyright 2014 MERCIER David
function java_icon_popin(gui_handle, logo, varargin)
%% To change icon of the GUI
% gui_handle: Handle of the GUI
% logo: Picture used as a logo for the GUI

% author: d.mercier@mpie.de

if nargin < 2
    root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
    logo = fullfile(root, 'docs', '_pictures', 'icon_popin.png');
end

if nargin < 1
    gui_handle = gcf;
end

if isprop(gui_handle, 'Icon')
    set(gui_handle, 'Icon', logo);
elseif verLessThan('matlab', '25.1') && usejava('awt') && usejava('desktop')
    wrn = warning('off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    cleanup = onCleanup(@() warning(wrn));
    jframe = get(gui_handle, 'JavaFrame');
    jIcon = javax.swing.ImageIcon(logo);
    jframe.setFigureIcon(jIcon);
else
    warning('PopIn:FigureIconUnavailable', ...
        'Custom figure icons are not supported in this MATLAB environment.');
end

end