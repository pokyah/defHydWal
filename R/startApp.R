#' @title Run the auto-reporting shiny app
#' @return runs the shinyApp
#' @export
startApp <- function() {
  appDir <- system.file("shiny", "reporting", package = "defHydWal")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `defHydWal`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}