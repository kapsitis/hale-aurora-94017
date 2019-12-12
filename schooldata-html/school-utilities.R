require(Unicode)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

skolaPasvaldiba <- read.table(
  file="skola-pasvaldiba.csv", 
  sep=",",
  header=TRUE,
  row.names=NULL,  
  fileEncoding="UTF-8", 
  stringsAsFactors = FALSE)

sp <- list()
for(i in 1:length(skolaPasvaldiba$School)) {
  aa <- as.vector(skolaPasvaldiba$School[i])
  bb <- as.vector(skolaPasvaldiba$Municipality[i])
  sp[[aa]] <- bb
}


getMunicipality <- function(school) {
  if (!(school %in% names(sp))) {
    spacedSchool <- gsub("\\.", ". ", school)
    if (!(spacedSchool %in% names(sp))) {
      return("NNN")
    } else {
      return(sp[[spacedSchool]])
    }  
  } else {
    return(sp[[school]])
  }
}


getAllResults <- function(yyyy) {
  fullPath <- sprintf("ao-results-%d.csv",yyyy)
  df <- read.table(fullPath, 
                   header=TRUE,
                   sep=",", 
                   encoding="UTF-8", 
                   stringsAsFactors=FALSE)
}

getExtResults <- function(yyyy) {
  result <- getAllResults(yyyy)
#  municipalities <- as.vector(sapply(as.vector(results$School), getMunicipality))
#  results$Municipality <- municipalities
  skolaPasvaldiba <- read.table(
    file="skola-pasvaldiba.csv", 
    sep=",",
    header=TRUE,
    encoding="UTF-8", 
    stringsAsFactors=FALSE)
  
  df<-merge(x=result,y=skolaPasvaldiba,by="School",all.x=TRUE)
  return(df)
}


utf8ToIntVector <- function(arg) {
  return(as.vector(sapply(arg,utf8ToInt)))
}


#' @title getGender
#' @description Find gender by firstname
#' @details Given the firstname, return the gender of the person (Male/Female)
#' @aliases getGender
#' @author Kalvis Apsitis
#' @export getGender
#' @import Unicode
#' @param name A vector of names, represented in Unicode
#' @return Either "Male" or "Female"
#' @examples
#' getGender("Zane")
#' getGender(c("Suns", "Kaķis"))
getGender <- function(name) {
  # Drop leading, trailing spaces, 2nd names, etc.
  firstName <- sub(" *([^ ]+) *.*", "\\1",name)
  isMale <- (name == "Patrika Ralfs" |
               firstName == "Adam" |
               firstName == "Alexander" |
               firstName == "Alexey" |
               firstName == "Aliaksandr" |
               firstName == "Andrey" |
               firstName == "Anton" |
               firstName == "Artem" |
               firstName == "Bruno" |
               grepl(".iro$", firstName) |
               firstName == "Dmitry" |
               firstName == "Dmytro" |
               firstName == "Guoyongyan" |
               firstName == "Gvido" |
               firstName == "Hugo" |
               firstName == "Iļja" |
               firstName == "Ivo" |
               firstName == "Karthik" |
               firstName == "Laurent" |
               firstName == "Lev" |
               firstName == "Luka" |
               firstName == "Nikita" |
               firstName == "Ņikita" |
               firstName == "Nikolay" |
               firstName =="Oleksandr" |
               firstName == "Oto" |
               firstName == "Otto" |
               firstName == "Raivo" |
               firstName == "Savva" |
               firstName == "Uko" |
               firstName == "Vladimir")
  #  isMale <- isMale & (!(firstName == "Nelli" |
  #               firstName == "Fani" |
  #               firstName == "Romi"))
  isMale <- isMale | grepl("[sš]$", firstName)
  nch <- nchar(firstName)
  lst <- substr(firstName,nch,nch)
  isMale <- isMale | (lst == "š") | (as.u_char(utf8ToIntVector(lst)) == "U+009A")
  result <- sapply(isMale, function(x) { if(x) { return("Male") } else {return("Female")} })
  return(result)
}


