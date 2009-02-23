\name{flubase}
\alias{flubase}

\title{Baseline free of influenza epidemic effects}

\description{
 This function estimates the mortality (or other indicator) baseline free of 
 influenza epidemics for one or more than one time series (age groups, gender, regions, etc)
 using one of four methods made available in the package, implemented respectively in 
 \code{\link{baseRM}}, \code{\link{baseSA}}, \code{\link{baseIt_RM}} and \code{\link{baseIt_SA}}.
}

\usage{
flubase(dat, groups, per, pe = 0, method, indicator = "mortality", g_label)
}

\arguments{
  
  \item{dat}{a data.frame with all the variables needed: \code{dados$group} indicating the group where each time series
  belongs, \code{dados$year} indicating the civil year, \code{dados$todeath} is
  the time unit index that can be week or month, \code{dados$nod} are the number of 
  deaths observed at that time and \code{dados$epi} is an indicator variable of the epidemic period (\code{dados$epi=1} if 
  the week or month belongs to the epidemic period and \code{dados$epi}=0 otherwise).}
  \item{groups}{number of groups considered, e.g. number of age groups, regions, etc.}
  \item{per}{\code{per}=52 for weekly data or \code{per}=12 for monthly data}
  \item{pe}{\code{pe} = 0 if the user provides the epidemic periods in \code{dados$epi} and \code{pe} = 1
  otherwise, in case which the function uses a fixed period from week 48 to week 17 or
  from month 12 to month 4.}
  \item{method}{the method used to estimate the baseline, \code{method}=c("nrm","nsa","irm","isa").
  \code{method=nrm}: non iterative multiple regression, \code{method}=nsa: non iterative seasonal ARIMA, 
  \code{method=irm}: iterative cmultiple regression and \code{method}=isa: iterative seasonal ARIMA}
  \item{indicator}{a text string indicating the name of the indicator. By default \code{indicator}="mortality"}
  \item{g_label}{ a vector string of length the number of groups, containing the labels for the
  groups, e.g. \code{g_label}=c("male","female") or \code{g_label}=c("0-14 yrs","15-44 yrs","45-64 yrs","65+ yrs")}
}

\details{
 In order to use the methods \code{irm} and \code{isa} the time series must initiate in the week 27
 or month 7 and end at week 26 or month 6 of the next year.}  


\value{
  The function will return a list \code{flubase}, with the original data set plus
  
  \item{flubase$beta0}{containing the mortality (or other indicator) baseline of without
  the effect of influenza epidemics}
  
  \item{flubase$beta_up}{containg the upper 95 CI for the baseline}
  
  \item{flubase$da}{a dummy variable indicating the periods with excess
  deaths}
  
  \item{flubase$ex}{the excess deaths}

  This function delivers the following outputs: a text file with the original data set plus four new variables, 
  the baseline (base0), the upper 95 confidence limit (\code{dados$base_up}), the periods whith
  excess deaths (\code{dados$da}) and the excess deaths, estimated for each week or month (\code{dados$ex}); a time series 
  graph for each group (age group, gender, etc) where 
  the blue line represents the observed mortality, the black line the estimated baseline, the red line the upper 
  95 confidence limit of the baseline, the gray rectangles the epidemic periods and the yellow rectangles 
  the periods with excess deaths.
}

\references{ 
 Nunes B, Natario I, Carvalho L. Time series methods for obtaining excess mortality. Submitted to Statistical Methods in Medical Research (2009).
 
 Serfling RE Methods for Current Statistical Analysis of Excess Mortality 
 Pneumonia-Influenza Deaths Public Heath Reports 1963; 78 6:494 506.
 
 K. Choi and S.B. Thacker An evaluation of influenza mortality surveillance
 1962-1979. American Journal of Epidemiology 1981; 113 3: 215 216.
 
 Lui K-J and Kendal A.P. Impact of influenza epidemics on mortality in
 the united states from October 1972 to May 1985. American Journal of
 Public Health 1987; 77(6):712 716.
 
 L. Simonsen, M.J. Clarke, D. Williamson, D.F. Stroup, N.H. Arden and L.B. Schonberger 
 The impact of influenza vaccination on seasonal mortality in the US elderly population. 
 American Journal of Public Health 1997; 87(12):1994 1950. 
 }
 
\author{ Nunes B, Natario I and Carvalho L.}

\seealso{ \code{\link{baseIt_RM}}, \code{\link{baseSA}}, \code{\link{baseIt_SA}},
          \code{\link{baseRM}}}

\keyword{methods}
\keyword{models}
\keyword{ts}