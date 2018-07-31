#!/usr/local/bin/R

#' @title Run the auto-reporting shiny app
#' @param port the port on which you want the app to be served
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