% Model 3 Lapis Vertikal

function [model] = model_3LapVer(model)
model.nama = '3-Lapis-Vertikal';
model.NamaSave = '3LapVer';
v = [500 1000 2000];
ms = [' m/s']';
model.keterangan = num2str(v');
model.keterangan = [model.keterangan [ms ms ms]'];
model.V=ones(model.sz)*v(1);
model.V(:,floor(model.sz(2)/3):floor(model.sz(2)/3*2)-1)=v(2);
model.V(:,floor(model.sz(2)/3*2):end)=v(3);
