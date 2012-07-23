#' Classify Home vs Not Home
#' 
#' This function attempts to classify a day of data between home and non home points.
#' 
#' @param mydf a dataframe of mobility data for one day.
#' @param homeradius the radius in KM to be considered home (take into account GPS noise).
#' @return a vector of booleans
#' @export
home <- function(mydf, homeradius=0.5){
	
	#some basic validation
	if(!is.data.frame(mydf) || nrow(mydf) == 0){
		return(factor(NA, levels=c(T,F)))
	}
	
	#we only use ts lo la
	mydf <- mydf[c("ts", "lo", "la")];
	mydf <- na.omit(mydf);
	
	#we can't classify home with less than one hour of data.
	if(nrow(mydf) < 60){
		return(factor(NA, levels=c(T,F)));
	}		
	
	#smooth the lonlats
	mydf$lo <- lowess(mydf$lo, f=20/length(mydf$lo))$y;
	mydf$la <- lowess(mydf$la, f=20/length(mydf$la))$y;	
	
	#we assume a dataframe with a ts value.
	#search for observation closest to 3am
	minpoint <- which.min(abs(as.numeric(as.character(mydf$ts, format="%H.%M")) - 3));
	homerecord <- mydf[minpoint,];
	
	#check if this observation is between 00:00 and 06:00
	if(abs(as.numeric(as.character(homerecord$ts, format="%H.%M"))-3) > 3){
		#no observations between 00:00 and 06:00. We are not going to guess where home is.
		return(factor(NA, levels=c(T,F)));
	}
		
	#home record lon/lat
	homelo <- homerecord$lo;
	homela <- homerecord$la;
	
	#little function to use apply
	mydist = function(x) ifelse(any(is.na(c(x[1:2], x[3:4]))), NA, geodistance(x[1:2], x[3:4]));
	
	#calculate distances
	mydf$homedist <- apply(cbind(mydf$lo, homelo, mydf$la, homela), 1, mydist);
	homevecs <- (mydf$homedist < homeradius);
	
	#some aggressive smoothing on classifications
	#we smooth over approx 20 minutes of data.
	homevecs <- as.logical(round(lowess(homevecs, f=20/length(homevecs))$y))
	
	#make it into a factor (so that table will preserve levels)
	homevec <- factor(homevecs, levels=c(T,F));
	return(homevec);
}