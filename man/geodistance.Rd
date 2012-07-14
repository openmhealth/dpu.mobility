\name{geodistance}
\alias{geodistance}
\title{Calculate total distance traveled}
\usage{
  geodistance(long, lat, unit = "km", smooth = TRUE,
    na.rm = TRUE, total = TRUE)
}
\arguments{
  \item{long}{vector of longitude coordinates; length equal
  to 'lat'.}

  \item{lat}{vector of lattitude coordinates; length equal
  to 'long'.}

  \item{unit}{Either "km" or "miles"}
}
\value{
  Total distance traveled
}
\description{
  This function uses Haversine formula to calculate the
  total distance between a number of locations.
}
\examples{
geodistance(c(-74.0064, -118.2430, -74.0064), c(40.7142, 34.0522, 40.7142)) #NY - LA - NY
geodistance(c(-74.0064, -118.2430, -74.0064), c(40.7142, 34.0522, 40.7142), "miles") #NY - LA - NY
}
\author{
  jeroen
}

