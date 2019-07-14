% Plot grid sel

function plot_GridSel(model,warna_hor, warna_ver)
grid_ver = 0:model.sz(1)+1;
grid_hor = 0:model.sz(2)+1;

for i=1:model.sz(2)+1 %Vertikal
    plot([grid_hor(i) grid_hor(i)],[grid_ver(1) grid_ver(end)],warna_ver) 
end

for i=1:model.sz(1)+1 %Horizontal
    plot([grid_hor(1) grid_hor(end)],[grid_ver(i) grid_ver(i)],warna_hor) 
end

