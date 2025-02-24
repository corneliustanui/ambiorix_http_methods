# Author:  Cornelius Tanui
# Email: kiplimocornelius at gmail.com
# Description: Demonstrate the use of HTTP methods in Ambiorix web framework for R.
# Date: 24 Feb 2025
# Version: 1.0

# Load required libraries
library(ambiorix)
library(htmltools)
library(data.table)
library(jsonlite)

PORT <- 3000L

# Global data.table to store records
test_data <- data.table(first_name = character(), last_name = character())

# Home page with form
app <- Ambiorix$new(port = PORT)

app$get("/", \(req, res){
  
  # HTML form for user input
  form <- tagList(
    tags$form(
      action = "/submit", 
      enctype = "multipart/form-data", 
      method = "POST",
      p(
        tags$label(`for` = "first_name", "First Name"),
        tags$input(type = "text", name = "first_name")
      ),
      p(
        tags$label(`for` = "last_name", "Last Name"),
        tags$input(type = "text", name = "last_name")
      ),
      tags$input(type = "submit")
    )
  )
  
  res$send(form)
})

# Handle form submission
app$post("/submit", \(req, res){
  body <- parse_multipart(req)
  
  # Extract input values
  new_entry <- data.table(
    first_name = body$first_name,
    last_name = body$last_name
  )
  
  # Append new record to global data.table
  test_data <<- rbind(test_data, new_entry)
  
  # Send success message
  res$send(list(message = "Record successfully added."))
})

# Handle JSON payload submission
app$post("/submit_json", \(req, res){
  # Parse JSON request body
  data <- fromJSON(req$postBody)
  
  # Extract and validate input
  if (!"first_name" %in% names(data) || !"last_name" %in% names(data)) {
    res$status(400)$send(list(error = "Missing 'first_name' or 'last_name'"))
    return()
  }
  
  # Create new entry
  new_entry <- data.table(
    first_name = data$first_name,
    last_name = data$last_name
  )
  
  # Append new entry to global data.table
  test_data <<- rbind(test_data, new_entry)
  
  # Send success message
  res$send(list(message = "Record successfully added."))
})

# Start the server
app$start(host = "127.0.0.1", port = PORT)
