********claim data set*********;
proc princomp data=class.claim out=sherry.claimprin; 
   var age children child_driv YOJ income house_val distance 
       vehicle_val clm_freq mvr_pts;
run;

proc gplot data=sherry.claimprin;
   * plot prin1*prin2=claim_ind;
   plot prin1*prin2=1;
run;

*******slides example3***************;
data sherry.pca;
   input x1 x2;
   cards;
   2.5 2.4
   0.5 0.7
   2.2 2.9
   1.9 2.2
   3.1 3.0
   2.3 2.7
   2 1.6
   1 1.1
   1.5 1.6
   1.1 0.9
   ;
run;

proc print; run;

proc princomp data=sherry.pca out=sherry.pcaprin; run;

proc princomp data=sherry.pca covariance out=sherry.pcaprint; run;

Proc print data=sherry.pcaprint; run;


proc gplot data=sherry.pcaprint; 
   symbol v=dot height=0.5cm;
   plot x2*x1;
   plot prin2*prin1 /vaxis=-2 to 2;
run;

*data re-construction with the first PC only;
data sherry.pcaprint2;
   set sherry.pcaprint;
   x1_back = 0.677873* prin1;
   x2_back = 0.735179* prin1;
run;
proc gplot data=sherry.pcaprint2;
   symbol v=dot height=0.5cm;
   plot x2*x1;
   plot x2_back*x1_back;
run;


   