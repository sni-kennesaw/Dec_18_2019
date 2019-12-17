********PCA on the claim data set*********;
proc princomp data=class.claim out=sherry.claimprin; 
   var age children child_driv clm_freq YOJ income house_val distance 
       vehicle_val clm_freq mvr_pts vehicle_age;
run;

proc gplot data=class.claimprin;
   plot prin1*prin2=claim_ind;
   plot prin1*prin2=1;
run;

*********VARCLUS on the claim data set**********;
proc varclus data=class.claim maxclusters=3 outstat=sherry.claimvarclus;
   var age children child_driv YOJ income house_val distance 
       vehicle_val clm_freq mvr_pts vehicle_age;
run;
