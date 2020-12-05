# configurando mi espacio de trabajo
setwd("~/Documentos/UTEM/ICOS22020")

# Borrando las variables de entorno
rm(list = ls())

# Importando las librerias
library('rvest')
library('gdata')

# descargando la pagina yapo.cl
yapo <- read_html('https://www.yapo.cl/region_metropolitana')

# listado de productos
listadoProductos <- html_nodes(yapo, css = "#hl")


# titulos de los productos
titulos <- html_nodes(listadoProductos,".title")
textTitulos <- html_text(titulos)

for (i in 1:length(textTitulos)) {
  print(textTitulos[i])
}

# categoria
categorias <- html_nodes(listadoProductos, css = ".category")
textoCategorias <- html_text(categorias)

for (i in 1:length(textoCategorias)) {
  print(textoCategorias[i])
}

# micro estadistia
table(textoCategorias)

# comunas
comunas <- html_nodes(listadoProductos, css = '.commune')
textoComunas <- html_text(comunas)

# otra forma de recorrer una variable con for
for (textoComuna in textoComunas) {
  print(textoComuna)
}

table(textoComunas)


# precios
precios <- html_nodes(listadoProductos,css = '.price')
textoPrecios <- html_text(precios)


for (i in 1:length(textoCategorias)) {
  print("=========== item ===========")
  print(textTitulos[i])
  print(textoCategorias[i])
  print(textoComunas[i])
  print(textoPrecios[i])
}



#######################################################################################################

# [almacenando informacio 1] creacion del dataframe
todaLaInformacion <- data.frame()

for(nroPagina in 1:5){
  
  urlyapo <- paste('https://www.yapo.cl/region_metropolitana?ca=15_s&o=',nroPagina,sep = "")
  
  # descargando la pagina yapo.cl
  yapo <- read_html(urlyapo)
  
  # listado de productos
  listadoProductos <- html_nodes(yapo, css = "#hl")
  
  # listado productos individuales
  listadoIndividual <- html_nodes(listadoProductos,css = '.ad')
  
  for(producto in listadoIndividual){
    print('================== ITEMS ==================')
    
    # titulo
    titulo <- html_nodes(producto, css = '.title')
    linkProducto <- html_attr(titulo, 'href')
    print(linkProducto)
    textoTitulo <- html_text(titulo)
    print(textoTitulo)
    
    # Categoria
    categoria <- html_nodes(producto, css = '.category')
    textoCategoria <- html_text(categoria)
    print(textoCategoria)
    
    # comuna
    comuna <- html_nodes(producto, css = '.commune')
    textoComuna <- html_text(comuna)
    print(textoComuna)
    
    # Precio
    precio <- html_nodes(producto, css = '.price')
    textoPrecio <- html_text(precio)
    if(length(textoPrecio) == 0){
      textoPrecio <- NA
    } else {
      textoPrecio <- gsub("\n","",textoPrecio)
      textoPrecio <- gsub("\t","",textoPrecio)
      textoPrecio <- gsub("[$]","",textoPrecio)
      textoPrecio <- gsub("[.]","",textoPrecio)
      textoPrecio <- trim(textoPrecio)
      textoPrecio <- as.numeric(textoPrecio)
    }
    print(textoPrecio)
    
    # Obteniendo la descripcio
    subPagina <- read_html(linkProducto)
    descripcion <- html_nodes(subPagina, css = '.description > p')
    #descripcion <- html_nodes(descripcion, css = 'p')
    textoDescripcion <- html_text(descripcion)
    textoDescripcion <- gsub("\n"," ",textoDescripcion)
    textoDescripcion <- tolower(textoDescripcion)
    print(textoDescripcion)
    
    #[almacenando informacio 2] creando dataframe con los detalles
    # de cada item
    item <- data.frame(titulo = textoTitulo, categoria = textoCategoria, precio = textoPrecio, comuna = textoComuna, descripcion = textoDescripcion, link = linkProducto)
    
    #[almacenando informacio 3] almacenando la informacion del producto
    # con los datos totales
    todaLaInformacion <- rbind(todaLaInformacion,item)
    
  }
}

write.csv(todaLaInformacion,"informacionYapo.csv")


#####################################################################################################################

library(ggplot2)

# conteo comunas
ggplot(todaLaInformacion, aes( x = comuna )) +
  geom_bar(fill = "red") +
  coord_flip()

# precio en comuna
ggplot(todaLaInformacion, aes( x = comuna, y = precio )) +
  geom_point() +
  coord_flip()

# histograma precio
ggplot(todaLaInformacion, aes(x = precio )) +
  geom_histogram()


# precio en categoria
ggplot(todaLaInformacion, aes( x = categoria, y = precio )) +
  geom_point() +
  coord_flip()


# precio en comuna
ggplot(todaLaInformacion, aes( x = comuna, y = precio )) +
  geom_boxplot()

