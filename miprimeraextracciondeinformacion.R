setwd("~/Documentos/UTEM/ICOS22020")
# borrando las variables de entorno
rm(list = ls())

# instalando Rvest
#install.packages("rvest")
#install.packages("gdata")

# implementar libreria rvest
library('rvest')
library('gdata')

############################
#### Leyendo pagina web ####

mipagina <- read_html('index.html')




################################################
#### extrae contenido de la pagina completa ####
textodepagina <- html_text(mipagina)
print(textodepagina)

# Seleccionando un elemto en particular con xpath
h5 <- html_nodes(mipagina,xpath = '/html/body/div[2]/h5')
textoh5 <- html_text(h5)
print(textoh5)

# Seleccionar un elemento con CSS camino largo y seguro
fondoblanco <- html_nodes(mipagina, css = '.fondoblanco')
textodefondoblanco <- html_text(fondoblanco)
print(textodefondoblanco)

cssh5 <- html_nodes(fondoblanco,css = 'h5')
textocssh5 <- html_text(cssh5)
print(textocssh5)

# Seleccionando un elemento con CSS camino corto y con posibles piedras
cssh5 <- html_nodes(mipagina, css = ".fondoblanco > h5")
textocssh5 <- html_text(cssh5)
print(textocssh5)



############################
#### inventando locuras ####

# todo el texto de fondoblanco
fondoblanco <- html_nodes(mipagina, css = '.fondoblanco')
textodefondoblanco <- html_text(fondoblanco)
print(textodefondoblanco)

vectorFrases <- c() 

cssh5 <- html_nodes(mipagina, css = ".fondoblanco > h5")
textocssh5 <- html_text(cssh5)

vectorFrases <- c(vectorFrases,textocssh5)

cssa <- html_nodes(mipagina, css = ".fondoblanco > a")
textocssa <- html_text(cssa)

vectorFrases <- c(vectorFrases,textocssa)

for (frase in vectorFrases) {
  print(frase)
  textodefondoblanco <- gsub(frase,"",textodefondoblanco)
}
print(textodefondoblanco)
textodefondoblanco <- gsub("\n","",textodefondoblanco)
textodefondoblanco <- trim(textodefondoblanco)
print(textodefondoblanco)



##########################
##### Obteiendo tabla ####

mitabla <- html_table(mipagina)
mitabla <- mitabla[[1]]

# Leyendo la tabla
mitabla[2]
mitabla$'DescripciÃ³n'

# cambiando nombres de columna de la tabla
colnames(mitabla)[2] <- 'descripcion'
mitabla$descripcion


###################################
#### obteniendo url de un link ####

cssa <- html_nodes(mipagina, css = ".fondoblanco > a")
referencia <- html_attr(cssa,"href")
print(referencia)