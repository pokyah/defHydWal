#####
# ERNAGE déficit hydrique

deficit_hydrique.df <- read.csv("./external-data/graph_ernage/data_hydr2-vf_DR.csv", header = TRUE)
colnames(deficit_hydrique.df) <- c("Année", "Mois", "Décade", "Déficit")
deficit_hydrique.df$Année <- as.character(deficit_hydrique.df$Année)

ernage.all_y <- subset(deficit_hydrique.df, Année %in% c("1959", "1976", "1996", "2017", "2018"))
ernage.two_y <- subset(deficit_hydrique.df, Année %in% c("1976","2018"))

devtools::use_data(ernage.all_y)
devtools::use_data(ernage.two_y)

#####
# WALLONIA borders (for EPSG CRS and proj4 see epsg.io)
wallonia.sp <- raster::getData('GADM', country = "BE ", level = 2)
wallonia.sp <- subset(wallonia.sp, NAME_1 == "Wallonie")
wallonia.sp <- sp::spTransform(wallonia.sp, sp::CRS("+proj=lcc +lat_1=49.83333333333334 +lat_2=51.16666666666666 +lat_0=50.797815 +lon_0=4.359215833333333 +x_0=649328 +y_0=665262 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs "))
wallonia.sf = sf::st_as_sf(wallonia.sp)

devtools::use_data(wallonia.sf)
devtools::use_data(wallonia.sp)

# WALLONIA interpolation grid - https://stackoverflow.com/questions/43436466/create-grid-in-r-for-kriging-in-gstat/43444232
grd = sp::makegrid(x = wallonia.sp, cellsize = 250,
  pretty = TRUE)
colnames(grd) <- c('x','y')
grd_pts = sp::SpatialPoints(coords = grd,
  proj4string = sp::CRS(sp::proj4string(wallonia.sp)))
grid.sp = grd_pts[wallonia.sp, ]
grid.df = as.data.frame(grid.sp)
grid.grid <- grid.sp
sp::gridded(grid.grid) = TRUE
grid.sf = sf::st_as_sf(grid.sp)

devtools::use_data(grid.sf)
devtools::use_data(grid.sp)
devtools::use_data(grid.grid)

#####
# PAMESEB normal rainfall data from API
plu.norm <- agrometAPI::get_from_agromet_API(table_name = "get_tmy", sensors = "plu_sum", month_day = "all")
plu.norm <- agrometAPI::prepare_agromet_API_data.fun(plu.norm, table_name = "get_tmy")
cum.norm <- plu.norm %>% dplyr::rename(yday = day_of_year) %>%
  dplyr::rename(cum.norm = plu_sum) %>%
  dplyr::filter(!is.na(poste))

devtools::use_data(cum.norm, overwrite = TRUE)


#####
# PAMESEB observed rainfall data from API
# a single API call for the whole period gives a 504 timeout errorso we split the calls by months
plu.obs.jan <- agrometAPI::get_from_agromet_API(dfrom = "2018-01-01", dto = "2018-01-31", sensors = "plu")
plu.obs.jan <- agrometAPI::prepare_agromet_API_data.fun(plu.obs.jan)
plu.obs.feb <- agrometAPI::get_from_agromet_API(dfrom = "2018-02-01", dto = "2018-01-28", sensors = "plu")
plu.obs.feb <- agrometAPI::prepare_agromet_API_data.fun(plu.obs.feb)
plu.obs.mar <- agrometAPI::get_from_agromet_API(dfrom = "2018-03-01", dto = "2018-03-31", sensors = "plu")
plu.obs.mar <- agrometAPI::prepare_agromet_API_data.fun(plu.obs.mar)
plu.obs.apr <- agrometAPI::get_from_agromet_API(dfrom = "2018-04-01", dto = "2018-04-30", sensors = "plu")
plu.obs.apr <- agrometAPI::prepare_agromet_API_data.fun(plu.obs.apr)
plu.obs.may <- agrometAPI::get_from_agromet_API(dfrom = "2018-05-01", dto = "2018-05-31", sensors = "plu")
plu.obs.may <- agrometAPI::prepare_agromet_API_data.fun(plu.obs.may)
plu.obs.jun <- agrometAPI::get_from_agromet_API(dfrom = "2018-06-01", dto = "2018-06-30", sensors = "plu")
plu.obs.jun <- agrometAPI::prepare_agromet_API_data.fun(plu.obs.jun)

plu.obs <- bind_rows((list(plu.obs.jan,
  plu.obs.feb,
  plu.obs.mar,
  plu.obs.apr,
  plu.obs.may,
  plu.obs.jun)))

devtools::use_data(plu.obs, overwrite = TRUE)

#####
# Pameseb stations metadata
st_info <- plu.obs %>%
  filter(mtime == unique(plu.obs$mtime)[1]) %>%
  dplyr::select(one_of(c(
    "sid", "poste",
    "longitude", "latitude",
    "altitude"))
  )
devtools::use_data(st_info)
