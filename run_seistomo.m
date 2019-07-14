clc, clear all, close all
% Rekomendasi : Atur preferences agar bisa fold section
% Shortcut fold all : Ctrl + =
% Shortcut unfold all : Ctrl + Shift + =

%% Pilihan
tic
set(0,'DefaultFigureWindowStyle','normal')
Pilih.SaveGambar = 0;   % 1=saveas gambar ; 0=tidak saveas gambar
Pilih.Tempat = 'D:\running TA\'; %Lokasi penyimpanan gambar
Pilih.IF = 1;   % 1=Inversi ; 2=Forward
Pilih.display_log = 0;
Pilih.display_gambar = 1; % 0=Tidak ; 1=per-rec ; 2=per-sel
Pilih.display_logIter = 1; 

Pilih.alarm = 'D:\Script\01. Boyfriend.mp3';

if Pilih.display_log==1 && Pilih.SaveGambar==1 
    diary on
end

Indeks.fig = 0;
%% True Model, m0, dan Inv
Model.truelength = 20; %Dimensi Model (dalam m)
Model.trueint = 2; %Interval src dan rec (dalam m)
Model.sz = [51 51]; %Dimensi Model (dalam px)
Model.h = Model.truelength/min(Model.sz);

Model = model_3LapHor(Model);
Model.konv = Model.trueint/Model.truelength*max(Model.sz);

N.j = numel(Model.V); %Jumlah kolom pada kernel
Model.batas_ind_b = 200; %Batas perlakuan khusus ketika stuck; nilainya coba2, tergantung model.

Inv.min_vel = 500;
Inv.max_vel = 5000;

Inv.E = 10^-2; %Erms toleransi (Selisih data) (dalam persen)
Inv.iter = 25; %Iterasi maksimum
Inv.konv = 1*10^-3; %Konvergensi model (Sementara belum dipake; Kalo model udah mendekati bener dicoba parameter ini)
Inv.smoothing = 3; %Untuk velsmooth dm; dicoba2 aja nilainya
Inv.eps = 5*10^-2; %Faktor damping
Pilih.TipeInversi = 2; % 1=pinv ; 2=lsqr

[Model,Eq] = ModelAwal(Model, 5000, 5000,N); 

if Pilih.IF == 1 
    if Pilih.TipeInversi==1
        Model.MetodeInversi = 'pinv';
    elseif Pilih.IF == 1 && Pilih.TipeInversi==2
        Model.MetodeInversi = 'lsqr';
    end
    
    Model.NamaSave = [Model.NamaSave '_' Model.MetodeInversi '_'];
end

Eq.m0 = reshape(1./Model.V0,N.j,1);
Temp.V = reshape(Model.V,N.j,1);

Eq_2D.m0 = reshape(Eq.m0,Model.sz);

SaveVar.format = [Pilih.Tempat Model.NamaSave];
%% Source dan Receiver
[SR] = SR_XHole_L (Model);

Indeks.fig = Indeks.fig + 1;
if Pilih.IF==2 && Pilih.display_gambar~=0
    figure (Indeks.fig)
    set(gcf,'Units','Normalized','OuterPosition',[0.05 0.2 0.55 0.78])

    plot_Model(Model), hold on
    plot_SR(SR, 1.5, 1)
    hold off
    pause(0.1)
end

N.src = length(SR.src_x);
N.rec = length(SR.rec_x);
N.i = N.src*N.rec; %Jumlah baris atau jumlah data

if Pilih.IF~=1 && Pilih.SaveGambar == 1
    saveas(gca,[Pilih.Tempat Model.NamaSave '_MODEL.jpg'])
end

%% Looping
Eq.m_asli = reshape(1./Model.V,[N.j,1]);
Eq.d_obs = zeros(N.i,1);
Eq.G = zeros(N.i,N.j);

