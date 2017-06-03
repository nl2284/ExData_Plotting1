##1. download the dataset,  unzip it

if(!file.exists("./electr/data.zip")) {
  url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
  dir.create("./electr")
  download.file(url, destfile="./electr/data.zip", method="curl") 
  unzip("./electr/data.zip", exdir="./electr")
}

###2. read the data starting from the line with the date 2007-02-01, 24*60*2 rows, clean it.
skipindex<-grep("1/2/2007", readLines("./electr/household_power_consumption.txt"))
####read the first line to get the col.names
ns<-strsplit(readLines("./electr/household_power_consumption.txt", n=1), split=";")
ns<-unlist(ns)
ns<-tolower(ns)
energy<-read.table("./electr/household_power_consumption.txt", skip=skipindex, 
                   nrows=24*60*2, header=TRUE, sep=";", col.names=ns, na.strings="?")

####create datetime variable
energy$datetime<-strptime(paste(energy$date, energy$time, sep=" "), format="%d/%m/%Y %H:%M:%S")

####Construct plot 1--histogram of Global Active Power
png("Plot1.png", width=480, height=480)
hist(energy$global_active_power,col="red", main="Global Active Power", 
     xlab="Global Active Power (kilowatts)")
dev.off()
