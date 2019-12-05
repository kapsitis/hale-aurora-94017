library(jsonlite)

###################################################################
## Produce "match_emo_shp.json"
## Every emotion is mapped to 1-3 geometric shapes.
###################################################################

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
write(exportJson, file="match_emo_shp1.json")





###################################################################
## Produce "match_shp_ranges_raw.json"
## Every shape is mapped to 7 different ranges of opposite emotions. 
###################################################################

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
write(exportJson, file="match_shp_ranges_raw1.json")

write.table(rangeDF, file="match_shp_ranges_raw1.csv", quote = TRUE,  col.names=TRUE, sep=",")





###################################################################
## Produce "match_aesth_shp.json"
## Every shape is mapped to 1-3 aesthetical concepts.
###################################################################

aesthetics <- c("Kartiga","Patikama","Simetriska","Originala",
                "Sarezgita", "Iespaidiga", "Radosa","Mulsinosa",
                "Baudama","Nepatikama")
rowRange <- 2:29
# First 10 columns do not have emotion-shape matching data
colOffset <- 336
nAesthetics <- length(aesthetics)
nShapes <- 17

respID <- character(0)
aesth <- character(0)
shape <- character(0)
for (row in rowRange) {
  for (jj in 1:nShapes) {
    for (ii in 1:nAesthetics) {
      colN <- colOffset + (jj-1)*(nAesthetics+1) + ii
      if (!is.na(df[row,colN]) & df[row,colN] == 1) {
        respID <- c(respID,sprintf("%s",df$Response.ID[row]))
        aesth <- c(aesth,aesthetics[ii])
        shape <- c(shape,sprintf("%d",jj))
      }
    }
  }
}

aesthDF <- data.frame(respID = respID, aesth = aesth, shape = shape)
exportJson <- toJSON(aesthDF, matrix="rowmajor", pretty=TRUE)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
write(exportJson, file="match_aesth_shp1.json")





###################################################################
## Produce "match_shp_emo2.json"
## Every shape is mapped to 1-3 aesthetical concepts.
###################################################################

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
df <- read.table("RawData-shapes-emotions.csv", header=TRUE,sep=",")

rowRange <- 2:30
# First 10 columns do not have emotion-shape matching data
colOffset <- 18
nEmotions <- length(emotions)
nShapes <- 17

respID <- character(0)
emotion <- character(0)
shape <- character(0)
for (row in rowRange) {
  for (ii in 1:nShapes) {
    for (jj in 1:nEmotions) {
      colN <- colOffset + (ii-1)*(nEmotions + 1) + jj
      if (!is.na(df[row,colN]) & df[row,colN] == 1) {
        respID <- c(respID,sprintf("%s",df$Response.ID[row]))
        shape <- c(shape,sprintf("%d",ii))
        emotion <- c(emotion,emotions[jj])
      }
    }
  }
}

shpEmoDF <- data.frame(respID = respID, shape = shape, emotion = emotion)
exportJson <- toJSON(shpEmoDF, matrix="rowmajor", pretty=TRUE)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
write(exportJson, file="match_shp_emo2.json")


###################################################################
## Produce "match_aesth_shp.json"
## Every shape is mapped to 1-3 aesthetical concepts.
###################################################################

rowRange <- 2:30
# First 10 columns do not have emotion-shape matching data
colOffset <- 241

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



for (row in rowRange) {
  for (jj in 1:(nShapes-4)) {
    colN1 <- colOffset + (jj-1)*7 + 1
    
    rrr <- as.character(df[row,colN1])
    
    if (!is.na(df[row,colN1])) {
      
      print(sprintf("*** (%d,%d), frst = %s; colN = %d", row,jj, rrr, colN1))
      theID <- sprintf("%s",df$Response.ID[row])
      if (theID == "NA") {
        theID <- sprintf("r%d",(row+1))
      }
      respID <- c(respID,theID)
      
      jjjj <- jj
      if (jjjj > 1) {
        jjjj <- jjjj+4
      }
      shape <- c(shape,sprintf("%d",jjjj))
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


rangeDF2 <- data.frame(respID = respID, 
                      shape = shape, 
                      ranges = ranges,
                      rLaimNelaim = rLaimNelaim,
                      rCerIzmis=rCerIzmis,
                      rUztrMier = rUztrMier,
                      rBrivIerob = rBrivIerob,
                      rApmAizkait = rApmAizkait,
                      rInterGarl = rInterGarl,
                      rPatNepat = rPatNepat)
exportJson2 <- toJSON(rangeDF2, matrix="rowmajor", pretty=TRUE)
write(exportJson2, file="match_shp_ranges_raw2.json")

write.table(rangeDF2, file="match_shp_ranges_raw2.csv", quote = TRUE,  col.names=TRUE, sep=",")






##########################################
## HEATMAP
##########################################

pictureIDs <- c("1","6", "7", "8", "9", "10", "11", "13", "14", "15", "16", "17")
scaleIDs <- c("rLaimNelaim", "rCerIzmis", "rUztrMier", "rBrivIerob", "rApmAizkait", "rInterGarl", "rPatNepat")
mat <- matrix(rep(0,times=12*7), nrow = 12, ncol = 7, dimnames = list(pictureIDs,scaleIDs))

mat[1,1] = 30

remove.factors(rangeDF2)

for (pictureID in pictureIDs) {
  for (scaleID in scaleIDs) {
    mat[scaleID, pictureID] <- sd(as.numeric(as.character(
      rangeDF2[rangeDF2$shape==as.numeric(pictureID),scaleID])))
  }
}

png(file = "heatmap-sd-shape-intervals-dataset2.png", bg = "transparent", type="cairo", units="in", width=5,  height=4, pointsize=12, res=96)
pheatmap(t(mat), treeheight_row = 0, treeheight_col = 0, cluster_rows=F, cluster_cols=F)
dev.off()




