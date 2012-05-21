library(dpu.mobility);
library(Ohmage);
library(maps);
library(ggplot2);
library(reshape2);

days = 30


username = "ohmage.nithya"
username = "ohmage.estrin"
username = "ohmage.ht";
username = "ohmage.hossein";
username = "sink.thaw";
username = "ohmage.josh"

oh.login("ohmage.ooms", "vohohdai.g", "https://dev.mobilizingcs.org/app");
#oh.login("ohmage.hossein", "Hossein.00", "https://dev.mobilizingcs.org/app")
daterange <- as.character(as.Date(Sys.time()) - 1:days);
pdf(paste(username, "2.pdf", sep=""), paper="A4r", width=11.7, height=8.3);

#Get yesterdays data:
#debday <- oh.mobility.read(username=username, date=as.Date(Sys.time())-1, verbose=T);

#See where we are is:
#map('state')
#points(debday$lo, debday$la, col="red");

#More precisely:
#xlim = range(debday$lo, na.rm=TRUE);
#xlim = xlim + diff(xlim) * c(-1, 1) * 2;
#ylim = range(debday$la, na.rm=TRUE);
#ylim = ylim + diff(ylim) * c(-1, 1) * 2;
#map('county',xlim=xlim, ylim=ylim);
#points(debday$lo, debday$la, col="red");

#get mobility distribution:
#par(mar=c(0,0,3,0));
#mobility <- mobility.smooth(debday$m);
#pie(table(debday$m), main=as.Date(Sys.time())-1);
#distance <- geodistance(debday$lo, debday$la);

#Download data:
debdata <- oh.mobility.read(username=username, verbose=T);
for(thisdate in daterange){
	cat("Downloading:", thisdate, "\n")
	newdata <- oh.mobility.read(username=username, date=thisdate);
	debdata <- rbind(debdata, newdata);
}
debdata <- debdata[order(debdata$ts),];
debdata$date <- as.Date(debdata$ts);
debdata$time <- as.numeric(as.character(debdata$ts, format="%H")) + as.numeric(as.character(debdata$ts, format="%M")) / 60

#Map all data
map('state')
subset = (1:nrow(debdata) %% 100 == 0)
points(debdata$lo[subset], debdata$la[subset], col="red");

#get mobility distribution:
par(mar=c(0,0,3,0));
mobility <- mobility.smooth(debdata$m);
pie(table(debdata$m), main="total period");
distance <- geodistance(debdata$lo, debdata$la);

#Calculate all the tables:
alldata <- as.data.frame(do.call(rbind,lapply(split(as.factor(debdata$m), as.factor(debdata$date)), table)));
alldata$date <- as.Date(row.names(alldata));
alldata$dow <- as.numeric(as.character(alldata$date, format="%w"));
alldata$day <- as.factor(ifelse(alldata$dow == 0 | alldata$dow == 6 , "weekend", "weekday"));
qplot(date, walk, geom="bar", fill=day, stat="identity", data=alldata, main="minutes walked");
qplot(date, still, geom="bar", fill=day, stat="identity", data=alldata, main="minutes still");
qplot(date, drive, geom="bar", fill=day, stat="identity", data=alldata, main="minutes drive");

#Break up per day:
debdays <- split(debdata, debdata$date);
homevecs <- lapply(debdays, home);
hometable <- as.data.frame(t(sapply(homevecs, table)));
hometable$date <- as.Date(row.names(hometable));
hometable <- melt(hometable, id.vars="date", variable.name="home", value.name="count");
hometable$hours <- hometable$count/60;
hometable$dow <- as.numeric(as.character(hometable$date, format="%w"));
hometable$day <- as.factor(ifelse(hometable$dow == 0 | hometable$dow==6 , "weekend", "weekday"));
hometable$ishome <- as.factor(paste(hometable$day, ifelse(hometable$home == TRUE, "home", "out")))

#plot of home per day
ggplot(aes(x=date, y=hours, fill=ishome), data=hometable) + geom_bar(stat="identity", position="stack", alpha=0.6, color="#333333");

#calculate when leaves home and comes back.
leavegethome <- sapply(debdays, leavehome);
leavegethome <- t(leavegethome);
hometable$leavetime = leavegethome[,1]
hometable$hometime = leavegethome[,2]
ggplot(aes(x=date), data=na.omit(hometable)) + geom_line(aes(y=leavetime), alpha=.5) + geom_line(aes(y=hometime),alpha=0.5) +
	geom_point(aes(y=leavetime, color=day), size=3, alpha=0.7) + geom_point(aes(y=hometime, color=day), size=3, alpha=0.7) 

#tile plot
ggplot(aes(x=date, y=time), data=debdata) + geom_tile(aes(fill=m)) + opts(panel.background = theme_rect(fill="#F6F6F6", linetype = "dashed", colour="#BBBBBB"));

#home non home
debdata2 <- do.call(rbind, debdays);
debdata2$home <- factor(do.call(c, homevecs), levels=c(1,2), labels=c("home", "out"));
ggplot(aes(x=date, y=time), data=debdata2) + geom_tile(aes(fill=home)) + opts(panel.background = theme_rect(fill="#F6F6F6", linetype = "dashed", colour="#BBBBBB"));

#distance traveled
travel <- data.frame(date=as.Date(names(debdays)));
travel$dist <- sapply(debdays, function(mydf){return(geodistance(mydf$lo, mydf$la))});
qplot(x=date, y=dist, data=travel, geom=c("point", "line"), main="Travel distance in KM", ylim=c(0, max(travel$dist)));
dev.off();
