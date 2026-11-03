#INTRODUCCIÓN A GGPLOT - EJEMPLO
# Clase 25/10/2022
# Dalia Virginia Panza

## Objetivo ##

#Graficar una serie temporal de anomalías de temperatura
#mensual, usando un grafico de barras donde los colores
#indiquen si la anomalía es cálida o fría.

rm(list=ls())
graphics.off()

# 1) Instalar/importar ggplot2 --------------------------------------------

#install.packages("ggplot2")
library(ggplot2)

# 2) Leer y preparar datos ------------------------------------------------

# Configuro el espacio de trabajo
setwd("C:\\Facu\\Labo_2022\\intro_ggplot2")

# Leo los datos del archivo csv
tabla <- read.table("datos/tablaT.csv", sep=",", header=T)
tabla <- tabla[,c(-1,-14)]

# Genero un array de 7x12 vacío donde guardar anomalías
anoms <- array(NA, c(7,12))
#Le pongo nombre a las columnas
colnames(anoms) <- colnames(tabla)

#Recorro las columnas de la tabla original, le resto la media
#Y guardo las anomalías en la columna correspondiente de anoms
for(i in 1:12){
  anoms[,i] <- tabla[1:7,i] - tabla[8,i]  
}

# Armo el dataframe para poder pasarselo a ggplot

#Eje x: tiempo
fechas <- seq(as.Date("2000-01-01"),as.Date("2006-12-01"),by="month")
#Eje y: anomalias
anoms_1D <- as.vector(t(anoms))
#Colores: tipo de anomalías
tipo_anom <- ifelse(anoms_1D>0,"Cálida","Fría")

#Creo el df
df <- data.frame(fecha=fechas, temp=anoms_1D, tipo_anom=tipo_anom)


# 2) Capa de datos y mapeo de estéticas -----------------------------------

#Llamo a la función ggplot para comenzar un gráfico
#Primer parametro: dataframe
#Segundo parametro: mapeo de esteticas con aes()
g <- ggplot(df, aes(x=fechas,y=temp))
g

# 3) Capa geometrica ------------------------------------------------------

# En este caso quiero hacer un grafico de barras, la capa correcta es
# geom_col()
g <- g + geom_col(aes(fill=tipo_anom))
g

#Me gustaria remarcar el eje donde y=0. Agrego la capa geométrica
#geom_hline()
g <- g + geom_hline(yintercept=0)
g

# 4) Capas extra para personalizar el gráfico -----------------------------

#Etiquetas
g <- g + labs(title="Anomalías de temperatura mensual",
              subtitle="Respecto del período 2000-2006",
              x="",
              y="Anomalía [°C]",
              fill="")
g

#Intervalos del eje y
g <- g + scale_y_continuous(breaks=seq(-2.5,2.5,0.5))
g

#Intervalos de tiempo del eje x
g <- g +scale_x_date(breaks="1 year",date_labels="%Y")
g

#Colores ed las barras
g <- g + scale_fill_manual(values=c("#E06F21","#00A89D"))
g

#Hay temas precargados (ver en cheatsheet),pero hago mi tema personalizado
#y lo guardo en una variable
mi_tema <- theme(panel.background = element_rect(fill="white",colour="grey"),
                 panel.grid.major.x = element_line(colour="gray",
                                                   linetype="dashed",
                                                   size=.2),
                 panel.grid.minor.x= element_blank(),
                 panel.grid.minor.y = element_blank(),
                 panel.grid.major.y = element_line(colour="#A4B5D9",
                                                   linetype="dashed",
                                                   size=.2))
g <- g + mi_tema
g

# 5) Guardamos el gráfico -------------------------------------------------

ggsave("figuras/anom_temp.jpg",dpi=600, units="cm", height=15,width=27)


