\name{baseIt_SA}
\alias{baseIt_SA}

\title{Baseline free of influenza epidemic effecst: iterative procedure with seasonal ARIMA model}
\description{
  This function estimates the mortality (or other indicator) baseline, free of
 influenza epidemics, using an iterative procedure. The baseline for each flu-year
  (week 27 to week 26 or month 7 to month 6) is estimated from fitting a seasonal ARIMA model to all previous flu-years, without
  the periods with excess deaths associated with influenza epidemics.
  In each iteration the model identifies the periods with excess deaths as those weeks
  (months) above the 95 CI of the baseline.
}
\usage{
baseIt_SA(nod, todeath, epi, flu_year, ny, tb, te, pe, ni = 4, per)
}

\arguments{
  \item{nod}{a vector with the number of deaths (or other indicator) by week or month}
  \item{todeath}{a vector that contains the time index (week or month number)}
  \item{epi}{a vector that indicates if the week or month belongs to the epidemic period, in which case \code{epi}=1. Otherwise, \code{epi}=0}
  \item{flu_year}{a vector that indicates the flu year. It is an index for the set of
  52 weeks or 12 months, that initiate at week 27 and ends at week 26 of the next civil year, or
  iniate at month 7 and ends at month 6 of the next civil year, depending on the time unit of data.}
  \item{ny}{number of years in study}
  \item{tb}{initial week (tb=48) or month (tb=12) of the fixed epidemic period}
  \item{te}{final week (te=17) or month (te=4) of the fixed epidemic period}
  \item{pe}{\code{pe} = 0 if the user provides the epidemic periods in the \code{epi} parameter;
  otherwise if \code{pe} = 1 the function uses a fixed period from week 47 to week 17 or
  from month 12 to month 4.}
  \item{ni}{ \code{ni}=5 represents the number of inicial flu-years to inicialize the
  the iterative procedure}
  \item{per}{ \code{per}=52 if the data is weekly or \code{per}=12 if the data is monthly}
}
\details{

  The objective of this function is to estimate a mortality baseline without the effect of
  influenza epidemics. With this purpose the function starts fitting a cyclical regression model
  to the first \code{ni} flu years of the mortality time series, after excluding the epidemic periods
  i.e. the values of \code{nod} when \code{epi}=0, in an iterative way.
  Then it engages in an iterative procedure where in each iteration the function forecasts
  the baseline of mortality without the effect of influenza epidemics for flu year i+1,
  using a predefined seasonal ARIMA model to the flu years 1 to i. In each iteration the function also
  identifies the periods with excess mortality associated to influenza epidemics in year i+1,
  as those where the observed mortality initiate with two consecutive observations above the
  95 CI of the forecasted baseline and ends with two observations bellow the 95 CI of the forecasted baseline.
  These periods are returned in da variable.
}
\value{
  The function will return a list

  \item{baseIt_SA$beta0}{containing the mortality (or other indicator) baseline without
  the effect of influenza epidemics}

  \item{baseIt_SA$beta_up}{containg the upper 95 CI of the baseline}

  \item{baseIt_SA$da}{a dummy variable indicating the periods with excess
  deaths associated with the ocurred influenza epidemics}
}
\references{
 Nunes B, Natario I, Carvalho L. Time series methods for obtaining excess mortality. Submitted to Statistical Methods in Medical Research (2009).

 K. Choi and S.B. Thacker An evaluation of influenza mortality surveillance
 1962-1979. American Journal of Epidemiology 1981; 113 3: 215 216.}

\author{Nunes B, Natario I and Carvalho L. }


\seealso{ \code{\link{baseIt_RM}}, \code{\link{baseSA}}, \code{\link{baseIt_RM}},
          \code{\link{flubase}}}


\keyword{methods}
\keyword{models}
\keyword{ts}