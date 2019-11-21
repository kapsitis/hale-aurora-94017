library(jsonlite)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df <- read.table("RawData-emotions-shapes.csv", header=TRUE,sep=",")

emotions <- c("Prieks",
              "Milestiba",
              "Apmierinajums",
              "Mundrums",
              "Ceriba",
              "Sajusminajums",
              "Bazas",
              "Skumjas",
              "Riebums",
              "Dusmas",
              "Vaina",
              "Bailes")
## Matching with shapes starts on 8th column
## Skip first data row with shape numbers... 

# Not counting header (and the first row with shape numbers)
# only 28 rows have full emotion-shape matching data
rowRange <- 2:29
# First 10 columns do not have emotion-shape matching data
colOffset <- 10
nEmotions <- length(emotions)
nShapes <- 17

respID <- character(0)
emotion <- character(0)
shape <- character(0)
for (row in rowRange) {
  for (ii in 1:nEmotions) {
    for (jj in 1:nShapes) {
      colN <- colOffset + (ii-1)*nShapes + jj
      if (!is.na(df[row,colN]) & df[row,colN] == 1) {
        respID <- c(respID,sprintf("%s",df$Response.ID[row]))
        emotion <- c(emotion,emotions[ii])
        shape <- c(shape,sprintf("%d",jj))
      }
    }
  }
}

matchDF <- data.frame(respID = respID, emotion = emotion, shape = shape)
exportJson <- toJSON(matchDF, matrix="rowmajor", pretty=TRUE)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
write(exportJson, file="match_emo_shp.json")

# match_shp_ranges
respID <- character(0)
shape <- character(0)
ranges <- character(0)
rLaimNelaim <- character(0)
rCerIzmis <- character(0)
rUztrMier <- character(0)
rBrivIerob <- character(0)
rApmAizkait <- character(0)
rInterGarl <- character(0)
rPatNepat <- character(0)

rowRange <- 2:58
colOffset <- 216

for (row in rowRange) {
  for (jj in 1:nShapes) {
    colN1 <- colOffset + (jj-1)*7 + 1
    
    if (!is.na(df[row,colN1])) {
      #print(sprintf("frst = %d; colN = %d", df[row,colN], colN))
      theID <- sprintf("%s",df$Response.ID[row])
      if (theID == "NA") {
        theID <- sprintf("r%d",(row+1))
      }
      respID <- c(respID,theID)
      
      shape <- c(shape,sprintf("%d",jj))
      ranges <- c(ranges, sprintf("%s,%s,%s,%s,%s,%s,%s",
                                  as.character(df[row,colN1]),
                                  as.character(df[row,colN1+1]),
                                  as.character(df[row,colN1+2]),
                                  as.character(df[row,colN1+3]),
                                  as.character(df[row,colN1+4]),
                                  as.character(df[row,colN1+5]),
                                  as.character(df[row,colN1+6])))
      rLaimNelaim <- c(rLaimNelaim,as.character(df[row,colN1]))
      rCerIzmis <- c(rCerIzmis,as.character(df[row,colN1+1]))
      rUztrMier <- c(rUztrMier,as.character(df[row,colN1+2]))
      rBrivIerob <- c(rBrivIerob,as.character(df[row,colN1+3]))
      rApmAizkait <- c(rApmAizkait,as.character(df[row,colN1+4]))
      rInterGarl <- c(rInterGarl,as.character(df[row,colN1+5]))
      rPatNepat <- c(rPatNepat,as.character(df[row,colN1+6]))
    }
  }
}


rangeDF <- data.frame(respID = respID, 
                      shape = shape, 
                      ranges = ranges,
                      rLaimNelaim = rLaimNelaim,
                      rCerIzmis=rCerIzmis,
                      rUztrMier = rUztrMier,
                      rBrivIerob = rBrivIerob,
                      rApmAizkait = rApmAizkait,
                      rInterGarl = rInterGarl,
                      rPatNepat = rPatNepat)
exportJson <- toJSON(rangeDF, matrix="rowmajor", pretty=TRUE)
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
write(exportJson, file="match_shp_ranges.json")






