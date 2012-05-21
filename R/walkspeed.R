walkspeed.day <- function(mydf, minimum, smooth){
	m <- mydf$m;
	if(isTRUE(smooth)){
		m <- mobility.smooth(m);
	}
	myinterval <- as.data.frame(unclass(rle(m)));
	myinterval$start <- head(c(1,cumsum(myinterval$lengths)+1),-1);
	myinterval$stop <- cumsum(myinterval$lengths);	
	myinterval <- myinterval[myinterval$lengths >= minimum,];

	#get distance from long/lat
	myinterval$distance <- apply(myinterval, 1, function(x) {
		x <- as.list(x);
		start <- x$start;
		stop  <- x$stop;
		geodistance(mydf$lo[start:stop], mydf$la[start:stop], unit="miles");
	});

	#strip other mobilities
	myinterval <- myinterval[myinterval$values == "walk",]
	
	#calculate speed
	myinterval$speed <- 60 * (myinterval$distance / myinterval$lengths);
	return(myinterval);
}

#' Calculate walking speed
#' 
#' Takes a mobility data object and calculates average walking speeds
#' 
#' @param mydf mobility data object
#' @param minimum minimum span of walking period to be included
#' @param smooth should data be smoothed (T/F)
#' @return 
#' @export
walkspeed <- function(mydf, minimum=6, smooth=TRUE){
	splitdata <- split(mydf, as.Date(mydf$ts));
	walkspeeddays <- lapply(splitdata, walkspeed.day, minimum=minimum, smooth=smooth);
	walkspeedcombined <- do.call(rbind, walkspeeddays);
	walkspeedcombined$Date <- as.Date(rep(names(walkspeeddays), sapply(walkspeeddays, nrow)));
	structure(walkspeedcombined, class=c("walkspeed", "data.frame"), minimum=minimum);	
}

#' Plot walkspeed data
#' 
#' @param walkspeed object 
#' @return ggplot2 plot object
#' @export
plot.walkspeed <- function(walkspeed){
	stopifnot("walkspeed" %in% class(walkspeed));
	minimum <- attr(walkspeed, "minimum")
	#plot a timeseries
	qplot(x=Date, y=lengths, data=walkspeed, ylab="minutes", main=paste("Walking periods of", minimum, ">= min with avg. speed in MPH"), geom="blank") + 
			geom_bar(stat="identity", position="stack", color="darkgray") + 
			geom_text(aes(label=paste(round(speed,2))), color="white", position="stack", vjust=2);		
}
