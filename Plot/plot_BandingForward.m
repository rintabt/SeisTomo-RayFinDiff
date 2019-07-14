function plot_BandingForward (Model,Eq, Temp, N)

plot(1:N.rec,Eq.d_matriks(Temp.src_ke,:),'-*')
hold on
plot(1:N.rec,Eq.d_forward(Temp.src_ke,:),'-*')

ylabel('Time (s)'), xlabel('Receiver ke-')
title(['Model ' Model.nama ' : Perbandingan Hasil Forward [source ke : ' num2str(Temp.src_ke) ']'])
legend('Crewes','d = G.m')