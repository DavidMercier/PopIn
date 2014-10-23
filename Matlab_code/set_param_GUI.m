%% Copyright 2014 MERCIER David
function set_param_GUI
%% Function used to set the pop-up menu in the GUI
%% Get data from the GUI
gui = guidata(gcf);

if get(gui.handles.value_modeldistr_GUI, 'Value') == 1
    
    list_functions = {'Probability_density_function' ; 'Cumulative_distribution_function' ; 'Both_functions'};
    
else
    list_functions = {'Probability_density_function'};
    
end

set(gui.handles.value_function_GUI, 'String', list_functions);
set(gui.handles.value_function_GUI, 'Value', 1);

guidata(gcf, gui);

end