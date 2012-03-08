\name{mobility.summarize}
\alias{mobility.summarize}
\title{Summarize mobility classifications}
\usage{
  mobility.summarize(x)
}
\arguments{
  \item{x}{vector of mobility modes}
}
\value{
  Data frame with summary statistics
}
\description{
  Returns counts and proportions for a vector of mobility
  modes.
}
\examples{
test <- factor(c("drive", "drive", "drive", "walk", "drive", "drive", "drive", "drive", "walk", "walk", "walk", "walk", "walk", "walk", "bike", "bike", "bike", "bike", "bike", "bike", "drive", "bike", "bike", "bike", "bike"));
mobility.summarize(test);
}
\author{
  jeroen
}

