#' Calculate intervals
#' 
#' The function calculates the number of intervals of identical mobility modes
#' 
#' @param mobility mobility vector
#' @param minimum minimal interval span. 
#' @return data frame
#' @export
intervals <- function(mobility, minimum=0, smooth=TRUE){
	if(isTRUE(smooth)){
		mobility <- mobility.smooth(mobility);
	}
	intervals <- rle(as.character(mobility));
	intervals <- as.data.frame(unclass(intervals));
	intervals <- intervals[intervals$length >= minimum,];
	intervals <- intervals[order(intervals$length, decreasing=TRUE),];
	return(structure(intervals, class="intervals", minimum=minimum, smooth=smooth));
}

#' Plot intervals data
#' 
#' @param mydata return object from intervals() 
#' @return ggplot2 plot
#' @export
plot.intervals <- function(mydata){
	stopifnot("intervals" %in% class(mydata));
	minimum <- attr(mydata, "minimum");
	smooth <- attr(mydata, "smooth");
	if(length(mydata$values) == 0){
		warning("intervals object has no data.")
		qplot(1,1,geom="blank", ylab="", xlab="");
	} 
	mydata <- structure(mydata, class="data.frame");
	qplot(x=values, y=1, ymax=1, data=mydata, ylab="", main=paste("intervals >=", minimum, "min"), geom="blank") + 
		geom_bar(stat="identity", position="stack", color="darkgray") + 
		geom_text(aes(label=paste(lengths, "min")), color="white", position="stack", vjust=2);	
}