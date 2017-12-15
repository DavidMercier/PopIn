%% Copyright 2014 MERCIER David
% Script for plotting pop-in detection criteria

gui = guidata(gcf);

ii_sheet = 5;
fontSizeVal = 14;
%xLabel = 'Displacement (nm)';
xLabel = 'Normalized displacement ($$h$$)';

% F-h
figure(2);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(2) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    gui.data(ii_sheet).data_L_cleaned./max(gui.data(ii_sheet).data_L_cleaned));
ylim([0 1]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized load ($$F$$)', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 1st criterion
figure(3);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(3) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    gui.data(ii_sheet).data_dh_cleaned./max(gui.data(ii_sheet).data_dh_cleaned));
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized $$diff(h)$$', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 2nd criterion
figure(4);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(4) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    gui.data(ii_sheet).data_ddh_cleaned./max(gui.data(ii_sheet).data_ddh_cleaned));
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized $$diff(h,2)$$', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 3rd criterion
figure(5);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(5) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    gui.data(ii_sheet).data_dddh_cleaned./max(gui.data(ii_sheet).data_dddh_cleaned));
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized $$diff(h,3)$$', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 4th criterion (1st derivative)
figure(6);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(6) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    (1./(gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:)))./ ...
    max(1./(gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:))));
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized ($$1/(dF/dh)$$)', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 5th criterion (2nd derivative)
figure(7);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
diffData = gui.data(ii_sheet).data_dL_cleaned(:)./gui.data(ii_sheet).data_dh_cleaned(:);
diffData(length(diffData)+1) = diffData(length(diffData));
data = 1./((diff(diffData)./gui.data(ii_sheet).data_dh_cleaned(:)));
h(7) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    -data./max(data(isfinite(data)))); % Problem with infinite value
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized ($$-1/(d^{2}F/dh^{2})$$)', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 6th criterion (Malzbender)
figure(8);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(8) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    ((gui.data(ii_sheet).data_dL_cleaned(:)./(gui.data(ii_sheet).data_dh_cleaned(:)).*gui.data(ii_sheet).data_dh_cleaned(:)))./ ...
    max((gui.data(ii_sheet).data_dL_cleaned(:)./(gui.data(ii_sheet).data_dh_cleaned(:)).*gui.data(ii_sheet).data_dh_cleaned(:))));
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized  ($$dF/dh^{2}$$)', 'interpreter', 'latex', 'FontSize', fontSizeVal);

% 7th criterion (dF/dh)
figure(9);
set(gca,'Position',[0.20 0.20 0.70 0.70]);
h(9) = plot(gui.data(ii_sheet).data_h_cleaned./(max(gui.data(ii_sheet).data_h_cleaned)), ...
    ((gui.data(ii_sheet).data_dL_cleaned(:)./(gui.data(ii_sheet).data_dh_cleaned(:))))./ ...
    max((gui.data(ii_sheet).data_dL_cleaned(:)./(gui.data(ii_sheet).data_dh_cleaned(:)))));
ylim([-2 2]);
xlabel(xLabel, 'interpreter', 'latex', 'FontSize', fontSizeVal);
ylabel('Normalized ($$dF/dh$$)', 'interpreter', 'latex', 'FontSize', fontSizeVal);


% Settings for all plots
for ii = 2:9
    figure(ii);
    hold on;
    xLine = [12/100 12/100];
    yLine = [-1e10 1e10];
    h2(ii) = plot(xLine, yLine, '--r');
    xlim([0 1]);
    set([h(ii), h2(ii)],'LineWidth',2);
    set(gca, 'FontSize', fontSizeVal);
    grid on;
    figTitle = strcat('plotCriteria_',num2str(ii-1));
    hgexport(gcf, figTitle, hgexport('factorystyle'), 'Format', 'png');
end