%% Copyright 2014 MERCIER David
function plot_get_values
%% Function used to get values
gui = guidata(gcf);

if gui.flag.flag_data == 0
    errorLoadingData;
    
else
    [x_value, y_value] = ginput(1);
    
    set(gui.handles.value_x_values, 'String', ...
        num2str((round((x_value*1000)/10))/100));
    
    set(gui.handles.value_y_values, 'String', ...
        num2str((round((y_value*1000)/10))/100));
    
end

guidata(gcf, gui);

end