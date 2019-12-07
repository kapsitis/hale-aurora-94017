library(magrittr)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

getSDMatrix2 <- function() {
  rangeDF2 <- read.table("match_shp_ranges_raw2.csv", header=TRUE,sep=",")
  pictureIDs <- c("1","6", "7", "8", "9", "10", "11", "13", "14", "15", "16", "17")
  scaleIDs <- c("rLaimNelaim", "rCerIzmis", "rUztrMier", "rBrivIerob", "rApmAizkait", "rInterGarl", "rPatNepat")
  mat <- matrix(rep(0,times=12*7), nrow = 12, ncol = 7, dimnames = list(pictureIDs,scaleIDs))
  
  #remove.factors(rangeDF2)
  #for (scaleID in scaleIDs) {
  #  levels(droplevels(rangeDF2[[scaleID]]))
  #}
  
  for (pictureID in pictureIDs) {
    for (scaleID in scaleIDs) {
      mat[pictureID, scaleID] <- sd(as.numeric(as.character(
        rangeDF2[rangeDF2$shape==as.numeric(pictureID),scaleID])))
    }
  }
  
  return(mat)
}

#png(file = "heatmap-sd-shape-intervals-dataset2.png", bg = "transparent", type="cairo", units="in", width=5,  height=4, pointsize=12, res=96)
#pheatmap(t(mat), treeheight_row = 0, treeheight_col = 0, cluster_rows=F, cluster_cols=F)
#dev.off()

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

getSDMatrix1 <- function() {
  rangeDF1 <- read.table("match_shp_ranges_raw1.csv", header=TRUE,sep=",")
  pictureIDs <- c("1","2","3","4","5","6","7","8","9","10",
                  "11","13","14","15","16","17")
  scaleIDs <- c("rLaimNelaim", "rCerIzmis", "rUztrMier", "rBrivIerob", "rApmAizkait", "rInterGarl", "rPatNepat")
  mat <- matrix(rep(0,times=16*7), nrow = 16, 
                ncol = 7, dimnames = list(pictureIDs,scaleIDs))

  for (pictureID in pictureIDs) {
    for (scaleID in scaleIDs) {
      mat[pictureID, scaleID] <- sd(as.numeric(as.character(
        rangeDF1[rangeDF1$shape==as.numeric(pictureID),scaleID])))
    }
  }
  
  return(mat)
}

getMeanMatrix1 <- function() {
  rangeDF1 <- read.table("match_shp_ranges_raw1.csv", header=TRUE,sep=",")
  pictureIDs <- c("1","2","3","4","5","6","7","8","9","10",
                  "11","13","14","15","16","17")
  scaleIDs <- c("rLaimNelaim", "rCerIzmis", "rUztrMier", "rBrivIerob", "rApmAizkait", "rInterGarl", "rPatNepat")
  mat <- matrix(rep(0,times=16*7), nrow = 16, 
                ncol = 7, dimnames = list(pictureIDs,scaleIDs))
  
  for (pictureID in pictureIDs) {
    for (scaleID in scaleIDs) {
      mat[pictureID, scaleID] <- mean(as.numeric(as.character(
        rangeDF1[rangeDF1$shape==as.numeric(pictureID),scaleID])))
    }
  }
  
  return(mat)
}



getMeanMatrix2 <- function() {
  rangeDF2 <- read.table("match_shp_ranges_raw2.csv", header=TRUE,sep=",")
  pictureIDs <- c("1","6","7","8","9","10",
                  "11","13","14","15","16","17")
  scaleIDs <- c("rLaimNelaim", "rCerIzmis", "rUztrMier", "rBrivIerob", "rApmAizkait", "rInterGarl", "rPatNepat")
  mat <- matrix(rep(0,times=12*7), nrow = 12, 
                ncol = 7, dimnames = list(pictureIDs,scaleIDs))
  
  for (pictureID in pictureIDs) {
    for (scaleID in scaleIDs) {
      mat[pictureID, scaleID] <- mean(as.numeric(as.character(
        rangeDF2[rangeDF2$shape==as.numeric(pictureID),scaleID])))
    }
  }
  
  return(mat)
}


getMeanCorMatrix <- function() {
  meanMat1 <- getMeanMatrix1()

  corMat <- matrix(rep(0,times=7*7), nrow = 7, 
                 ncol = 7, dimnames = list(paste0("E_",1:7),paste0("E_",1:7)))
  for (i in 1:7) {
    for (j in 1:7) {
      corMat[i,j] <- cor(meanMat1[,i], meanMat1[,j])
    }
  }
  return(corMat)
}


getDistanceMatrix <- function() {
  meanMat1 <- getMeanMatrix1()
  ss <- c(1:11,13:17)
  result <- matrix(rep(0,times=16*16), nrow = 16, 
                   ncol = 16, dimnames = list(paste0("S_",ss),paste0("S_",ss)))
  for (i in 1:16) {
    for (j in 1:16) {
      result[i,j] <- sqrt(sum((meanMat1[i,] - meanMat1[j,])^2))
    }
  }
  return(result)
}

getDistanceMatrix2 <- function() {
  meanMat2 <- getMeanMatrix2()
  ss <- c(1, 6:11,13:17)
  result <- matrix(rep(0,times=12*12), nrow = 12, 
                   ncol = 12, dimnames = list(paste0("S_",ss),paste0("S_",ss)))
  for (i in 1:12) {
    for (j in 1:12) {
      result[i,j] <- sqrt(sum((meanMat2[i,] - meanMat2[j,])^2))
    }
  }
  return(result)
}


