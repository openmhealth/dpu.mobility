#' Calculate the daily diameter
#' 
#' This function approximates the greatest distance between any two points from a set of lng/lat coordinates.
#' 
#' @param long vector of longitude coordinates; length equal to 'lat'. 
#' @param lat vector of lattitude coordinates; length equal to 'long'.
#' @param unit Either "km" or "miles"
#' @param smooth should data be smoothed first to remove outliers
#' @param na.rm remove unknown/null values from data
#' @return Daily diameter value
#' @examples long <- c(-118.453989, -118.450041, -118.444376, -118.439569, -118.439484, -118.444204, -118.444118, -118.441887);
#' lat  <- c(34.073777, 34.069547, 34.064001, 34.077225, 34.070400, 34.070008, 34.069085, 34.070578);
#' qplot(long, lat, geom="path");
#' diamter(long, lat);
#' @import geosphere
#' @export

diameter <- function(long, lat, unit="km", smooth=FALSE, na.rm=TRUE){
  if(isTRUE(na.rm)){
    long <- na.omit(long);
    lat  <- na.omit(lat);
  }
  if(length(long) != length(lat)){
    stop("parameters 'lon' and 'lat' should be vectors of equal length, and at least length 2.");
  }
  
  if(length(long) < 2){
    return(NA)
  }
  
  if(isTRUE(smooth)){
    long <- lowess(long)$y;
    lat <- lowess(lat)$y;
  }  
  
  #this is a temporary approximation
  index1 <- which.max((lat - mean(lat))^2 + (long - mean(long))^2);
  lat1 <- lat[index1];
  long1 <- long[index1];
  
  index2 <- which.max((lat - lat1)^2 + (long - long1)^2);
  lat2 <- lat[index2];
  long2 <- long[index2];
  
  #Default in km
  diameter <- distHaversine(c(long1, lat1), c(long2, lat2));
  diameter <- diameter / 1000;
  
  if(unit == "miles"){
    diameter <- diameter * 0.621371192;
  } else if(unit == "meters"){
    diameter <- diameter * 1000;
  }	
  
  #calculate distance
  list(
    diameter = diameter,
    points = list(c(long1, lat1), c(long2, lat2))
  );

}
