function [Model,Eq] = ModelAwal(Model, min_vel, max_vel,N)
% Pembuatan model awal dilakukan berdasarkan nilai min_vel dan max_vel.
% Kemudian dibuat gradasi dari atas ke bawah --> min_vel-max_vel.
% Ukuran dibuat sama seperti true model.

SatuKolom = linspace(min_vel,max_vel,Model.sz(1))';
Satu = ones(1,Model.sz(2));
Model.V0 = (SatuKolom.*Satu); %Velocity dalam bentuk matriks
Eq.m0 = reshape(1./Model.V0,N.j,1); %Slowness dalam bentuk vektor
