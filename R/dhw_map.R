#' @title make the Pameseb deficit hydrique df a sp
#' @param data sp dataframe
#' @export
dhw_as.spatial <- function(data){
  sp::coordinates(data) <- ~longitude+latitude
  raster::crs(data) <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") #we know it from API meta
  data <- sp::spTransform(data, sp::CRS("+proj=lcc +lat_1=49.83333333333334 +lat_2=51.16666666666666 +lat_0=50.797815 +lon_0=4.359215833333333 +x_0=649328 +y_0=665262 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs "))
}

#' @title spatialize the Pameseb deficit hydrique with IDW algo
#' @param data sp dataframe
#' @param param cahracter
#' @return sp dataframe
#' @export
dhw_idw <- function(data, param, grid){
  f <- paste0(param,"~1")
  f <- as.formula(f)
  idw = gstat::idw(f, data, grid)
  return(idw)
}

#' @title make the static map of the deficit hydrique
#' @param data sp dataframe
#' @return dataframe
#' @export
dhw_2_ggmap <- function(data){
  sp::gridded(data) = TRUE
  data = as(data, "SpatialGridDataFrame")
  data = as.data.frame(data)
  data = dplyr::rename(data, coords.x1 = x, coords.x2 = y)
  return(data)
}



