#' @title add data for days beyond 30 june 2018
#' @param dto "YYYY-MM-DD"
#' @return dataframe
#' @export
dhw_add_days <- function(dto, data){
  add <- agrometAPI::get_from_agromet_API(dfrom = "2018-07-01", dto = dto, sensors = "plu")
  add <- agrometAPI::prepare_agromet_API_data.fun(add)
  data <- dplyr::bind_rows(data, add)
  return(data)
}

#' @title compute the daily observed cums for the relevant stations
#' @param data dataframe
#' @return dataframe
#' @import dplyr
#' @export
dhw_obs.cums <- function(data){
  # Filtering observations to keep only the useful ones and adding daily rainfall cumuls column
  cums <- data %>%
    filter(from <= min(plu.obs$from, na.rm = TRUE)) %>%
    group_by(sid, yday) %>%
    summarise(cum.obs = sum(plu, na.rm = TRUE))
  return(cums)
}

#' @title join the normal and observed daily rainfall cumuls
#' @param obs dataframe
#' @param norm dataframe
#' @return dataframe
#' @import dplyr
#' @export
dhw_join_cums <- function(obs, norm){
  data <- obs %>% dplyr::left_join(
    dplyr::select(norm, one_of(c("cum.norm", "yday", "sid"))), by = c("yday","sid"))
  return(data)
}


