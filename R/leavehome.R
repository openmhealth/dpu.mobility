#' Leave and get home times
#' 
#' Calculates the time in which participant left home and got back home.
#' 
#' @param mydf dataframe with one day of data.
#' @return vector with 2 timestamps
#' @export
leavehome <- function(mydf){
	
	#we only use ts lo la
	mydf <- mydf[c("ts", "lo", "la")];
	mydf <- na.omit(mydf);	
	
	#we can't classify home with less than one hour of data.
	if(nrow(mydf) < 60){
		return(c(NA,NA));
	}	
	
	#calculate home or not
	mydf$home <- as.logical(home(mydf));
	
	#we assume that the person starts and ends the day at home.
	#Note: We assume here that home as been determined as 3AM location. Hence, 
	#observations before 3AM cannot be classified as 'leaving home'
	if(all(is.na(mydf$home))){
		return(c(NA,NA));
	}
	
	#If we have less than an hour of 'home' points, it was most likely misclassified.
	if(sum(!mydf$home) < 60){
		return(c(NA,NA));
	}
	
	#we look for the lowest point after 3AM where the person was not home
	leavetime <- mydf[min(c(999999, which(!mydf$home & abs(as.numeric(as.character(mydf$ts, format="%H"))) >= 3))),];
	hometime   <- mydf[max(which(!mydf$home)),];
	
	#return timestamps
	times <- as.numeric(as.character(c(leavetime$ts, hometime$ts), format="%H.%M"));
	if(any(is.na(times))) return(c(NA, NA))
	return(times);
}

