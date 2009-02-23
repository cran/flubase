`baseIt_SA` <-
function(nod,todeath,epi,flu_year,ny,tb,te,pe,ni=4,per){
 
 library(FinTS)
 library(forecast)
 
 print("iterative procudure with seasonal ARIMA model")
 
 n<-length(nod)
 # store the next flu-year forecast
 d<-vector(,n)
 # store the next flu-year upper limit forecats
 ul<-vector(,n)

 # indicate the periods of weeks with excess deaths attributable to influenza epidemics
 da<-vector(,n)
 # baseline
 beta0<-vector(,n)
 beta_up<-vector(,n)


 
 TCA<-vector(,ny)
 rd<-vector(,ny)
 
 da<-(todeath>tb | todeath<te)*pe + (1-pe)*epi

 fy<-1
 fmw<-todeath[1]

 nod0<-nod
 nod0[da==1]<-NA


 # Fiting a multiple regression model to the first NI flu-years
 

 t_1<-seq(1,n)-(n/2)
 t_2<-t_1^2
 cos0<-cos(2*t_1*3.14159265/per)
 sin0<-sin(2*t_1*3.14159265/per)

 for (i in 1:(ni-1))
 {        
  if (i==1)
   {
    m<-nod0[flu_year==1]
    t_10<-t_1[flu_year==1]
    t_20<-t_2[flu_year==1]
    sin00<-sin0[flu_year==1]
    cos00<-cos0[flu_year==1]
    ob<- lm(m~ t_10+t_20+sin00+cos00,na.action=na.exclude)
    lista<-data.frame(cbind(t_10=t_1[flu_year<=2],t_20=t_2[flu_year<=2],
                        sin00=sin0[flu_year<=2],cos00=cos0[flu_year<=2]))
    pred.ob <- predict(ob,lista, se.fit=TRUE, interval="prediction")
    
    beta0[flu_year<=2]<-pred.ob$fit[,1]
    ul[flu_year<=2]<-pred.ob$fit[,3] 

    w<-nod[flu_year<=2]>ul[flu_year<=2]
      
    da[flu_year<=2]<-(w)*(todeath[flu_year<=2]>tb | todeath[flu_year<=2]<te)*pe+ (1-pe)*epi[flu_year<=2]*(w)
    
    Z<-da[flu_year<=2]
    
    n1<-length(nod[flu_year<=2])
    j<-1
    while (j<=n1)
     {
      if (Z[j]+Z[j+1]==2 & j<n1)
       {
        while (Z[j]+Z[j+1]!=0 & j<n1)
        {da[flu_year<=2][j]<-1
         da[flu_year<=2][j+1]<-1
         j<-j+1}
       }
       else
       {da[flu_year<=2][j]<-0
        j<-j+1}     
       }
   
     d[flu_year<=2]<-beta0[flu_year<=2]*da[flu_year<=2]+nod[flu_year<=2]*(1-da[flu_year<=2])
     beta_up[flu_year<=2]<-ul[flu_year<=2]
   }
   else
   {
    
    m<-nod0[flu_year<=i]
    t_10<-t_1[flu_year<=i]
    t_20<-t_2[flu_year<=i]
    sin00<-sin0[flu_year<=i]
    cos00<-cos0[flu_year<=i]
    
    ob<- lm(m~ t_10+t_20+sin00+cos00,na.action=na.exclude)
    
    t_10<-t_1[flu_year<=i+1]
    t_20<-t_2[flu_year<=i+1]
    sin00<-sin0[flu_year<=i+1]
    cos00<-cos0[flu_year<=i+1]
    
    lista<-data.frame(cbind(t_10,t_20,sin00,cos00))
                      
    pred.ob <- predict(ob,lista, se.fit=TRUE, interval="prediction")

    beta0[flu_year<=i+1]<-pred.ob$fit[,1]
    ul[flu_year<=i+1]<-pred.ob$fit[,3]

    w<-nod[flu_year==i+1]>ul[flu_year==i+1]
    da[flu_year==i+1]<-(w)*(todeath[flu_year==i+1]>tb | todeath[flu_year==i+1]<te)*pe + (1-pe)*epi[flu_year==i+1]*(w)
    Z<-da[flu_year==i+1]
    n1<-length(nod[flu_year==i+1])
    
    j<-1
    while (j<=n1)
     {
      if (Z[j]+Z[j+1]==2 & j<n1)
       {
        while (Z[j]+Z[j+1]!=0 & j<n1)
        {da[flu_year==i+1][j]<-1
         da[flu_year==i+1][j+1]<-1
         j<-j+1}
       }
       else
       {da[flu_year==i+1][j]<-0
        j<-j+1}     
       }
   
     d[flu_year==i+1]<-beta0[flu_year==i+1]*da[flu_year==i+1]+nod[flu_year==i+1]*(1-da[flu_year==i+1])
     beta_up[flu_year==i+1]<-ul[flu_year==i+1]

  } 
 }

 x<-ts(d[flu_year<=ni], frequency=per)

 fim<-(24-ni)

 for (i in 1:(fim))
 {
  nx<-length(nod[flu_year==ni+i])
  fit<-arima(x, order = c(2, 0, 0), seasonal = list(order = c(1, 1, 0), period = per),method = "ML")
  s<-predict(fit, n.ahead = nx)
  beta0[flu_year==ni+i]<-s$pred
  ampl_int<-qnorm(0.95, mean=0, sd=1, lower.tail = TRUE, log.p = FALSE)*s$se
  ul[flu_year==ni+i]<-beta0[flu_year==ni+i]+ampl_int
  w<-(nod[flu_year==ni+i]>ul[flu_year==ni+i])
  da[flu_year==ni+i]<-w*(todeath[flu_year==ni+i]>tb | todeath[flu_year==ni+i]<te)*pe + (1-pe)*epi[flu_year==ni+i]*w
  Z<-da[flu_year==ni+i]
  n1<-length(nod[flu_year==ni+i])
  
  j<-1
  while (j<=n1)
  {
   if (Z[j]+Z[j+1]==2 & j<n1)
    {
     while (Z[j]+Z[j+1]!=0 & j<n1)
      {da[flu_year==ni+i][j]<-1
       da[flu_year==ni+i][j+1]<-1
       j<-j+1}
     } 
     else
     {da[flu_year==ni+i][j]<-0
      j<-j+1}      
  }
    
  d[flu_year==ni+i]<-beta0[flu_year==ni+i]*da[flu_year==ni+i]+nod[flu_year==ni+i]*(1-da[flu_year==ni+i])
  beta_up[flu_year==ni+i]<-ul[flu_year==ni+i]
  x<-ts(d[flu_year<=ni+i], frequency=per)
}

 w<-ts(d, frequency=52)
 fit<-arima(w, order = c(3, 0, 0), 
      seasonal = list(order = c(1, 1, 2), period = per),
      method = "ML")
 print("Final seasonal ARIMA model")
 print(fit)
 beta0<-(w-fit$residuals)
 ampl_int<-qnorm(0.95, mean=0, sd=1, lower.tail = TRUE, log.p = FALSE)*sd(fit$residuals)
 beta_up<-beta0+ampl_int
 
 
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

 baseIt_SA<-cbind(beta0,beta_up,da)

}

