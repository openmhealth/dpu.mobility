#' Summarize mobility classifications
#' 
#' Returns counts and proportions for a vector of mobility modes.
#' 
#' @param x vector of mobility modes 
#' @return Data frame with summary statistics 
#' @author jeroen
#' @examples test <- factor(c("drive", "drive", "drive", "walk", "drive", "drive", "drive", "drive", "walk", "walk", "walk", "walk", "walk", "walk", "bike", "bike", "bike", "bike", "bike", "bike", "drive", "bike", "bike", "bike", "bike"));
#' mobility.summarize(test); 
#' @export
mobility.summarize <- function(x){
	counts <- as.data.frame(table(x));
	counts$Proportion <- counts$Freq / sum(counts$Freq);
	return(counts);
}