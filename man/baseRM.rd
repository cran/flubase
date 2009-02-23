\name{baseRM}
\alias{baseRM}

\title{Baseline free of influenza epidemic effects: non iterative procedure with cyclical regression model}

\description{
  This function obtains a mortality (or other indicator) baseline,
  free of influenza epidemic effects, using a non iterative procedure. The baseline
  is estimated from a cyclical regression model fitted to the mortality
  time series without the epidemic periods. The periods with excess deaths associated
  to influenza are those periods, within the epidemic ones, where the observed mortality
  is above the 95 CI of the fitted model.
}

\usage{
baseRM(nod, todeath, epi, flu_year, ny, tb, te, pe, per)
}

\arguments{
  \item{nod}{a vector with the number of deaths (or other indicator) by week or month}
  \item{todeath}{a vector that contains the time index (week or month number)}
  \item{epi}{a vector that indicates if the week or month belongs to the epidemic period, in which case epi=1.
  Otherwise, \code{epi}=0}
  \item{flu_year}{a vector that indicates the flu year. It is an index for the set of
  52 weeks or 12 months, that initiate at week 27 and ends at week 26 of the next civil year, or
  iniate at month 7 and ends at month 6 of the next civil year, depending on the time unit of data.}
  \item{ny}{number of years in study}
  \item{tb}{initial week (tb=48) or month (tb=12) of the fixed epidemic period}
  \item{te}{final week (te=17) or month (te=4) of the fixed epidemic period}
  \item{pe}{\code{pe} = 0 if the user provides the epidemic periods in the epi parameter;
  otherwise if \code{pe} = 1 the function uses a fixed period from week 47 to week 17 or
  from month 12 to month 4.}
  \item{per}{\code{per}=52 if the data is weekly or \code{per}=12 if the data is monthly}
}
\details{

 The objective of this function is to estimate a mortality baseline without the effect of
 influenza epidemics. With this purpose the function fits a cyclical regression model to the
 mortality time series after excluding the epidemic periods, i.e. the values of nod
 when \code{epi}=0. The fitted values from this model is the baseline of mortality without the effect
 of influenza epidemics. The function also returns the the periods with excess mortality
 associated to influenza epidemics, as those where the observed mortality initiate with two
 consecutive observations above the 95 CI of the baseline and ends with two observations bellow
 the 95 CI of the baseline. These periods are returned in da variable.
}

\value{
 The function will return a list

  \item{baseRM$beta0}{containing the mortality (or other indicator) baseline of  without
  the effect of influenza epidemics}

  \item{baseRM$beta_up}{containg the upper 95 CI of the baseline}

  \item{baseRM$da}{a dummy variable indicating the periods with excess
  deaths associated with the ocurred influenza epidemics}
}

\references{
 Nunes B, Natario I, Carvalho L. Time series methods for obtaining excess mortality. Submitted to Statistical Methods in Medical Research (2009).

 Serfling RE Methods for Current Statistical Analysis of Excess Mortality
 Pneumonia-Influenza Deaths Public Heath Reports 1963; 78 6:494 506.

 Simonsen L, Reichert TA, Viboud C, Blackwelder WC, Taylor RJ, Miller M.
 The Impact of Influenza Epidemics on Mortality: Introducing a Severity
 Index Archives of Internal Medicine 2005; 165:265 272.

 Zucs WHP, Buchholz U and Uphoff H. Influenza associated excess
 mortality in germany, 1985 to 2001 Emerging Themes in Epidemiology
 2005; 2(6):1 9.

 Rizzo C, Viboud C, Montomoli E, Simonsen L, Miller MA. Influenza related
 mortality in the Italian elderly: No decline associated with the
 increasing vaccination coverage Vaccine 2006; 24:6468 6475.}

\author{Nunes B, Natario I and Carvalho L.}


\seealso{ \code{\link{baseSA}}, \code{\link{baseIt_RM}}, \code{\link{baseIt_RM}},
           \code{\link{flubase}}
           }


\keyword{methods}
\keyword{models}
\keyword{ts}