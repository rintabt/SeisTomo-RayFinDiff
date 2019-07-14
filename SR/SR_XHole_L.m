% Posisi source dan receiver (Cross-Hole)

function [SR] = SR_XHole_L (model) %source di Left (kiri)
SR.src_z=round([1 model.konv:model.konv:length(model.V)]');
% SR.src_z = 1:15;
SR.src_x=(ones(size(SR.src_z)));

SR.rec_z=SR.src_z;
SR.rec_x=(length(model.V)*ones(size(SR.rec_z)));



% src.z = src.z(1:5);
% src.x = src.x(1:5);
% rec.z = rec.z(1:5);
% rec.x = rec.x(1:5);