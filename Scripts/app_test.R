library(ambiorix)

PORT <- 3000L

app <- Ambiorix$new(port = PORT)

app$get("/", \(req, res){
  
  # get list of datasets
  datasets <- as.data.frame(data(package = "datasets")$results)
  datasets <- subset(datasets, !grepl("[[:space:]]", datasets$Item)) 
  
  # add links
  datasets$Endpoint <- sprintf(
    "http://127.0.0.1:%s/dataset/%s", PORT, datasets$Item
  )
  datasets$Endpoint <- sapply(datasets$Endpoint, URLencode)
  res$json(datasets[, c("Item", "Title", "Endpoint")])
})

app$get("/dataset/:set", \(req, res){
  res$json(
    get(req$params$set)
  )
})

app$start(host = "127.0.0.1", port = PORT)
