#' Classify Home vs Not Home
#' 
#' This function attempts to classify a day of data between home and non home points.
#' 
#' @param mydf a dataframe of mobility data for one day.
#' @param homeradius the radius in KM to be considered home (take into account GPS noise).
#' @return a vector of booleans
#' @export
home <- function(mydf, homeradius=0.5){
	
	if(!is.data.frame(mydf) || nrow(mydf) == 0){
		return(factor(levels=c(T,F)))
	}
	
	#we assume a dataframe with a ts value.
	#search for observation closest to 3am
	minpoint <- which.min(abs(as.numeric(as.character(mydf$ts, format="%H.%M")) - 3));
	homerecord <- mydf[minpoint,];
	
	#check if this observation is between 00:00 and 06:00
	if(abs(as.numeric(as.character(homerecord$ts, format="%H.%M"))-3) > 3){
		#no observations between 00:00 and 06:00. We are not going to guess where home is.
		return(factor(rep(NA, nrow(mydf)), levels=c(T,F)));
	}
	
	homelo <- lowess(homerecord$lo)$y;
	homela <- lowess(homerecord$la)$y;
	
	#little function to use apply
	mydist = function(x) ifelse(any(is.na(c(x[1:2], x[3:4]))), NA, geodistance(x[1:2], x[3:4]));
	
	#calculate distances
	mydf$homedist <- apply(cbind(mydf$lo, homelo, mydf$la, homela), 1, mydist);
	homevecs <- mydf$homedist < homeradius;
	
	#some aggressive smoothing on classifications
	#we smooth over approx 20 minutes of data.
	homevecs <- as.logical(round(lowess(homevecs, f=20/length(homevecs))$y))
	
	#make it into a factor
	homevec <- factor(homevecs, levels=c(T,F));
	return(homevec);
}