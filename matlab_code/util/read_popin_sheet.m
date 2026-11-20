function [data, txt] = read_popin_sheet(filename, sheet)
% Keep displacement and load aligned with the two spreadsheet header rows.
[~, txt, raw] = xlsread(filename, sheet);
if isempty(raw)
    data = [];
    return;
end
if size(raw, 2) < 3 || size(raw, 1) < 3 || ...
        ~ischar(raw{1, 2}) || ~strncmpi(raw{1, 2}, 'Displacement', 12) || ...
        ~ischar(raw{1, 3}) || ~strncmpi(raw{1, 3}, 'Load', 4)
    error('PopIn:InvalidWorksheet', ...
        'Worksheet "%s" must contain Segment, Displacement and Load columns with two header rows.', ...
        sheet);
end
values = raw(3:end, 2:3);
data = NaN(size(values));
numeric = cellfun(@(value) isnumeric(value) && isscalar(value), values);
data(numeric) = cell2mat(values(numeric));
end
