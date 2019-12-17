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

*check the loading matrix is the matrix P satisfying Z_x = T*P';
*check the model weight matrix is the matrix W that T = X*W;
proc iml;
   T={1.5236091496	1.8126676893	0	-1.445009951	-1.891266888,
    0.9849515584	-1.043664623	0	1.1253113807	-1.066598316,
    0.2940074042	-0.238208811	0	-0.272688171	0.2168895775};
   *T is the score matrix tranposed;
   
   P={-0.557166 0.323985 -0.349178,
      0.013946 0.945602 0.161153,
      0.582205 	-0.013390 -0.821098,
      0.591953 	-0.026309 0.421784};
   *p is the loading matrix transposed;
      
   Zx=P*T;
   print Zx;
   
   *check the model weight matrix is the matrix W that T = X*W;
    Wt= {-0.523461 	0.204832 	0.581318 	0.620053,
        0.338175 	0.940734 	0.018790 	-0.042890,
        -0.349178 	0.161153 	-0.821098 	0.421784};
   
    W = Wt`;
    
    B=Zx` * W;
    print B T;
run;

proc means data=sherry.wine mean var std;
   var x_price x_sugar x_alcohol x_acidity;
run; 

data wine;
   set sherry.wine;
   z_price = (x_price - 10)/4.7434165;
   z_sugar = (x_sugar - 5)/2;
   z_alcohol = (x_alcohol - 12)/1.5811388;
   z_acidity =  (x_acidity -5)/2;
run;


*check X loadings and X weights are Moore-Penrose pseudo-inverse;
*conclusion: no, need furthe check;
proc iml;  
   P={-0.557166 0.323985 -0.349178,
      0.013946 0.945602 0.161153,
      0.582205 	-0.013390 -0.821098,
      0.591953 	-0.026309 0.421784};
          
   Wt= {-0.523461 	0.204832 	0.581318 	0.620053,
        0.338175 	0.940734 	0.018790 	-0.042890,
        -0.349178 	0.161153 	-0.821098 	0.421784};
   
   W = Wt`;
   
   A = P`*W*P`;
   Ad = A - P`;
   
       
   B = W*P`*W;
   Bd = B - W;
   print Ad Bd;
   
   check1=W*P`*P*W`;
   check2=P*W`*W*P`;
   check3=W*P`;
   check4=P*W`;
   print check1 check2;
   print check3 check4;
run;  


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
   
   
   
   
   

