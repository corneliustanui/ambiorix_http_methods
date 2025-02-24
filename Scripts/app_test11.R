# app.R
library(ambiorix)
library(htmltools)

PORT <- 3000L

app <- Ambiorix$new(port = PORT)

app$get("/", \(req, res){
  
  # form
  # sends to /submit
  form <- tagList(
    tags$form(
      action = "/submit", 
      enctype = "multipart/form-data", 
      method = "POST",
      p(
        tags$label(`for` = "first_name", "First Name"),
        tags$input(type = "text", name = "first_name")
      ),
      tags$input(type = "submit")
    )
  )
  
  res$send(form)
})

app$post("/submit", \(req, res){
  body <- parse_multipart(req)
  res$send(h1("Your name is", body$first_name))
})

app$start(host = "127.0.0.1", port = PORT)
