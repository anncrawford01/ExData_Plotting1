## Plot4
#
# download file, read, plot 4 plots in 2 columns and copy to Plot4.png
## Dependencies 
##library(dplyr)
##install.packages('reshape2')
##library(reshape2)

##http://www.r-graph-gallery.com/
#############################
zipurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./data")) {dir.create("./data")}
zipfile <- "./data/electricpower.zip"
download.file(zipurl,destfile=zipfile,mode = "wb")

## read zipped file 
unzip(zipfile, exdir = "./data")

#### Get the data #####

## 2,075,259 rows and 9 columns approx 150 mb 

pwrcolClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")
powerdata   = read.table("./data/household_power_consumption.txt", sep=";", colClasses = pwrcolClasses,header = TRUE , na.strings ="?")
##library(dplyr)
## using data from the dates 2007-02-01 and 2007-02-02 th and friday
twodays = filter(powerdata, Date == "1/2/2007" | Date == "2/2/2007")

## convert the Date and Time variables to Date/Time classes in R using the strptime() and as.Date() functions.
twodays$Date <- as.Date(twodays$Date, format="%d/%m/%Y")
twodays$DT <- strptime(paste(twodays$Date, twodays$Time),"%Y-%m-%d %H:%M:%S")  ## melted does not work with "POSIXlt"


##install.packages('reshape2')
##library(reshape2)

## count nas sapply(twodays, function(x) sum(is.na(x)))  -- none found

m1 <- select(twodays, Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3)
melted <- melt(m1, id.vars=c("Date","Time"))

par(mfrow = c(2,2), mar = c(4,4,4, 2))
## first plot
with(twodays,     plot(DT,Global_active_power, ylab = "Global Active Power(killowatts)", pch = NA, xlab = NA) )
lines(twodays$DT,twodays$Global_active_power)

## second plot
with(twodays, plot(DT,Voltage, ylab = "Voltage", pch = NA, xlab = "datetime") )
lines(twodays$DT,twodays$Voltage)

## third plot ## melted does not work with "POSIXlt" DT
with(melted, plot(strptime(paste(melted$Date, melted$Time),"%Y-%m-%d %H:%M:%S"), value, ylab = "Energy sub metering", pch = NA, xlab = NA , type = "n"))   ## plot with no data
lines(strptime(paste(melted$Date, melted$Time),"%Y-%m-%d %H:%M:%S")[melted$variable == "Sub_metering_1"], melted$value[melted$variable == "Sub_metering_1"], col = "black")
lines(strptime(paste(melted$Date, melted$Time),"%Y-%m-%d %H:%M:%S")[melted$variable == "Sub_metering_2"], melted$value[melted$variable == "Sub_metering_2"], col = "red") 
lines(strptime(paste(melted$Date, melted$Time),"%Y-%m-%d %H:%M:%S")[melted$variable == "Sub_metering_3"], melted$value[melted$variable == "Sub_metering_3"], col = "blue") 
legend("topright" , lty = 1, col= c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), rect(5,10))

## 4th plot
with(twodays, plot(DT,Global_reactive_power, pch = NA, xlab = "datetime") )
lines(twodays$DT,twodays$Global_reactive_power)


dev.copy(png, file = "plot4.png")   ## copy to png file
dev.off()
