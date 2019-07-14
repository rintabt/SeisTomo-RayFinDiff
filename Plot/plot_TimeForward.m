% Plot Travel Time
function plot_TimeForward(Model, Temp, time_2D)

imagesc(time_2D);
colorbar; 
set(get(colorbar,'Title'),'String','Travel Time (s)')
xlabel('Offset(px)'), ylabel('depth(px)'),
title(['Model ' Model.nama ' : travel time (s) [source : ' num2str(Temp.src_ke) ']'])
