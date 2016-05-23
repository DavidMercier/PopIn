%% Copyright 2014 MERCIER David
% Script for plotting pop-in detection criteria

gui = guidata(gcf);

ii_sheet = 5;
xLabel = 'Displacement (nm)';

% F-h
figure(2);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_L_cleaned);
ylim([0 1]);
ylabel('Load (mN)');

% 1st criterion
figure(3);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_dh_cleaned/max(gui.data(ii_sheet).data_dh_cleaned));
ylim([-2 2]);
ylabel('diff(h)/max(diff(h))');

% 2nd criterion
figure(4);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_ddh_cleaned/max(gui.data(ii_sheet).data_ddh_cleaned));
ylim([-2 2]);
ylabel('diff(h,2)/max(diff(h,2))');

% 3rd criterion
figure(5);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_dddh_cleaned/max(gui.data(ii_sheet).data_dddh_cleaned));
ylim([-2 2]);
ylabel('diff(h,3)/max(diff(h,3))');

% 4th criterion
figure(6);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    (gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))/ ...
    max(gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:)));
ylim([-2 2]);
ylabel('(dF/dh)/max(dF/dh)');

% 5th criterion
figure(7);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    (gui.data(ii_sheet).data_ddL_cleaned(:)./gui.data(ii_sheet).data_ddh_cleaned(:))/ ...
    max(gui.data(ii_sheet).data_ddL_cleaned(:)./gui.data(ii_sheet).data_ddh_cleaned(:)));
ylim([-2 2]);
ylabel('(d²F/dh²)/max(d²F/dh²)');

% 6th criterion
figure(8);
plot(gui.data(ii_sheet).data_h_cleaned, ...
    ((gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))./gui.data(ii_sheet).data_dh_cleaned(:))/ ...
    max((gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))./gui.data(ii_sheet).data_dh_cleaned(:)));
ylim([-2 2]);
ylabel('(dF/dh²)/max(dF/dh²)');

% Settings for all plots
for ii = 2:8
    figure(ii);
    hold on;
    xLine = [12 12];
    yLine = [-1e10 1e10];
    plot(xLine, yLine, '--r');
    xlim([0 100]);
    xlabel(xLabel);
    figTitle = strcat('plotCriteria_',num2str(ii-1));
    hgexport(gcf, figTitle, hgexport('factorystyle'), 'Format', 'png');
end