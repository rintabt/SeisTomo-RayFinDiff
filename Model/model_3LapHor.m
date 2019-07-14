% Model 3 Lapis Horizontal
function [model] = model_3LapHor(model)

model.nama = '3-Lapis-Horizontal';
model.NamaSave = '3LapHor';
v = [500 2000 3000];
ms = [' m/s']';
model.keterangan = num2str(v');
model.keterangan = [model.keterangan [ms ms ms]'];
model.V=ones(model.sz)*v(1);
model.V(floor(model.sz(1)/3):floor(model.sz(1)/3*2)-1,:)=v(2);
model.V(floor(model.sz(1)/3*2):end,:)=v(3);
