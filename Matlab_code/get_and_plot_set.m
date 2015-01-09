%% Copyright 2014 MERCIER David
function get_and_plot_set
%% Function used to get and plot data
gui = guidata(gcf);

gui.flag.flag_plot = 0;
guidata(gcf, gui);

get_and_plot;
gui = guidata(gcf); guidata(gcf, gui);

end