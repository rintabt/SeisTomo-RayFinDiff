% Plot kontur wavefront

function plot_KonturWavefront(Model,time_2D,contour_space)
if Model.sz(1) == Model.sz(2) %Kontur
    xx = 1:Model.sz(1);
    zz = xx;
    contourf(xx,zz,time_2D,contour_space); 
    set(gca,'Ydir','reverse')
else
    disp 'Kontur wavefront tidak dapat dibuat karena'
    disp 'pixel horizontal tidak sama dengan vertikal'
end