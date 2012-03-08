\name{mobility.smooth}
\alias{mobility.smooth}
\title{Smoothing mobility data}
\usage{
  mobility.smooth(x, strength = 5)
}
\arguments{
  \item{x}{the vector with modes. Will always be treated as
  catagorical (don't use with real numbers).}

  \item{strength}{smoothing parameter. Rougly the number of
  neighbouring days that should be taken into account while
  smoothing.}
}
\value{
  the smoothed vector
}
\description{
  A function to "smooth" a vector of mobility
  classifications, to drop 'outliers'.
}
\examples{
test <- factor(c("drive", "drive", "drive", "walk", "drive", "drive", "drive", "drive", "walk", "walk", "walk", "walk", "walk", "walk", "sit", "sit", "sit", "sit", "sit", "sit", "drive", "sit", "sit", "sit", "sit"));
data.frame(original= test, smoothed = mobility.smooth(test));
}
\author{
  jeroen
}

