# Author:  Cornelius Tanui
# Email: kiplimocornelius at gmail.com
# Description: Demonstrate the use of HTTP methods in Ambiorix web framework for R.
# Date: 24 Feb 2025
# Version: 1.0

# Install required libraries
# remotes::install_github("ambiorix-web/ambiorix", 
#                         
#                         # stored in Renviron
#                         auth_token = Sys.getenv("pat"))

# Install required libraries
library(ambiorix)
library(nycflights13)
library(dplyr)
library(data.table)
library(DBI)
library(RSQLite)


# initialise app
app <- Ambiorix$new(port = 8000L)

app$get("/", \(req, res) {
  res$send("Hello, World!")
})

app$start()