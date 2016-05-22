gui = guidata(gcf);

ii_sheet = 5;
xLabel = 'Displacement (nm)';

% 1st criterion
figure;
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_dh_cleaned/max(gui.data(ii_sheet).data_dh_cleaned));
xlim([0 100]);
ylim([-2 2]);
xlabel(xLabel);
ylabel('diff(h)/max(diff(h))');

% 2nd criterion
figure;
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_ddh_cleaned/max(gui.data(ii_sheet).data_ddh_cleaned));
xlim([0 100]);
ylim([-2 2]);
xlabel(xLabel);
ylabel('diff(h,2)/max(diff(h,2))');

% 3rd criterion
figure;
plot(gui.data(ii_sheet).data_h_cleaned, ...
    gui.data(ii_sheet).data_dddh_cleaned/max(gui.data(ii_sheet).data_dddh_cleaned));
xlim([0 100]);
ylim([-2 2]);
xlabel(xLabel);
ylabel('diff(h,3)/max(diff(h,3))');

% 4th criterion
figure;
plot(gui.data(ii_sheet).data_h_cleaned, ...
    (gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))/ ...
    max(gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:)));
xlim([0 100]);
ylim([-2 2]);
xlabel(xLabel);
ylabel('(dF/dh)/max(dF/dh)');

% 5th criterion
figure;
plot(gui.data(ii_sheet).data_h_cleaned, ...
    (gui.data(ii_sheet).data_ddL_cleaned(:)./gui.data(ii_sheet).data_ddh_cleaned(:))/ ...
    max(gui.data(ii_sheet).data_ddL_cleaned(:)./gui.data(ii_sheet).data_ddh_cleaned(:)));
xlim([0 100]);
ylim([-2 2]);
xlabel(xLabel);
ylabel('(d²F/dh²)/max(d²F/dh²)');

% 6th criterion
figure;
plot(gui.data(ii_sheet).data_h_cleaned, ...
    ((gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))./gui.data(ii_sheet).data_dh_cleaned(:))/ ...
    max((gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))./gui.data(ii_sheet).data_dh_cleaned(:)));
xlim([0 100]);
ylim([-2 2]);
xlabel(xLabel);
ylabel('(dF/dh²)/max(dF/dh²)');