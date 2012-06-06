#' Leave and get home times
#' 
#' Calculates the time in which participant left home and got back home.
#' 
#' @param mydf dataframe with one day of data.
#' @return vector with 2 timestamps
#' @export
leavehome <- function(mydf){
	
	#calculate home or not
	mydf$home <- as.logical(home(mydf));
	
	#we assume that the person starts and ends the day at home.
	#Note: We assume here that home as been determined as 4AM location. Hence, 
	#observations before 4AM cannot be classified as 'leaving home'

	leavetime <- mydf[min(which(!mydf$home & abs(as.numeric(as.character(mydf$ts, format="%H"))) >= 4)),];
	hometime   <- mydf[max(which(!mydf$home)),];
	
	#return timestamps
	times <- as.numeric(as.character(c(leavetime$ts, hometime$ts), format="%H.%M"));
	if(any(is.na(times))) return(c(NA, NA))
	return(times);
}

