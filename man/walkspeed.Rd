\name{walkspeed}
\alias{walkspeed}
\title{Calculate walking speed}
\usage{
  walkspeed(mydf, minimum = 6, smooth = TRUE,
    getspeed = TRUE)
}
\arguments{
  \item{mydf}{mobility data object}

  \item{minimum}{minimum span of walking period to be
  included}

  \item{smooth}{should data be smoothed (T/F)}
}
\description{
  Takes a mobility data object and calculates average
  walking speeds
}

