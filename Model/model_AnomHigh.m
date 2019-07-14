function Model = model_AnomHigh (Model)

Model.nama = 'Anomali High';
Model.NamaSave = 'AnomHigh';
v = [500 1000];
ms = ' m/s';
Model.keterangan = [num2str(v') repmat(ms,2,1)];
Model.V = repmat(min(v),Model.sz);
PosAnomMin = round(Model.sz/5*2);
PosAnomMax = round(Model.sz/5*3);
Model.V(PosAnomMin(1):PosAnomMax(1),PosAnomMin(2):PosAnomMax(2)) = max(v);
