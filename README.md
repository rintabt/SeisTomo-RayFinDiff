# SeisTomo-RayFinDiff
Modul ini telah terdaftar Hak Kekayaan Intelektual (Modul Tomografi Cross Hole Seismik menggunakan Script MATLAB, No. Pencatatan: 000645199)

Dibuat oleh : DD Warnana, JPGN Rochman, F Syaifuddin, ERB Tari (2019).
Apabila ingin menggunakan script ini, mohon untuk melakukan sitasi.


Script ini merupakan script untuk inversi tomografi seismik berdasarkan forward modelling eikonal finite difference. 

Pembuatan raypath dilakukan berdasarkan Oldenburg (1993) dengan prinsip merunut ulang raypath dari receiver ke source mengikuti arah steepest descent. Arah steepest descent merupakan kebalikan dari gradien.

Beberapa script diambil dari referensi, yaitu :
  - eikonal2D_edited.m  : untuk Forward Modelling = Chad Hogan (2005) (crewes.org)
  - velsmooth.m         : Smoothing = crewes.org
  - inpaintn.m          : Inter-/ekstra-polasi = David Garcia (2017)

Penjelasan mengenai beberapa parameter yang dapat disesuaikan serta kegunaan masing-masing function dapat dilihat di Modul.pdf

