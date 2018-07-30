shinyApp(
  ui = fluidPage(
    dateRangeInput(inputId = "dfrom_dto", label = h3("Date range"), start = "2018-01-01", end = Sys.Date(), min = "2018-01-01", max = Sys.Date() ),
    checkboxInput(inputId = "int", label = h3("Interactive report"), value = FALSE),
    sliderInput(inputId = "ip_cl", label = h3("Nombre de classes pour la carte de l'indice pluvio"), min = 3,
      max = 11, value = 6),
    sliderInput(inputId = "dh_cl", label = h3("Nombre de classes pour la carte du déficit hydrique"), min = 3,
      max = 11, value = 6),
    radioButtons(inputId = "extension", label = h3("Format"),
      choices = list(".html" = "html_document", ".pdf" = "pdf_document", ".doc/odt" = "odt_document"),
      selected = 1),
    downloadButton("report", "Generate report")
  ),
  server = function(input, output) {
    filename = "deficit_hydrique_wallonie"
    extensionInput <- reactive({
      input$extensions
    })
    output$report <- downloadHandler(
      # For PDF output, change this to "report.pdf"
      filename = filename,
      content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <- file.path(tempdir(), "report.Rmd")
        file.copy("report.Rmd", tempReport, overwrite = TRUE)

        # Set up parameters to pass to Rmd document
        params <- list(dfrom = input$dfrom_dto[1],
          dto = input$dfrom_dto[2],
          int = input$int,
          ip_cl = input$ip_cl,
          dh_cl = input$dh_cl)

        # dfrom: !r as.character("2018-05-01")
        # dto: !r as.character("2018-06-30")
        # int: !r FALSE
        # ip_cl: !r 6
        # dh_cl: !r 6
        # ern.pat: "<path_to_ernage.csv>"

        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
        rmarkdown::render(output_format = extensionInput(), tempReport, output_file = file,
          params = params,
          envir = new.env(parent = globalenv()
            )
        )
      }
    )
  }
)

