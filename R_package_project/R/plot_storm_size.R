# Q5

#' A function to plot a map of the position and size of a given storm
#' It would plot based on 34, 50, and 64 knot extent variable
#'
#' @param row | the strongest landfall determined by maximum sustained wind speed of the specified hurricane
#' @param df | dataframe that contains all the specified hurricane with name and year
#'
#' @return p | ggplot object
#' @export
#'
#' @examples
#' data(processed_hurdat)
#' katrina = plot_storm_size_helper(processed_hurdat, "katrina", "2005")
#' p1 = plot_storm_size(katrina[1,],katrina[-1,])
plot_storm_size = function(row, df) {
    data = row
    lat = data$Latitude
    lon = data$Longitude
    ne34 = data$NE34
    se34 = data$SE34
    sw34 = data$SW34
    nw34 = data$NW34
    circle = function(lat, lon, heading, distance) {
      if (heading == "ne") {
        theta <- seq(0, pi/2, length.out=1000)
      }
      else if (heading == "nw") {
        theta <- seq(pi/2, pi, length.out=1000)
      }
      else if (heading == "sw"){
        theta <- seq(pi, 3*pi/2, length.out=1000)
      }
      else{
        theta <- seq(3*pi/2, 2*pi, length.out=1000)
      }
      R <- 3440.06479 # radius of the Earth in nautical miles
      lat <- lat * pi/180 # convert to radians
      lon <- lon * pi/180 # convert to radians
      d <- distance / R # convert to radians
      new_lat <- as.numeric(as.character(lat + d * sin(theta)))
      new_lon <- as.numeric(as.character(lon + d * cos(theta) / cos(lat)))
      new_lat <- new_lat * 180/pi # convert back to degrees
      new_lon <- new_lon * 180/pi # convert back to degrees
      return(as.data.frame(cbind(new_lat, new_lon)))
    }


    coords34_ne <- circle(lat, lon, "ne", ne34)
    coords34_se <- circle(lat, lon, "se", se34)
    coords34_sw <- circle(lat, lon, "sw", sw34)
    coords34_nw <- circle(lat, lon, "nw", nw34)

    ne50 = data$NE50
    se50 = data$SE50
    sw50 = data$SW50
    nw50 = data$NW50
    coords50_ne <- circle(lat, lon, "ne", ne50)
    coords50_se <- circle(lat, lon, "se", se50)
    coords50_sw <- circle(lat, lon, "sw", sw50)
    coords50_nw <- circle(lat, lon, "nw", nw50)

    ne64 = data$NE64
    se64 = data$SE64
    sw64 = data$SW64
    nw64 = data$NW64
    coords64_ne <- circle(lat, lon, "ne", ne64)
    coords64_se <- circle(lat, lon, "se", se64)
    coords64_sw <- circle(lat, lon, "sw", sw64)
    coords64_nw <- circle(lat, lon, "nw", nw64)

    center = as.data.frame(cbind(data$Longitude,data$Latitude))
    us_states <- ggplot2::map_data("state")
    storm_track = df
    p <- ggplot2::ggplot() +
      ggplot2::geom_path(data = us_states, ggplot2::aes(x = long,
                        y = lat, group = group), color = "gray", alpha = 1) +
      ggplot2::geom_point(data=coords34_ne,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '34 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords34_nw,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '34 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords34_se,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '34 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords34_sw,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '34 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords50_ne,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '50 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords50_nw,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '50 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords50_se,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '50 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords50_sw,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '50 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords64_ne,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '64 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords64_nw,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '64 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords64_se,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '64 kt'),
                          size = 0.2) +
      ggplot2::geom_point(data=coords64_sw,
                          ggplot2::aes(x = new_lon, y = new_lat, color = '64 kt'),
                          size = 0.2) +
      ggplot2::coord_equal()  +
      ggplot2::geom_point(data = center, ggplot2::aes(x = V1, y = V2), size = 0.1) +
      ggplot2::scale_color_manual(name = "Wind Radii Group Intensity ",
                                  labels = c("34 kt","50 kt","64 kt"),
                         values = c("34 kt" = "green",
                                    "50 kt" = "palevioletred1",
                                    "64 kt" = "turquoise1")) +
      ggplot2::geom_text(data = center,
                         ggplot2::aes(x = V1, y = V2, label = data$Name),
                         size = 5, vjust = -3, fontface = "bold",
                         hjust = 1, color="gray98") +
      ggplot2::labs(title = "Storm Position and Size",
                    x = "Longitude", y = "Latitude") +
      ggplot2::geom_path(data = storm_track,
                         ggplot2::aes(x = Longitude, y = Latitude),
                linewidth = 1, color = "snow") +
      ggplot2::theme(panel.background = ggplot2::element_rect(fill = "black"),
                     panel.grid.major = ggplot2::element_blank(),
                     panel.grid.minor = ggplot2::element_blank(),
                     # adjust legend
                     legend.key.size = ggplot2::unit(0.3, "cm"),
                     legend.position = "bottom",
      )
    return (p)
}
