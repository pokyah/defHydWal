FROM r-base:latest

MAINTAINER Thomas Goossens hello.pokyah@gmail.com

RUN apt-get update && apt-get install -y \
    sudo \
    libudunits2-dev \
    units \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libxt-dev \
    libssl-dev \
    libxml2 \
    libxml2-dev \
    gdal-bin \
    libgdal-dev

RUN R -e "install.packages(c('Rcpp', 'devtools', 'shiny', 'rmarkdown'), repos='http://cran.rstudio.com/')"

RUN R -e "devtools::install_github('pokyah/defHydWal', ref='dockerized', force=TRUE)"

# CMD ["Rscript", "-e", "defHydWal::startApp(ip='10.12.110.110.2', port=4326)"]
