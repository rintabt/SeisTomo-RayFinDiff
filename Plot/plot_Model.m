function plot_Model(Model)

% [unq,~,iunq] = unique(Model.V);
% iunq = reshape(iunq,Model.sz);
% ncol = length(unq);

% imagesc(iunq);

% colormap (gca,parula(length(unq)));
% tick_div = (ncol-1)/ncol;
% tick_ntick = 1 + tick_div/2:tick_div:ncol;
% cb = colorbar('Ticks', tick_ntick, 'TickLabels', Model.keterangan);
% set(cb, 'Ydir', 'reverse')

imagesc(Model.V)
cb = colorbar;

set(get(cb,'Title'),'String','Velocity (m/s)')

axis image
title(Model.nama)
xlabel('Depth (px)'), ylabel('Offset (px)'),

