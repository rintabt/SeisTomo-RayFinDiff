function Model = model_AnomLow (Model)

Model.nama = 'Anomali Low';
Model.NamaSave = 'AnomLow';
v = [500 1000];
ms = ' m/s';
Model.keterangan = [num2str(v') repmat(ms,2,1)];
Model.V = repmat(max(v),Model.sz);
PosAnomMin = round(Model.sz/5*2);
PosAnomMax = round(Model.sz/5*3);
Model.V(PosAnomMin(1):PosAnomMax(1),PosAnomMin(2):PosAnomMax(2)) = min(v);
