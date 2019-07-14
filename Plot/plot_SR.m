% Plot source dan receiver

function plot_SR(SR, tebal, legend_on_off)
plot(SR.src_x,SR.src_z,'*r','LineWidth',tebal)
plot(SR.rec_x,SR.rec_z,'vr','LineWidth',tebal)

if legend_on_off == 1
    legend('Source', 'Receiver')
end