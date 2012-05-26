walkspeed.day <- function(mydf, minimum, smooth, getspeed){
	m <- mydf$m;
	if(isTRUE(smooth)){
		m <- mobility.smooth(m);
	}
	myinterval <- as.data.frame(unclass(rle(m)));
	myinterval$start <- head(c(1,cumsum(myinterval$lengths)+1),-1);
	myinterval$stop <- cumsum(myinterval$lengths);	
	myinterval <- myinterval[myinterval$lengths >= minimum,];

	if(isTRUE(getspeed)){
		#get distance from long/lat
		myinterval$distance <- apply(myinterval, 1, function(x) {
			x <- as.list(x);
			start <- x$start;
			stop  <- x$stop;
			geodistance(mydf$lo[start:stop], mydf$la[start:stop], unit="miles");
		});
	
		#calculate speed
		myinterval$speed <- 60 * (myinterval$distance / myinterval$lengths);
	}
	#strip other mobilities
	myinterval <- myinterval[myinterval$values == "walk",]	
	
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
walkspeed <- function(mydf, minimum=6, smooth=TRUE, getspeed=TRUE){
	splitdata <- split(mydf, as.Date(mydf$ts));
	walkspeeddays <- lapply(splitdata, walkspeed.day, minimum=minimum, smooth=smooth, getspeed=getspeed);
	walkspeedcombined <- do.call(rbind, walkspeeddays);
	walkspeedcombined$Date <- as.Date(rep(names(walkspeeddays), sapply(walkspeeddays, nrow)));
	structure(walkspeedcombined, class=c("walkspeed", "data.frame"), getspeed=getspeed, minimum=minimum);	
}

#' Plot walkspeed data
#' 
#' @param walkspeed object 
#' @return ggplot2 plot object
#' @export
plot.walkspeed <- function(walkspeed, labels=TRUE){
	stopifnot("walkspeed" %in% class(walkspeed));
	minimum <- attr(walkspeed, "minimum")
	getspeed <- attr(walkspeed, "getspeed")
	#plot a timeseries
	myplot <- ggplot(aes(x=Date, y=lengths), data=walkspeed) + geom_bar(stat="identity", position="stack", color="darkgray");
	if(isTRUE(labels)){
		if(isTRUE(getspeed)){
			myplot <- myplot + geom_text(aes(label=paste(round(speed,2))), color="white", position="stack", vjust=2) +
				opts(title=paste("Walking periods of", minimum, ">= min with avg. speed in MPH"))
		} else {
			myplot <- myplot + geom_text(aes(label=paste(round(lengths,2))), color="white", position="stack", vjust=2) +
					opts(title=paste("Walking periods of", minimum, ">= min with values in minutes."))		
		}
	} else {
		myplot <- myplot + opts(title=paste("Walking periods of", minimum, ">= minutes."))
	}
	myplot + scale_x_date(labels=date_format("%A\n%B %d")) + ylab("minutes")
}