letterFromUnicode <- function(arg) {
  if (arg == "\u0100") return("A")
  if (arg == "\u010C") return("C")
  if (arg == "\u0112") return("E")
  if (arg == "\u0122") return("G")
  if (arg == "\u012A") return("I")
  if (arg == "\u0136") return("K")
  if (arg == "\u013B") return("L")
  if (arg == "\u0145") return("N")
  if (arg == "\u0160") return("S")
  if (arg == "\u016A") return("U")
  if (arg == "\u017D") return("Z")  
  if (arg == "\u0101") return("a")
  if (arg == "\u010D") return("c")
  if (arg == "\u0113") return("e")
  if (arg == "\u01E7") return("g")
  if (arg == "\u012B") return("i")
  if (arg == "\u0137") return("k")
  if (arg == "\u013C") return("l")
  if (arg == "\u0146") return("n")
  if (arg == "\u0161") return("s")
  if (arg == "\u016B") return("u")
  if (arg == "\u017E") return("z")
  return(arg)
}

strFromUnicode <- function(arg) {
  xx <- as.vector(strsplit(arg,"")[[1]])
  yy <- as.vector(sapply(xx, letterFromUnicode))
  return(paste(yy,sep="",collapse=""))
}






makeTables <- function() {
  years <- 2008:2019
  mParticipants <- numeric(0)
  fParticipants <- numeric(0)
  tParticipants <- numeric(0)
  
  for (yyyy in years) {
    df <- getAllResults(yyyy)
    firstnames <- as.character(df$Firstname)
    genders <- getGender(df$Firstname)
    mParticipants <- c(mParticipants, sum(genders == "Male"))
    fParticipants <- c(fParticipants, sum(genders == "Female"))
    tParticipants <- c(tParticipants, length(genders))
  }
  participantsByGender <- data.frame(year = years, 
                                     males = mParticipants, 
                                     females = fParticipants, 
                                     total = tParticipants)
    
  #  testgenders <- data.frame(ff = firstnames, gg = genders)
  write.table(participantsByGender, file="participantsByGender.csv", quote = TRUE,  col.names=TRUE, sep=",")
}

#imodf <- read.table("imo-results.csv", header=TRUE,sep=",", encoding="UTF-8", stringsAsFactors=FALSE)

getParticipantsByGender <- function() {
  result <- read.table("participantsByGender.csv", header=TRUE,sep=",", encoding="UTF-8", stringsAsFactors=FALSE)
  ratioF <- round(100*result$females/result$total, digits=2)
  ratioM <- round(100*result$males/result$total, digits=2)
  
  result$males <- sprintf("%d (%4.2f%%)", result$males, ratioM)
  result$females <- sprintf("%d (%4.2f%%)", result$females, ratioF)

  result <- result[4:12,]
  
  schoolAge <- c(240382, 229589, 224249, 221753, 222829, 225929, 228273, 229630, 230048)
  result$schoolAge <- round(schoolAge*(8/12))
  
  result$activity <- sprintf("%4.2f%%", round(100*result$total/result$schoolAge, digits=2))
  rownames(result) <- 2011:2019
  
  return(result)
  
  
}


getParticipantsStacked <- function() {
  participantsByGender <-  read.table("participantsByGender.csv", header=TRUE,sep=",", encoding="UTF-8", stringsAsFactors=FALSE)
  yy <- c(2008:2019, 2008:2019)
  tt <- c(participantsByGender$males, participantsByGender$females)
  gg <- c(rep("F", times=12), rep("M", times="12"))
  result <- data.frame(year = yy, total = tt, gender =gg)
  return(result)
}


#require(dplyr)
#newDF <- getAllResults(2019)
#newDF$Grade[newDF$Grade < 5] <- 5
#result <- newDF %>% count(Grade)


