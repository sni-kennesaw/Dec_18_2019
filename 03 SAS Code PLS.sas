*We would like to predict the subjective evaluation of a set of 5 wines;  
*The dependent variables are its likeability, how it goes with meant, or dessert;
*The predictors are the price, the sugar, alcohol, and acidity content of each wine; 

data sherry.wine;
   input y_hedonic y_goesm y_goesd x_price x_sugar x_alcohol x_acidity;
   cards;
   14 7 8 7 7 13 7
   10 7 6 4 3 14 7
   8 5 5 10 5 12 5
   2 4 7 16 7 11 3
   6 2 4 13 3 10 3
   ;
run;


*plot XY scores inside PROC PLS;
proc pls data=sherry.wine method=pls (algorithm=svd) details lv=3 outmodel=plsmodel plot=xyscores;
   model y_hedonic y_goesm y_goesd = x_price x_sugar x_alcohol x_acidity;
   output out=plsout predicted=predY1-predY3 
                     yresidual=resY1-resY3 XSCORE=t yscore=u;
   
                     
run;

*plot coefficients and VIP;
proc pls data=sherry.wine method=pls (algorithm=svd) details lv=3 plot=(parmprofiles vip);
   model y_hedonic y_goesm y_goesd = x_price x_sugar x_alcohol x_acidity;
   output out=plsout predicted=predY1-predY3 
                     yresidual=resY1-resY3 XSCORE=t yscore=u;
   
                     
run;

**give the parameter table (based on the centered and scaled data and also on raw data);
proc pls data=sherry.wine method=pls (algorithm=svd) details lv=3;
   model y_hedonic y_goesm y_goesd = x_price x_sugar x_alcohol x_acidity /solution;
   output out=plsout predicted=predY1-predY3 
                     yresidual=resY1-resY3 XSCORE=t yscore=u;                     
run;

*plot scores with PROC SGSCATTER;
proc sgscatter data=plsout;
  plot (u1-u4)*(t1-t4);
run;

proc gplot data=plsout;
  plot t2*t1;
run;

*check the correlation loading graph;
proc reg data=plsout;
   model t1 = x_sugar;
run;
quit;

proc corr data=plsout; 
   var x_price x_sugar x_alcohol x_acidity t1-t2;
run;

proc corr data=plsout; 
   var y_hedonic y_goesm y_goesd t1-t2;
run;

*check teh Inner Regression Coefficients;
proc reg data=plsout;
   var u1-u3 t1-t3;
   model u1 = t1 /noint;
run;
   model u2 = t2 /noint;
run;
   model u3 = t3 /noint;
run;
quit;

*****ignore below;

*PCR, principal component regression;
proc pls data=sherry.wine method=pcr details;
   model y_hedonic y_goesm y_goesd = x_price x_sugar x_alcohol x_acidity;
   output out=plsout predicted=predY1-predY3 
                     yresidual=resY1-resY3 XSCORE=t yscore=u;
run;


*the original predictors are linearly related;
proc reg data=sherry.wine;
   model y_hedonic = x_price x_sugar x_alcohol x_acidity /vif;
run;
quit;
   
   
   
   
   

