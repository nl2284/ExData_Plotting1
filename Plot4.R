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


###construct plots, 
png("Plot4.png", width=480, height=480)
par(mfrow=c(2, 2))
####first plot
with(energy, plot(datetime, global_active_power, type="l", xlab="",
                  ylab="Global Active Power"))
####second plot
with(energy, plot(datetime, voltage, type="l", xlab="datetime", ylab="Voltage"))
#### third plot
with(energy, plot(datetime, sub_metering_1, col="black", 
                  type="l", xlab="",ylab="Energy sub metering"))
with(energy, points(datetime, sub_metering_2, col="red",type="l"))
with(energy, points(datetime, sub_metering_3, col="blue", type="l"))
legend("topright", lty=c(1, 1, 1), col=c("black","red", "blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3") )
####fourth plot
with(energy, plot(datetime, global_reactive_power, type="l", xlab="datetime",
                  ylab="Global_reactive_power"))

#dev.copy(png, "Plot4.png", width=480, height=480)
dev.off()
