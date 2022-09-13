pacman::p_load
        (
        dplyr,
        tidyverse,
        ggplot2,
        tidyr, 
        readr, 
        lubridate, 
        ggmap,
        scales,
        ggmap,
        RColorBrewer
        )

map_data <- read.csv("C:\\Users\\Kilia\\OneDrive\\Documents\\RStudio Projects\\blue_whale.csv")

# exploring in R; useful for reading list of colnames etc.
head(map_data)
colnames(map_data)
View(map_data)

which(is.na(map_data$location_long), 
      arr.ind = TRUE)

class(map_data$tag_local_identifier) = 'integer'

## MAP (set up Google API as well)

?register_google

mapped_whale <- get_map(location = c(lon = mean(map_data$location_long),
                                     lat = mean(map_data$location_lat)
                                    ),
                        zoom = 4,
                        maptype = "satellite", 
                        scale = 2,
                        extent = "device",
                        color = 'bw')
##Trying contour map

ggmap(mapped_whale) +
  stat_density2d(data = map_data, 
                 aes(x = location_long,
                     y = location_lat,
                     fill =  ..level..
                    ),
                 bins = 30,
                 h = 3,
                 n = 100,
                 alpha = 1,
                 geom = 'polygon',
                 size = 3
                ) + 
  scale_fill_gradientn(colors = rev(brewer.pal(10, 'Spectral')),
                       labels = comma
                      ) +
  geom_point(data = map_data, 
             aes(x = location_long,
                 y = location_lat,
                 color = "Whale"
                ),
             fill = 'red',
             shape = 21,
             alpha = .2
             )+
  guides(fill = FALSE, 
         color = guide_legend(
           title = "GPS Tag",
           override.aes = list(size = 2)
         )) +
  theme (legend.key = element_rect(fill = 'white'),
         axis.title.y = element_blank(), 
         axis.title.x = element_blank()
        ) +
  ggtitle(" Azores Blue Whale Spatial Distribution, 04/2009-07/2016") +
  xlab("Long") + ylab("Lat")
