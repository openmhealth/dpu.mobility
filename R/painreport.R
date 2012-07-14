#' Generate pain pilot report
#' 
#' @param serverurl url of the ohmage server 
#' @param token valid auth token 
#' @param username target user
#' @param days number of days
#' @export
painreport <- function(serverurl, token, username, days=14){
	
	library(Ohmage);
	library(ggplot2);
	library(reshape2);
	library(scales);	
	
	options(SERVERURL = serverurl);
	options(TOKEN = token);
	options(ohmage_username = "omh-report");

	daterange <- as.character(as.Date(Sys.time()) - 1:days);
	pdf("report.pdf", paper="A4r", width=11.7, height=8.3);
	
	#Download 2 weeks of data
	debdata <- oh.mobility.read(username=username);
	for(thisdate in daterange){
		cat("Downloading:", thisdate, "\n")
		newdata <- oh.mobility.read(username=username, date=thisdate);
		debdata <- rbind(debdata, newdata);
	}
	debdata <- debdata[order(debdata$ts),];
	debdata$date <- as.Date(debdata$ts);
	debdata$time <- as.numeric(as.character(debdata$ts, format="%H")) + as.numeric(as.character(debdata$ts, format="%M")) / 60
	
	#### USE SERVER CLASSIFIER
	debdata$m <- factor(debdata$cd.m, levels=c("still", "walk", "drive", "run"))
	##########################
	
	alldata <- as.data.frame(do.call(rbind,lapply(split(as.factor(debdata$m), as.factor(debdata$date)), table)));
	alldata$date <- as.Date(row.names(alldata));
	alldata$dow <- as.numeric(as.character(alldata$date, format="%w"));
	alldata$day <- as.factor(ifelse(alldata$dow == 0 | alldata$dow == 6 , "weekend", "weekday"));
	
	#regroup
	newdata <- reshape2:::melt.data.frame(alldata[,c("date", "drive", "day", "still", "walk", "run")], measure.vars=c("still", "walk", "drive", "run"), variable.name="mobility");
	plot1 <- ggplot(aes(x=date, y=value/60, alpha=day), data=newdata) + geom_bar(aes(fill=mobility), stat="identity", position="stack") +
			scale_x_date(labels=date_format("%A\n%B %d")) +			
			scale_alpha_discrete(range=c(1, 0.6), guide="none") + xlab("") + ylab("total recorded hours") + opts(title="Daily Mobility Counts")
	print(plot1)
	
	#only walk
	walkdata <- subset(newdata, mobility=="walk" | mobility=="run");
	
	plot2 <- ggplot(aes(x=date, y=value, alpha=day), data=walkdata) + geom_bar(stat="identity", position="stack") +
			scale_alpha_discrete(range=c(1, 0.6), guide="none") + 
			scale_x_date(labels=date_format("%A\n%B %d")) +
			opts(title="Minutes per day ambulatory") + ylab("minutes") + xlab(""); 
	print(plot2)
	
	#Break up per day:
	debdays <- split(debdata, debdata$date);
	homevecs <- lapply(debdays, home);
	hometable <- as.data.frame(t(sapply(homevecs, table)));
	hometable$date <- as.Date(row.names(hometable));
	hometable <- reshape2:::melt.data.frame(hometable, id.vars="date", variable.name="home", value.name="count");
	hometable$hours <- hometable$count/60;
	hometable$dow <- as.numeric(as.character(hometable$date, format="%w"));
	hometable$day <- as.factor(ifelse(hometable$dow == 0 | hometable$dow==6 , "weekend", "weekday"));
	hometable$location <- as.factor(ifelse(as.logical(hometable$home), "home", "out"));
	
	#plot of home per day
	plot3 <- ggplot(aes(x=date, y=hours, fill=location), data=hometable) + 
			geom_bar(stat="identity", position="stack",aes(alpha=day)) + scale_alpha_discrete(range=c(1, 0.6), guide="none") +
			scale_x_date(labels=date_format("%A\n%B %d")) +
			opts(title="Hours per day spent at home") + xlab("") ;
	print(plot3)
	
	#calculate when leaves home and comes back.
	leavegethome <- sapply(debdays, leavehome);
	leavegethome <- t(leavegethome);
	hometable$leavetime = leavegethome[,1]
	hometable$hometime = leavegethome[,2]
	timeleaving <- na.omit(hometable);
	timeleaving <- subset(timeleaving, leavetime != 0);
	plot4 <- qplot(x=date, y=leavetime, data=timeleaving, ylim=c(0, 24)) + geom_line(alpha=.5) + 
			scale_x_date(labels=date_format("%A\n%B %d")) +
			scale_y_continuous(limits=c(0, 23),breaks=c(3,6,9,12,15,18,21), labels=c("3am", "6am", "9am", "12pm", "3pm", "6pm", "9pm")) +
			#scale_y_continuous(breaks=c(3,6,9,12,15,18,21), labels=c("3am", "6am", "9am", "12pm", "15pm", "18pm", "21pm")) +	
			opts(title="time of leaving home") + ylab("time of day") + ylab("");
	print(plot4)
	
	#time between waking up and leaving
	#hometable$interval <- apply(cbind(0, hometable$leavetime - 5),1,max,0)
	#ggplot(aes(x=date, y=interval), data=na.omit(hometable)) + stat_identity(geom="bar") + opts(title="Time between waking up and leaving. Assuming 5am wakeup.");
		
	#display speeds
	#plot(walkspeed(debdata, getspeed=FALSE), labels=FALSE)
	print(plot(walkspeed(debdata, getspeed=FALSE)))
	
	#display intervals
	#plot(intervals(debday$m, 5, smooth=FALSE))
	#plot(intervals(debday$m, 5));
	#plot(intervals(debday$m, 10));
	
	#tile plot
	plot5 <- ggplot(aes(x=date, y=time), data=debdata) + geom_tile(aes(fill=m)) + opts(title="raw data plot", panel.background = theme_rect(fill="#F6F6F6", linetype = "dashed"));
	print(plot5)
	
	#turn off device
	dev.off();
	invisible();
}
	
	
	