#' @title plot the deficit hydrique from Ernage data for the period of interest
#' @param data dataframe
#' @param int boolean
#' @import ggplot2
#' @return ggplot graph
#' @export
dhw_plot <- function(data, int){
  if (length(unique(data$Année)) == 2) {
    colors = c("#4daf4a", "#e41a1c")
  } else {
    colors = c("#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#e41a1c")
  }
  plot = ggplot(data, aes(x = Décade, y = Déficit)) +
    geom_line(aes(color = Année), na.rm = TRUE) +
    geom_point(aes(color = Année, shape = Année), na.rm = TRUE) +
    scale_color_manual(values = colors) +
    scale_x_continuous(breaks = round(seq(0, 40, by = 4)), limits = c(0,40)) +
    scale_y_continuous(breaks = round(seq(-160,0, by = 20)), limits = c(-160,0)) +
    ylab("Déficit hydrique (mm)") +
    ggtitle("Déficit hydrique (Station Ernage, Belgique)") +
    theme(panel.background = element_rect(fill = NA),
      panel.border = element_rect(color = "black", fill = NA),
      legend.justification = c(0, 0),
      legend.position = c(0.01, 0.02),
      legend.background = element_rect(color = "black"))
  if (int == FALSE) {
    return(plot)
  }else {
    return(plotly::ggplotly(plot))
  }
}