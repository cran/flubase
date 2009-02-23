`baseSA` <-
function(nod,todeath,epi,flu_year,ny,tb,te,pe,per){

 library(FinTS)
 library(forecast)
 
 print("non iterative procudure with seasonal ARIMA model")
 
 n<-length(nod)
 # indicate the periods of weeks with excess deaths attributable to
 # influenza epidemics
 da<-vector(,n)
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


 ob<- lm(nod0~ t_1+t_2+t_3+t_4+t_5+sin0+cos0,
 na.action=na.exclude)

 lista<-data.frame(nod)

 pred.ob <- predict(ob,lista, se.fit=TRUE, interval="prediction")
 d<-pred.ob$fit[,1]*epi+nod*(1-epi)
 d<-ts(d,start=c(fy,fmw), frequency=per)
 fit<-auto.arima(d)
 print("Seasonal ARIMA model")
 print(fit)
 ampl_int<-qnorm(0.95, mean=0, sd=1, lower.tail = TRUE, log.p = FALSE)*sd(fit$residuals)
 beta0<-(fit$x-fit$residuals)
 beta_up<-beta0+ampl_int

 # identify periods (consective months or weeks) with excess deaths attributable
 # to influenza periods with excess deaths (number of deaths above upper 95% CI)
 # that belong to the epidemic periods

 w<-nod>beta_up
 da<-(w)*(todeath>tb | todeath<te)*(pe) + (1-pe)*epi*(w)
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

 resd<-(nod-beta0)

 for (i in 1:n){
  TCA[i]<-sum(da[flu_year==i])
  rd[i]<-sum((resd[flu_year==i]*(1-da[flu_year==i]))^2)
  }
 
 mrdf<-sum(rd)/(n-sum(TCA))
 for (i in 1:n){if (da[i]==1){resd[i]<-NA}}
 print("Residual analysis")
 print(shapiro.test(resd))
 print(ks.test(resd,"pnorm"))
 print(AutocorTest(resd,log(length(resd))))
 cat("MRSS=",mrdf,"\n")

baseSA<-cbind(beta0,beta_up,da)

}

