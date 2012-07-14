\name{home}
\alias{home}
\title{Classify Home vs Not Home}
\usage{
  home(mydf, homeradius = 0.1)
}
\arguments{
  \item{mydf}{a dataframe of mobility data for one day.}

  \item{homeradius}{the radius in KM to be considered home
  (take into account GPS noise).}
}
\value{
  a vector of booleans
}
\description{
  This function attempts to classify a day of data between
  home and non home points.
}

