# How-to use this app ?

## option 1

From within R :
1. `devtools:install_github("pokyah/defHydWal", ref = "shinyApp", force = TRUE)`
2. `defHydWal::startApp(4326)`

Note : You have the option to serve it at the desired port (you can change 4326 by another port)

## option 2

From terminal with the help of docker:
`sudo docker run --rm --net=host pokyah/defhydwal`

Note : the port is fixed at 4326

