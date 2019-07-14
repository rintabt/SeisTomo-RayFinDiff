% Model Kars

function [model] = model_kars(model)
model.nama = 'Kars';
model.NamaSave = 'Kars';

model.image='Kars-02-(50px).bmp'; %Load from image
model.V = (imread(model.image));
model.V = double(model.V(:,:,1));
model.V(model.V==137)=500; %Tanah
model.V(model.V==255)=500; %Tanah
model.V(model.V==254)=1500; %Air
model.V(model.V==117)=5000; %Batugamping
model.V(:,end-1:end)=[];
model.V(end,:)=[];
model.V(13:16,:) = 5000;

model.V = velsmooth(model.V,model.h,model.h, 1.1);

model.V(1:15,:) = 500;
% for i = 16:21
%     model.V(model.V==model.V(i,1))=model.V(21,1);
% end

model.sz = size(model.V);

v = unique(model.V);
ms = ' m/s)';
ms = repmat(ms,length(v),1);
kurung = repmat('(',length(v),1);
NilaiV = num2str(v);
lito = char({'Tanah ','Air ','Batugamping '}');
% model.keterangan = [lito kurung NilaiV ms];