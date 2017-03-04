
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
twodays$DT <- strptime(paste(twodays$Date, twodays$Time),"%Y-%m-%d %H:%M:%S")

## library(lattice)
## subgroups in a plot
##install.packages('reshape2')
##library(reshape2)

m1 <- select(twodays, DT, Sub_metering_1, Sub_metering_2, Sub_metering_3)
melted <- melt(m1, id.vars=c("DT") , na.rm = TRUE)


with(melted, plot(DT,value, ylab = "Energy sub metering", pch = NA, xlab = NA, type = n) )  ## plot with no data
lines(melted$DT[melted$variable == "Sub_metering_1"], melted$value[melted$variable == "Sub_metering_1"], col = "black") 
lines(melted$DT[melted$variable == "Sub_metering_2"], melted$value[melted$variable == "Sub_metering_2"], col = "red") 
lines(melted$DT[melted$variable == "Sub_metering_3"], melted$value[melted$variable == "Sub_metering_3"], col = "blue") 

  

dev.copy(png, file = "plot2.png")   ## copy to png file
dev.off()
