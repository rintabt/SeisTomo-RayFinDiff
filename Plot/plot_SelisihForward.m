function plot_SelisihForward(Model,Eq,Temp,N,error_toleransi)

plot([1 N.rec],[error_toleransi error_toleransi],'--r')
hold on
plot(1:N.rec,Eq.d_selisih(Temp.src_ke,:),'-*')

axis([1 N.rec 0 max([error_toleransi+2 max(Eq.d_selisih)])])
legend('Batas error toleransi')
xlabel('Receiver ke-')
ylabel('Selisih (ms)')
title (['Model ' Model.nama ' : Selisih antar forward [source ke : ' num2str(Temp.src_ke) ']' ])