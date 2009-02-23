`baseIt_RM` <-
function(nod,todeath,epi,flu_year,ny,tb,te,pe,ni=5,train=5,per){

 library(FinTS)
 library(forecast)

 print("iterative procudure with cyclical regression model")

 n<-length(nod)
 # store the next flu-year forecast
 d<-vector(,n)
 # store the next flu-year upper limit forecats
 ul<-vector(,n)
 ulx<-vector(,n)
 # indicate the periods of weeks with excess deaths attributable to influenza epidemics
 da<-vector(,n)
 # baseline
 beta0<-vector(,n)
 beta0x<-vector(,n)
 beta_up<-vector(,n)
 
 TCA<-vector(,ny)
 rd<-vector(,ny)

 fy<-1
 fmw<-todeath[1]

 da<-(todeath>tb | todeath<te)*pe + (1-pe)*epi


 nod0<-nod
 nod0[da==1]<-NA
 
 # Fiting a multiple regression model to the first N_AR flu-years 
 m<-nod0[flu_year<=ni]

 t_1<-seq(1,n)-(n/2)
 t_2<-t_1^2
 cos0<-cos(2*t_1*3.14159265/per)
 sin0<-sin(2*t_1*3.14159265/per)

 t_11<-t_1[flu_year<=ni]
 t_21<-t_2[flu_year<=ni]
 sin01<-sin0[flu_year<=ni]
 cos01<-cos0[flu_year<=ni]

 ob<- lm(m~ t_11+t_21+sin01+cos01, na.action=na.exclude)
 
 lista<-data.frame(cbind(t_11,t_21,sin01,cos01))
 
 pred.ob <- predict(ob,lista, se.fit=TRUE, interval="prediction")
 
 beta0[flu_year<=ni]<-pred.ob$fit[,1]
 ul[flu_year<=ni]<-pred.ob$fit[,3]
 
 w<-nod[flu_year<=ni]>ul[flu_year<=ni]
 
 da[flu_year<=ni]<-(w)*(todeath[flu_year<=ni]>tb | 
 todeath[flu_year<=ni]<te)*pe + (1-pe)*epi[flu_year<=ni]*(w)
 
 Z<-da[flu_year<=ni]
 n1<-length(nod[flu_year<=ni])
 j<-1
 while (j<=n1)
 {
  if (Z[j]+Z[j+1]==2 & j<n1)
  {
   while (Z[j]+Z[j+1]!=0 & j<n1)
   {da[flu_year<=ni][j]<-1
    da[flu_year<=ni][j+1]<-1
    j<-j+1}
   }
   else
   {da[flu_year<=ni][j]<-0
    j<-j+1}     
   }

  d[flu_year<=ni]<-beta0[flu_year<=ni]*da[flu_year<=ni]+nod[flu_year<=ni]*(1-da[flu_year<=ni])
  beta_up[flu_year<=ni]<-ul[flu_year<=ni]
 

# Continuation: put some text here also, something like fiting a multiple regression model to the following flu-years 

   
 for (i in ni:(ny-1))
 {
  m<-d[flu_year>=i-train+1 & flu_year<=i]
  t10<-t_1[flu_year>=i-train+1 & flu_year<=i]
  t20<-t_2[flu_year>=i-train+1 & flu_year<=i]
  cos02<-cos0[flu_year>=i-train+1 & flu_year<=i]
  sin02<-sin0[flu_year>=i-train+1 & flu_year<=i]
  
  ob<- lm(m ~ t10+t20+sin02+cos02,na.action=na.exclude)
  
 
  lista<-data.frame(cbind(t10=t_1[flu_year==i+1],t20=t_2[flu_year==i+1],
                          cos02=cos0[flu_year==i+1],sin02=sin0[flu_year==i+1]))
 
  pred.ob <- predict(ob,lista, se.fit=TRUE,interval="prediction")
 
  beta0[flu_year==i+1]<-pred.ob$fit[,1]
  ul[flu_year==i+1]<-pred.ob$fit[,3]
 
  
  w<-nod[flu_year==i+1]>ul[flu_year==i+1]
  da[flu_year==i+1]<-(w)*(todeath[flu_year==i+1]>tb| todeath[flu_year==i+1]<te)*pe + (1-pe)*epi[flu_year==i+1]*(w)
 
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

  beta_up[flu_year==i+1]<-ul[flu_year==i+1]
  d[flu_year==i+1]<-beta0[flu_year==i+1]*da[flu_year==i+1]+nod[flu_year==i+1]*(1-da[flu_year==i+1])
 
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

baseIt_RM<-cbind(beta0,beta_up,da)

}

