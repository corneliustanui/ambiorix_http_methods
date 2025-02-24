# Author:  Cornelius Tanui
# Email: kiplimocornelius at gmail.com
# Description: Demonstrate the use of HTTP methods in Ambiorix web framework for R.
# Date: 24 Feb 2025
# Version: 1.0

# Install required libraries
# remotes::install_github("ambiorix-web/ambiorix",
# 
#                         # stored in Renviron
#                         auth_token = Sys.getenv("pat"),
#                         
#                         force = TRUE)

# Load required libraries
library(nycflights13)
library(dplyr)
library(data.table)
library(DBI)
library(RSQLite)

## Part 1
# 1) Load the data and cast it as data.table
nycflights13 <- as.data.table(nycflights13::flights)

# 2.i) Average departure delay for each airline
departure_delay <- nycflights13[, .(avg_dep_delay = mean(dep_delay,
                                                         na.rm = TRUE)), 
                                by = carrier]

# Retain all the other columns
nycflights13_processed <- merge(nycflights13, departure_delay, by = "carrier")

# 2.ii) Top 5 destinations
top_5_destinations <- nycflights13[, .N, by = dest][order(-N)][1:5]

# 2.iii) Add a unique ID for each row
nycflights13_processed <- nycflights13_processed[, id := seq_len(.N)]

# 2.iv) Add a column indicating the flight was delayed for more than 15 minutes
nycflights13_processed <- nycflights13_processed[, delayed_15min_flag := ifelse(dep_delay > 15, "Yes", "No")]

# 3) Save data as CSV or SQLitefile
## -- create folder
if(!dir.exists("./Data")){dir.create("./Data")} else "Dir exists!"

## -- save as CSV
write.csv(x = nycflights13_processed,
          file = "Data/nycflights13_processed.csv")

## -- save as SQLite file
# Create a connection to an SQLite database file
con <- dbConnect(RSQLite::SQLite(), "Data/nycflights13_processed.db")

# Save the data.table to the SQLite database
dbWriteTable(con, "nycflights13_processed", nycflights13_processed, overwrite = TRUE)

# Close the connection
dbDisconnect(con)
