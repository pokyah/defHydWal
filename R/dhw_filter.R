#' @title filter the data for the period of interest
#' @import dplyr
#' @param data dataframe
#' @param dfrom "YYYY-MM-DD"
#' @param dto "YYYY-MM-DD"
#' @return dataframe
#' @export
dhw_filter <- function(data, dfrom, dto){
  data.fil <- data %>%
    dplyr::filter(date >= as.Date(dfrom)) %>%
    dplyr::filter(date <= as.Date(dto))
  return(data.fil)
}