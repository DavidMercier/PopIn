%% Copyright 2014 MERCIER David
function [string, edit_box, unit_string] = ...
    set_inputs_boxes(str, val, unit, pos, callback, ratio, parent, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% str : string for the txt box
% val : value of the variable to edit in corresponding editable txt box
% unit : string for the unit txt box
% pos : position of the txt box
% callback : callback function or script to assess to the editable txt box
% ratio: ratio betweem string box and edit box
% parent: handle of the parent

if nargin < 7
    parent = gcf;
end

if nargin < 6
    ratio = 0.75;
end

if nargin < 5
    callback = '';
end

if nargin < 4
    pos = [0.9 0.9 0.9];
end

if nargin < 3
    val = '';
end

if nargin < 2
    unit = '';
end

if nargin < 1
    str = 'test';
end

string = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'Position', [pos(1) pos(2) pos(3)*ratio pos(4)],...
    'String', [str, ' '],...
    'HorizontalAlignment','left', ...
    'Style', 'text');

if ratio ~= 1
    edit_box = uicontrol('Parent', parent,...
        'Units', 'normalized',...
        'Position', [pos(1)+1.01*(pos(3)*ratio) ...
        pos(2) pos(3)*(1-ratio) pos(4)],...
        'String', val,...
        'Style', 'edit',...
        'Callback', callback);
    
    unit_string = uicontrol('Parent', parent,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [pos(1)+1.01*(pos(3)*ratio) + pos(3)*(1-ratio) ...
        pos(2) pos(3)/1.5*(1-ratio) pos(4)],...
        'String', unit,...
        'HorizontalAlignment', 'center',...
        'Visible', 'on');
else
    edit_box = NaN;
    unit_string = NaN;
end

end