## Plot1
#
# download file, read, plot and copy to Plot1.png
## Dependencies 
##library(dplyr)

##http://www.r-graph-gallery.com/
#############################################

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

## Plot 1
hist(twodays$Global_active_power, col = "red", xlab = "Global Active Power (Killowatts)" ,main = "Global Active Power")
dev.copy(png, file = "plot1.png")   ## copy to png file
dev.off()
