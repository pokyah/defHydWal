#' @title filter the observed data for the period of interest and relevant stations
#' @param data dataframe
#' @param dfrom "YYYY-MM-DD"
#' @param dto "YYYY-MM-DD"
#' @return dataframe
#' @export
dhw_filter <- function(data, dfrom, dto){
  if (!is.null(data$mtime)) {
    data = data %>%
      dplyr::filter(!is.na(plu))
  }

  if (!is.null(data$plu)) {
    data = data %>%
      dplyr::mutate(yday = lubridate::yday(as.Date.POSIXct(mtime)))
  }
  data.fil <- data %>%
    dplyr::filter(!is.na(to)) %>%
    dplyr::filter(!is.na(from)) %>%
    dplyr::filter(as.Date(from) == min(as.Date(unique(data$from)), na.rm = TRUE)) %>%
    dplyr::filter(network_name == "pameseb") %>%
    dplyr::filter(type_name != "Sencrop") %>%
    dplyr::filter(state == "Ok") %>%
    dplyr::filter(yday >= lubridate::yday(as.Date(dfrom))) %>%
    dplyr::filter(yday <= lubridate::yday(as.Date(dto))) %>%
    dplyr::filter(!is.na(poste)) %>%
    dplyr::filter(!is.na(longitude)) %>%
    dplyr::filter(!is.na(latitude))

  return(data.fil)
}

#date = as.Date.POSIXct(mtime)
#dplyr::filter(!is.na(plu)) %>%