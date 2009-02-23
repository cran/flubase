\name{baseIt_RM}
\alias{baseIt_RM}

\title{Baseline free of influenza epidemic effects: iterative procedure with cyclical regression model}
\description{
  This function estimates the mortality (or other indicator) baseline, free of
 influenza epidemics, using an iterative procedure. The baseline for each flu-year
  (week 27 to week 26 or month 7 to month 6) is estimated from fitting a cyclical regression model to a training set of previous flu-years,
  without the periods with excess deaths associated with influenza epidemics.
  In each iteration the model identifies the periods with excess deaths as those weeks (months)
  above the 95 CI of the baseline.
}

\usage{
baseIt_RM(nod, todeath, epi, flu_year, ny, tb, te, pe, ni = 5, train = 5, per)
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
  \item{ni}{ represents the number of inicial flu-years to inicialize the
  the iterative procedure, by default is equal to 4}
  \item{train}{is the set of flu years used to predict the baseline
  for the flu year i+1, by default is equal to 5}
  \item{per}{ \code{per}=52 if the data is weekly or \code{per}=12 if the data is monthly}
}
\details{
  The objective of this function is to estimate a mortality baseline without the effect of
  influenza epidemics. With this purpose the function starts fitting a cyclical regression model
  to the first \code{ni} flu years of mortality time series after excluding the epidemic periods,
  i.e. the values of \code{nod} when \code{epi}=0. Then it engages in an iterative procedure
  where in each iteration the function forecasts the baseline of mortality without the effect
  of influenza epidemics for flu year i+1 using the model fitted to the flu years i-train+1 to i.
  In each iteration the function also identifies the periods with excess mortality
  associated to influenza epidemics in year i+1, as those where the observed mortality initiate
  with two consecutive observations above the 95 CI of the forecasted baseline and ends with
  two observations bellow the 95 CI of the forecasted baseline.
  These periods are returned in da variable.
}
\value{
  The function will return a list

  \item{baseIt_RM$beta0}{containing the mortality (or other indicator) baseline without
  the effect of influenza epidemics}

  \item{baseIt_RM$beta_up}{containg the upper 95 CI of the baseline}

  \item{baseIt_RM$da}{a dummy variable indicating the periods with excess
  deaths associated with the ocurred influenza epidemics}
}
\references{
 Nunes B, Natario I, Carvalho L. Time series methods for obtaining excess mortality. Submitted to Statistical Methods in Medical Research (2009).

 Serfling RE Methods for Current Statistical Analysis of Excess Mortality
 Pneumonia-Influenza Deaths Public Heath Reports 1963; 78 6:494 506.

 Lui K-J and Kendal A.P. Impact of influenza epidemics on mortality in
 the united states from october 1972 to may 1985. American Journal of
 Public Health 1987; 77(6):712 716.

 L. Simonsen, M.J. Clarke, D- Williamson, D.F. Stroup, N.H. Arden and L.B. Schonberger
 The impact of influenza vaccination on seasonal mortality in the US elderly population.
 American Journal of Public Health 1997; 87(12):1994 1950.

 }
\author{ Nunes B, Natario I and Carvalho L. }

\note{
The \code{ni} must be minor or equal to \code{train}.
}
\seealso{ \code{\link{baseIt_SA}}, \code{\link{baseSA}}, \code{\link{baseIt_RM}},
          \code{\link{flubase}}}


\keyword{methods}
\keyword{models}
\keyword{ts}