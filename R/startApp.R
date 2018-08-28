#' @title Run the auto-reporting shiny app
#' @param port the port on which you want the app to be served
#' @return runs the shinyApp
#' @export
startApp <- function(port=4326, ip="127.0.0.1") {
  appDir <- system.file("shiny", "reporting", package = "defHydWal")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `defHydWal`.", call. = FALSE)
  }
  options(shiny.port = port)
  options(shiny.host = ip)
  shiny::runApp(appDir, display.mode = "normal")
}
