*generate the simulation data sets;
data analysisData testData;
     drop i j;
     array x{20} x1-x20;
     do i=1 to 5000;
       /* Continuous predictors */
         do j=1 to 20;
            x{j} = ranuni(1);
         end;
         /* Classification variables */
         c1 = int(1.5+ranuni(1)*7);
         c2 = 1 + mod(i,3);
         c3 = int(ranuni(1)*15);
         yTrue = 2 + 5*x17 - 8*x5 + 7*x9*c2 - 7*x1*x2 + 6*(c1=2) + 5*(c1=5);
         y     = yTrue + 6*rannor(1);
         if ranuni(1) < 2/3 then output analysisData;
                            else output testData;
     end; 
run;

*LAR;
proc glmselect data=analysisData testdata=testData
                  plot=(CoefficientPanel criteria aseplot);
      class c1 c2 c3;
      model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
                   |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2
              / selection=LAR (stop=50 choose=SBC)
;
*stop can be none...;
run;

*LAR with stop=CV;
proc glmselect data=analysisData testdata=testData
                  plot=(CoefficientPanel criteria aseplot);
      class c1 c2 c3;
      model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
                   |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2
              / selection=LAR(stop=CV)
                cvMethod=split(5) cvDetails=all;
run;

*LASSO, result identical to LAR;
proc glmselect data=analysisData testdata=testData
                  plot=(CoefficientPanel criteria aseplot);
      class c1 c2 c3;
      model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
                   |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2
              / selection=LASSO(stop=CV)
                cvMethod=split(5) cvDetails=all;
run;

*adaptive LASSO;
proc glmselect data=analysisData testdata=testData
                  plot=(CoefficientPanel criteria aseplot);
      class c1 c2 c3;
      model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
                   |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2
              / selection=LASSO(adaptive stop=cp);
run;

*average model performance;
proc glmselect data=analysisData testdata=testData
                  plot=(EffectSelectPct ParmDistribution);
      class c1 c2 c3;
      model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
                   |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2
              / selection=LASSO(stop=cp);
      modelAverage tables=(EffectSelectPct(all) ParmEst(all));
run;

*ridge regression;
proc reg data=analysisData
         outest=b ridge=0 to 20 by .5;
   model y =  c1-c3 x1-x20 /vif;
run;
quit;



