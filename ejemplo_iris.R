rm(list=ls())
graphics.off()

head(iris)

library(ggplot2)
# Datos + esteticas
g <- ggplot(iris, aes(x=Petal.Length, y=Petal.Width))
g


#Capa geometrica (scatter plot)
g <- g + geom_point(aes(colour=Species),size=2)
g



#Capa de facetas
g <- g + facet_wrap(Species~., ncol=1)
g

#Capa estadistica
g <- g + stat_smooth(aes(group=Species),
                     method = "lm",
                     formula = y~x,
                     col="black")
g

#Capa de coordenadas 
g <- g + coord_flip()
g

#Capa de tema
g <- g + theme_bw()
g

#Agrego titulo, subtitulo, etiquetas de eje y de leyenda
#Cambio los colores 
g <- g + labs(title="Petalos de Iris",
               subtitle="Comparación entre especies",
               x="Ancho del pétalo [cm]",
               y="Largo del pétalo [cm]",
               colour="Especie",
               shape="Especie")+
  scale_color_manual(values=c("#C70CED","#4100E0","#0C45ED"))


g

#Guardo la imagen
ggsave("figuras/iris.jpg",dpi=300,
       width=15,
       height=10,
       units="cm")

