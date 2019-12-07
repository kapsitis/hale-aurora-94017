library(knitr)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("build-utilities.R")
rmarkdown::render("multidimensional-scaling.Rmd", output_file="multidimensional-scaling.html", encoding = "UTF-8")

#############################
## Some code chunks to generate separate image files
#############################

#png(file = "heatmap-sd-shape-intervals-dataset2.png", bg = "transparent", type="cairo", units="in", width=5,  height=4, pointsize=12, res=96)
#pheatmap(t(mat), treeheight_row = 0, treeheight_col = 0, cluster_rows=F, cluster_cols=F)
#dev.off()
