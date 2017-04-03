seattle <- read.csv(file="seattle_incidents_summer_2014.csv",header=T,sep=",")   
sf <- read.csv(file="sanfrancisco_incidents_summer_2014.csv",header=T,sep=",")

# Replace all THEFT related incidents
seattle$Offense.Type = gsub('.*THEFT.*','THEFT',seattle$Offense.Type)

#Convert Time to POSIXct
sf$Time <- as.POSIXct(sf$Time, format="%H:%M")
sf$Date <- as.POSIXct(sf$Date, format="%m/%d/%Y") 
sf$month <- format(sf$Date, "%m")

#Filter out only THEFT related crimes from the CSV
crime = sf[sf$Category == "LARCENY/THEFT", ]
seattle_theft = seattle[seattle$Category == "THEFT", ]

# plot Crime Category vs Time
d <- ggplot(sf,aes(x=sf$Time, y=sf$Category, colour=sf$Category))+geom_point()+scale_x_datetime(breaks=date_breaks('4 hour'),labels=date_format('%H:%M')) + theme(legend.position = 'top',axis.text.y=element_blank())

# Plot Bar graph for theft by district
d <- ggplot(data=crime, aes(crime$PdDistrict)) + geom_bar()
ggsave(filename="SF.jpg", plot=d)

#ggplot(aes(x = x$Category ) , data = x) + 
#  geom_histogram(aes(fill = x$DayOfWeek ), binwidth=1500, colour="grey20", lwd=0.2) +
#  geom_text(data=x, aes(label=count, y=ypos), colour="white", size=3.5)

# Crime category by month
f <- ggplot(data=seattle, aes(seattle$Category,fill=seattle$Month)) + geom_bar()+theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

seattle$Day <- weekdays(as.Date(seattle$Date))

# Get count of incidents by month and count of incidents by hours in a day
library(lubridate)
sf$Year <- year(sf$Date)
sf$Date <- as.POSIXct(sf$Date, format="%m/%d/%Y")
sf$Year <- year(sf$Date)
sf$Month <- month(sf$Date)
sf$Day <- day(sf$Date)
sf$Time = as.POSIXct(sf$Time, format="%H:%M")
sf$Hour <- hour(sf$Time)
sf$Minute <- minute(sf$Time)
library(dplyr)
daily <- group_by(sf,Date)
sf_day_counts = summarise(daily, count = n())
ggplot(day_counts, aes(x = Date, y = count)) + geom_point(colour = "red") + geom_line(colour = "red", size = 1.5) + xlab("Date") + ylab("Count of indicents") + ggtitle("The number of incidents in Summer 2014 of San Francisco") 

# This can be extended as needed
hourly <- group_by(seattle_theft, Hour)
seattle_theft_hourly_counts <- summarise(hourly, count=n())
d<-ggplot()+ geom_line(data=seattle_theft_hourly_counts,aes(x=Hour,y=count,color="THEFT RELATED"))+geom_line(data=seattle_hourly_counts,aes(x=Hour,y=count,color="All Crime"))+xlab("Hours in a Day")+ ylab("Crime of incidents")+ggtitle("Crime distribution for 24hrs in Seattle")

d<-ggplot()+ geom_line(data=sf_day_counts,aes(x=Date,y=count,color="red"))+geom_line(data=sf_day_counts,aes(x=Date,y=count,color="green"))+xlab("Date") + ylab("Count of indicents") + ggtitle("The number of incidents in San Francisco")
