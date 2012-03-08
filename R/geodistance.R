#' Calculate total distance traveled
#' 
#' This function uses Haversine formula to calculate the total distance between a number of locations.
#' 
#' @param long vector of longitude coordinates; length equal to 'lat'. 
#' @param lat vector of lattitude coordinates; length equal to 'long'.
#' @param unit Either "km" or "miles"
#' @return Total distance traveled 
#' @author jeroen
#' @import geosphere
#' @examples geodistance(c(-74.0064, -118.2430, -74.0064), c(40.7142, 34.0522, 40.7142)) #NY - LA - NY
#' geodistance(c(-74.0064, -118.2430, -74.0064), c(40.7142, 34.0522, 40.7142), "miles") #NY - LA - NY
#' @export
geodistance <- function(long, lat, unit="km"){
	if(length(long) != length(lat) || length(long) < 2){
		stop("parameters 'lon' and 'lat' should be vectors of equal length, and at least length 2.");
	}
	
	steps <- length(long)-1
	
	# we import distHaversine from geosphere package
	alldist <- rep(NA, length=steps);
	for(i in 1:steps){
		alldist[i] <- distHaversine(c(long[i], lat[i]), c(long[i+1], lat[i+1]));		
	}
	
	if(unit == "miles"){
		alldist <- alldist * 0.621371192;
	}
	
	return(sum(alldist))
}


