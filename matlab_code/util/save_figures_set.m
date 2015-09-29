%% Copyright 2014 MERCIER David
function save_figures_set
%% Function to save the main window with the 2 plots
gui = guidata(gcf);

try
    cd(gui.data_xls.pathname_data);
    
    str_title_pict = strcat(datestr(datenum(clock), 'yyyy.mm.dd_HH_MM'), ...
        '_Weibull_fit.png');
    
    saveas(gcf, str_title_pict);
    
    %% Script to save the principles variables obtained for the Weibull distribution
    
    str_title_var = strcat(datestr(datenum(clock), 'yyyy.mm.dd_HH_MM'), ...
        '_Weibull_data.txt');
        
    data2save(:,1) = gui.results.binCtrs;
    data2save(:,2) = gui.results.data_to_plot;
    save(str_title_var, 'data2save', '-ascii');
    cd(gui.config.POPINroot);
    commandwindow;
    display('Results and screenshot saved in data directory !');
catch
    commandwindow;
    display('No result to save !');
    
end

guidata(gcf, gui);

end