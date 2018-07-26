#' @title summarize data for the selected period
#' @param data dataframe
#' @export
dhw_summarize <- function(data){
  summary <- data %>%
    group_by(sid) %>%
    summarise_at(vars(cum.norm, cum.obs), sum)

  summary <- summary %>%
    mutate(defExHyd = cum.obs - cum.norm) %>%
    mutate(ind_plu = cum.obs / cum.norm)

  summary <- summary %>%
    left_join(st_info, by = "sid")

  return(summary)
}