require(knitr)
require(Cairo)
require(cairoDevice)
require(ggplot2)
require(dplyr)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

if (!file.exists(getwd())) {
  print(sprintf("Working directory %s does not exist!", getwd()))
  # Exit the script
  stopifnot(FALSE)
}


# Append "/latex" to the current directory, to do LaTeX compilation in a subdirectory "latex"
# (Rather in the current direcotry, which contains *.Rnw templates, CSV data, etc.)
Sys.setenv(TEXINPUTS=paste0(getwd(),"/latex"),
           BIBINPUTS=paste0(getwd(),"/latex"),
           BSTINPUTS=paste0(getwd(),"/latex"))

# Assign command-line parameters
#kurss <- as.character(commandArgs(TRUE)[1])
#semestris <- as.character(commandArgs(TRUE)[2])

source("skripts.R")

options(tinytex.verbose = TRUE)

inFile <- "multidimensional-scaling.Rnw"
outFile <- "multidimensional-scaling.tex"
knitr::knit2pdf(input=inFile, output=outFile)



