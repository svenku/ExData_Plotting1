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

# make a line plot, copy to png, close device

message("Creating line plot")
plot(data$datetime, data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

dev.copy(png, file = "./figure/plot2.png", width=480, height=480)
dev.off()
message("Done!")
