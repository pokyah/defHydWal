#!/usr/local/bin/R

#' @title Run the auto-reporting shiny app
#' @return runs the shinyApp
#' @export
startApp <- function(port=4326) {
  appDir <- system.file("shiny", "reporting", package = "defHydWal")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `defHydWal`.", call. = FALSE)
  }
  options(shiny.port = port)
  shiny::runApp(appDir, display.mode = "normal")
}