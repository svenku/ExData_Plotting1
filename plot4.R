# set working directory to current script file location 
# and create data directory if it does not exist

mainDir <- dirname(sys.frame(1)$ofile)
dataDir <- "data"
setwd(mainDir)

if (!file.exists(dataDir)){
    message("Creating data directory.")
    dir.create(file.path(mainDir, dataDir))
} else {
    message("Data directory exists.")
}

# check if data file downloaded, download if not

if (!file.exists("./data/data.zip")){
    message("Downloading data file.")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "./data/data.zip")
} else {
    message("Data file already exists.")
}

# Unzip downloaded data

if (!file.exists("./data/household_power_consumption.txt")){
    message("Unzipping data file.")
    unzip("./data/data.zip", exdir = file.path(mainDir, dataDir))
} else {
    message("Data already unzipped.")
}

# read data, subset 2 February 2007 days, convert datetime

message("Reading data...")
data <- read.table("./data/household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?")
message("Subsetting only needed data...")
data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")
message("Converting dates and times to datetime...")
data$datetime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

# make 4 charts, copy to png, close device

message("Creating 4 different charts")
par(mfrow = c(2,2))
plot(data$datetime, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")
plot(data$datetime, data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
plot(data$datetime, data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
points(data$datetime, data$Sub_metering_2, type = "l", col = "Red")
points(data$datetime, data$Sub_metering_3, type = "l", col = "Blue")
legend("topright", leg_text, lty = c(1,1,1), col = c("Black", "Red", "Blue"), bty = "n")
plot(data$datetime, data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

# For copying using higher than required 480x480 resolution, otherwise half of legend does not display

dev.copy(png, file = "./figure/plot4.png", width=700, height=700)
dev.off()
message("Done!")