if Pilih.IF == 2 %Forward
    Pilih.I = 0;
            
    if Pilih.display_log==1 && Pilih.SaveGambar==1 
        diary ([Pilih.Tempat Model.NamaSave '_log.txt'])
    end
    
    [Eq,Temp,Ray]=DefineAllRaypath(Model, Eq, SR,Indeks, Pilih, N);
    
    if Pilih.SaveGambar==1
        a = reshape(Eq.d_forward,N.i,1);
        a = [Eq.d_obs*1000 a*1000 reshape(Eq.d_selisih,N.i,1)];
        save([SaveVar.format '_Forw.mat'],'a')
        save([SaveVar.format '_Forw.txt'],'a','-ascii')
    end
    
    figure(1), 
    plot_Model(Model), hold on
    plot_SR(SR, 1.5, 0)
    for a = 1:N.i
        plot(Ray.KoordRay{a}(:,1),Ray.KoordRay{a}(:,2),'-k','Linewidth',1.5)
    end
    saveas(gca,[Pilih.Tempat Model.NamaSave '_MODEL+Ray.jpg'])
    
    WaktuTotal = toc;
    
    [y, Fs] = audioread(Pilih.alarm);
    sound(y, Fs);
end

if Pilih.IF == 1 %Forward ; Inversi dan Perturbasi
    Temp.E = 1; 
    Temp.iter = 0;
    Temp.konv = Inf;
    SaveVar.konv = Temp.konv;
    
    Pilih.I = 1; %Mendapatkan d_obs
    [Eq,~,~]=DefineAllRaypath(Model, Eq, SR,Indeks, Pilih, N); %Getting d_obs
    
    Pilih.I = 2; %Mendapatkan d_kal dan G
    Eq.d_kal = zeros(N.i,1);
    
    if Pilih.display_gambar == 1 %Setting Figure Position and Size
        figure(1)
        set(gcf,'Units','Normalized','OuterPosition',[0.012 0.02 0.928 0.96])
    end
    
    while Temp.E>Inv.E && Temp.iter<Inv.iter && Temp.konv>Inv.konv
        tic
        Temp.iter = Temp.iter + 1;
        if Pilih.display_logIter == 1
            disp '---------------------------------------------'
            disp (['Iterasi ke-' num2str(Temp.iter)])
        end
        [Eq,~,Ray]=DefineAllRaypath(Model, Eq, SR,Indeks, Pilih, N);
        Indeks.TdkDilalui = find((sum(Eq.G))==0); %Yang tidak dilalui ray --> m tidak diperbarui --> ekstra-/intra- polasi dgn inpaintn
        Eq.delta_d = Eq.d_obs - Eq.d_kal ;
        Temp.E = sqrt(mean((Eq.delta_d).^2))*100; %Dalam persen ms
        Eq_2D.d_obs = reshape(Eq.d_obs,N.src,N.rec);
        Eq_2D.d_kal = reshape(Eq.d_kal,N.src,N.rec);
        
        SaveVar.E(Temp.iter)=Temp.E;
        if Temp.iter>1
             Temp.konv = abs(SaveVar.E(Temp.iter) - SaveVar.E(Temp.iter-1));
             SaveVar.konv(Temp.iter) = Temp.konv ;
        end
        
        if Pilih.display_gambar == 1 %Plot ray dan d_obs&d_kal
            Temp.V0 = reshape(Model.V0,N.j,1);
            Temp.caxis = [min([Temp.V;Temp.V0]) max([Temp.V;Temp.V0])];
            
            subplot('Position',[0.05,0.4,0.25,0.5])
            imagesc(Model.V), title(Model.nama)
            axis image; colormap(gca,parula)
            colorbar, caxis(Temp.caxis)
            set(get(colorbar,'Title'),'String','Velocity (m/s)')
            
            subplot('Position',[0.35,0.4,0.25,0.5])
            imagesc(Model.V0), title(['Model Inversi ' Model.MetodeInversi ' Iterasi ke-' num2str(Temp.iter)])
            axis image; colormap(gca,parula),
            colorbar, caxis(Temp.caxis)
            set(get(colorbar,'Title'),'String','Velocity (m/s)')
            
            subplot('Position',[0.65,0.4,0.25,0.5])
            imagesc(Model.V0), title(['Iterasi ke-' num2str(Temp.iter)])
            axis image; colorbar, caxis(Temp.caxis)
            set(get(colorbar,'Title'),'String','Velocity (m/s)')
            hold on, plot_SR(SR, 1.5, 0)
            
            Temp.src_ke = 0;
            Temp.warna = 1;
            while Temp.src_ke < N.src %Plot ray 
                Temp.src_ke = Temp.src_ke + 1;
                Indeks.fig = Indeks.fig + 1;
                Temp.rec_ke = 0;
                while Temp.rec_ke < N.rec 
                    Temp.rec_ke = Temp.rec_ke + 1;
                    Temp.KoordRay = Ray.KoordRay{Temp.src_ke,Temp.rec_ke};
                    plot(Temp.KoordRay(:,1),Temp.KoordRay(:,2),'k', 'LineWidth', 1.5)
                end
            end
            
            subplot('Position',[0.35,0.15,0.3,0.15])
            plot(Eq.d_obs,'-ob','MarkerFaceColor','b','MarkerSize',3), hold on
            plot(Eq.d_kal,'-ok','MarkerFaceColor','k','MarkerSize',3)
            axis tight
            xlabel('Data ke-'),ylabel('Time (s)'), title(['Iterasi ke-' num2str(Temp.iter) ' [Erms = ' num2str(Temp.E) '%]'])
            legend({'d obs','d kal'},'Location','northeastoutside');
            suptitle (['[' Model.MetodeInversi '] Iterasi ke-' num2str(Temp.iter)  ' [konv = ' num2str(Temp.konv) ']'])
                        
            pause(0.01) %Biar gambar ke display dulu, baru iterasi lagi
            
            if Pilih.SaveGambar == 1
                Temp.savenama = [Pilih.Tempat Model.NamaSave '_iter-' num2str(Temp.iter) '.jpg'];
                saveas(gca,Temp.savenama)
            end
        end
        if Pilih.display_logIter == 1
            disp (['E_rms : ' num2str(Temp.E) '%'])
        end
        
        if Pilih.TipeInversi == 1 %Menghitung Eq.delta_m dengan metode inversi pinv atau lsqr
            tic
            Eq.A = Eq.G'*Eq.G;
            Eq.A =  Eq.A + (Inv.eps^2*eye(size(Eq.A)));
            Eq.b = Eq.G'*Eq.delta_d;
            Eq.delta_m = pinv( Eq.A) * Eq.b; %Gimana cara tambahin faktor damping ?
            Temp.WaktuInversi = toc;
        elseif Pilih.TipeInversi == 2
            tic
            Eq.A = (Eq.G'*Eq.G);
            Eq.A = Eq.A + (Inv.eps^2*eye(size(Eq.A)));
            Eq.b = Eq.G'*Eq.delta_d;
            Eq.delta_m = lsqr(Eq.A, Eq.b);
            Temp.WaktuInversi = toc;
        end
        SaveVar.WaktuInversi(Temp.iter) = Temp.WaktuInversi;
        Eq_2D.delta_m = reshape(Eq.delta_m,Model.sz);
        Eq_2D.delta_m = 1./velsmooth(1./Eq_2D.delta_m, Model.h, Model.h, Model.h*Inv.smoothing);
        Eq_2D.m_baru = Eq_2D.m0 + Eq_2D.delta_m; 
        
        Eq_2D.m_baru(1./Eq_2D.m_baru>Inv.max_vel)=nan;
        Eq_2D.m_baru(1./Eq_2D.m_baru<Inv.min_vel)=nan;
        Eq_2D.m_baru = inpaintn(Eq_2D.m_baru);
        Eq_2D.m_baru(1./Eq_2D.m_baru>Inv.max_vel)=1./Inv.max_vel;
        Eq_2D.m_baru(1./Eq_2D.m_baru<Inv.min_vel)=1./Inv.min_vel;
        Eq_2D.m_baru = 1./velsmooth(1./Eq_2D.m_baru, Model.h, Model.h, 0.5);
        
        Eq_2D.m0 = Eq_2D.m_baru;
        Eq.m0 = reshape(Eq_2D.m0,N.j,1);
        Model.V0 = 1./Eq_2D.m_baru;
        
        Temp.waktu = toc;
        SaveVar.waktu(Temp.iter) = Temp.waktu;
    end
    
    SaveVar.V = Model.V0;
    if Pilih.SaveGambar==1
        SVM(SaveVar)
    end
    
    WaktuTotal = toc;
    
    [y, Fs] = audioread(Pilih.alarm);
    sound(y, Fs);
end

