pkgTest <- function(x)
{
  if (!require(x,character.only = TRUE))
  {
    install.packages(x,dep=TRUE,repos = "http://cran.r-project.org")
    if(!require(x,character.only = TRUE)) stop("Package not found")
  }
}


packages = c(
  "R6"
)
install.packages(c("devtools","rmarkdown"))
devtools::install_github("hadley/dplyr", build_vignettes = FALSE)
devtools::install_github("rforge/rgl", subdir="pkg/rgl")
for (i in 1:length(packages)){
  pkgTest(packages[i])
}
install.packages("plotly")
