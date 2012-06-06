#' Smoothing mobility data
#' 
#' A function to "smooth" a vector of mobility classifications, to drop 'outliers'.
#'  
#' @param x the vector with modes. Will always be treated as catagorical (don't use with real numbers).
#' @param strength smoothing parameter. Rougly the number of neighbouring days that should be taken into account while smoothing.
#' @return the smoothed vector
#' @author jeroen
#' @examples test <- factor(c("drive", "drive", "drive", "walk", "drive", "drive", "drive", "drive", "walk", "walk", "walk", "walk", "walk", "walk", "sit", "sit", "sit", "sit", "sit", "sit", "drive", "sit", "sit", "sit", "sit"));
#' data.frame(original= test, smoothed = mobility.smooth(test));
#' @export
mobility.smooth <- function(x, strength=5){
	if(length(unique(x)) <= 1){
		return(x);
	}
	if(length(x) < strength) return(x);
	f <- strength/length(x);
	input <- factor(x);
	#define smoothing function
	lwsm <- function(input){
		return(lowess(input, f=f)$y)
	}
	
	#smooth columns
	output <- apply(apply(model.matrix(~0+input), 2, lwsm),1, which.max);
	
	#format output
	class(output) <- class(input);
	levels(output) <- levels(input);
	
	#some magic to make sure json output is same as input format
	output <- as.character(output);
	if(is.numeric(x)){
		output <- as.numeric(output);
	}
	
	#return
	return(output);
}
