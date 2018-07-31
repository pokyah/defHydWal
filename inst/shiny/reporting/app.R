shinyApp(
  ui = fluidPage(
    # App title ----
    titlePanel("Déficit hydrique en Région Wallonne"),

    tags$hr(),
    h3("Graphique du déficit hydrique à Ernage"),

    fileInput(inputId = "ernage.csv", "Choose Ernage CSV File",
      multiple = FALSE,
      accept = c("text/csv",
        "text/comma-separated-values,text/plain",
        ".csv")),
    checkboxInput(inputId = "int", label = "Interactive plot", value = FALSE),

    tags$hr(),
    h3("Cartes de l'indice pluvio et du déficit hydrique en Wallonie"),

    dateRangeInput(inputId = "dfrom_dto", label = "Date range", start = "2018-01-01", end = Sys.Date(), min = "2018-01-01", max = Sys.Date() ),

    sliderInput(inputId = "ip_cl", label = "Nombre de classes pour la carte de l'indice pluvio", min = 3,
      max = 11, value = 6),
    sliderInput(inputId = "dh_cl", label = "Nombre de classes pour la carte du déficit hydrique", min = 3,
      max = 11, value = 6),

    tags$hr(),
    h3("Génération du rapport"),

    downloadButton("report", "Generate report")
  ),
  server = function(input, output, session) {
    output$report <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      filename = "deficit_hydrique_wallonie.html",
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)

        # read the content of the csv and save it in a dataframe
        ern.df <- read.csv(input$ernage.csv$datapath, header = TRUE)
        colnames(ern.df) <- c("Année", "Mois", "Décade", "Déficit")
        ern.df$Année <- as.character(ern.df$Année)

        # Set up parameters to pass to Rmd document
        params <- list(dfrom = input$dfrom_dto[1],
          dto = input$dfrom_dto[2],
          int = input$int,
          ip_cl = input$ip_cl,
          dh_cl = input$dh_cl,
          ern.df = ern.df)

        # dfrom: !r as.character("2018-05-01")
        # dto: !r as.character("2018-06-30")
        # int: !r FALSE
        # ip_cl: !r 6
        # dh_cl: !r 6
        # ern.pat: "<path_to_ernage.csv>"

        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        withProgress(message = 'Generating Report',
          detail = 'This may take a while...', value = 0, {
            rmarkdown::render(tempReport, output_file = file,
              params = params,
              envir = new.env(parent = globalenv())
            )
          })
      }
    )
  }
)

