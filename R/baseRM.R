`baseRM` <-
function(nod,todeath,epi,flu_year,ny,tb,te,pe,per){

 library(FinTS)
 library(forecast)
 
 print("non iterative procudure with cyclical regression model") 
  
 n<-length(nod)
 # indicate the periods of weeks with excess deaths attributable to
 # influenza epidemics
 da<-vector(,n)
 Z<-vector(,n)
 # baseline
 beta0<-vector(,n)
 beta_up<-vector(,n)

 TCA<-vector(,ny)
 rd<-vector(,ny)

 fy<-1
 fmw<-todeath[1]

 da<-(todeath>tb | todeath<te)*pe + (1-pe)*epi
 nod0<-nod
 nod0[da==1]<-NA

 # Fiting a multiple regression model to the first N_AR flu-years

 t_1<-seq(1,n)-(n/2)
 t_2<-t_1^2
 t_3<-t_1^3
 t_4<-t_1^4
 t_5<-t_1^5
 cos0<-cos(2*t_1*3.14159265/per)
 sin0<-sin(2*t_1*3.14159265/per)


 ob<-lm(nod0~ t_1+t_2+t_3+sin0+cos0, na.action=na.exclude)

 print("Cyclical regression model")
 print(summary(ob))

 res<-residuals(ob)

 lista<-data.frame(nod)

 pred.ob <- predict(ob,lista,se.fit=TRUE, interval="prediction")
 beta0<-pred.ob$fit[,1]
 beta_up<-pred.ob$fit[,3]


 # identify periods (consective months or weeks) with excess deaths attributable
 # to influenza periods with excess deaths (number of deaths above upper 95% CI)
 # that belong to the epidemic periods


 da<-(nod>beta_up)*(todeath>tb | todeath<te)*pe + (1-pe)*epi*(nod>beta_up)
 Z<-da
 n1<-n
 j<-1
  while (j<=n1)
  {
  if (Z[j]+Z[j+1]==2 & j<n1)
   {
    while (Z[j]+Z[j+1]!=0 & j<n1)
    {da[j]<-1
     da[j+1]<-1
     j<-j+1}
    }
    else
    {da[j]<-0
        j<-j+1}
   }

  for (i in 1:n){
  TCA[i]<-sum(da[flu_year==i])
  rd[i]<-sum((res[flu_year==i]*(1-da[flu_year==i]))^2)
  }
 
 mrdf<-sum(rd)/(n-sum(TCA))
 for (i in 1:n){if (da[i]==1){res[i]<-NA}}
 print("Residual analysis")
 print(shapiro.test(res))
 print(ks.test(res,"pnorm"))
 print(AutocorTest(res,log(length(res))))
 cat("MRSS=",mrdf,"\n")



baseRM<-cbind(beta0,beta_up,da)
}

