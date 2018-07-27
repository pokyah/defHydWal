#' @title summarize data for the selected period
#' @param data dataframe
#' @param meat dataframe
#' @export
dhw_summarize <- function(data, meta){
  summary <- data %>%
    group_by(sid) %>%
    summarise_at(vars(cum.norm, cum.obs), sum)

  summary <- summary %>%
    mutate(defExHyd = cum.obs - cum.norm) %>%
    mutate(ind_plu = cum.obs / cum.norm)

  summary <- summary %>%
     left_join(meta, by = "sid")

  return(summary)
}