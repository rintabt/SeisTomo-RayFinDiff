function SVM(Var)
%Save Variable to *.mat
%Hanya untuk Pilih.IF==1
Var.iter = 1:length(Var.E);
zzz = [Var.iter' Var.E' Var.konv' Var.WaktuInversi' Var.waktu'];
save([Var.format '_InvLog.mat'],'zzz')
save([Var.format '_InvLog.txt'],'zzz','-ascii')

v = Var.V;
save([Var.format '_Vel.mat'],'v')