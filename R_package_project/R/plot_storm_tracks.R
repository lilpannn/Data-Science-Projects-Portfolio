# 4. this is a function for plotting a map of storm tracks for a selection of storms.
# The map here include country and US state boundaries

#' Plot storm track on the map
#'
#' @param storm_data | the dataframe for the hurricane information
#' @param storm_ids | the storm IDs to be plot for its tracks
#'
#' @return p | a ggplot object
#' @export
#'
#' @examples
#' data(processed_hurdat)
#' library(mapdata)
#' library(ggplot2)
#' library(maps)
#' p <- plot_storm_tracks(processed_hurdat,c("AL022018","AL042017"))
plot_storm_tracks <- function(storm_data, storm_ids) {

    # Get a map of country and state boundaries
    map_world <- ggplot2::map_data(map = "world")
    map_usa <- ggplot2::map_data(map = "usa")
    us_states <- ggplot2::map_data("state")

    # interpolate our data
    storm_data.interpolated = data.frame()
    for (i in seq_along(storm_ids)){
    storm_data.i = WHIRL::interpolate(storm_data, storm_ids[i])
    storm_data.interpolated = rbind(storm_data.interpolated,storm_data.i)
    }
    # Filter the storm data for the selected storm IDs
    storm_data_filtered <- subset(storm_data.interpolated,
                                  ID %in% storm_ids)

    # Plot the map and storm tracks
    p <- ggplot2::ggplot() +
      ggplot2::geom_path(data = us_states,
                         ggplot2::aes(x = long, y = lat, group = group),
                         color = "white", alpha = 0.7) +
      ggplot2::geom_path(data = map_usa,
                         ggplot2::aes(x = long, y = lat, group = group),
                         color = "white", alpha = 0.7) +
      ggplot2::geom_path(data = storm_data_filtered,
                         ggplot2::aes(x = Longitude, y = Latitude, group = ID,color=ID),
                         linewidth = 0.3) +
      ggplot2::scale_color_discrete(name = "Name", labels = unique(storm_data_filtered$Name))+
      ggplot2::coord_equal() +
      ggplot2::labs(title = "Storm Tracks", x = "Longitude", y = "Latitude") +
      ggplot2::theme(panel.background = ggplot2::element_rect(fill = "black"),
                     panel.grid.major = ggplot2::element_blank(),
                     panel.grid.minor = ggplot2::element_blank(),
                     # adjust legend
                     legend.key.size = ggplot2::unit(0.3, "cm"),
                     legend.position = "bottom",
                     )
    return (p)
}




