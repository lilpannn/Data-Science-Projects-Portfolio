# Q6.

#' Determine whether storm made landfall within US continent.
#'
#' @param storm_data | the dataframe for the hurricane information
#' @param storm_id | the storm IDs to be plot for its tracks
#'
#' @return logic value | whether it landfall or not
#' @export
#'
#' @examples
#' data(processed_hurdat)
#' logic.landfall = landfall(processed_hurdat,"AL061851")
#'
landfall = function(storm_data, storm_id) {
    sub = subset(storm_data, ID == storm_id)
    point_lat <- sub$Latitude
    point_lon <- sub$Longitude
    point_combined <- cbind(point_lon, point_lat)
    # remove row that contains NA
    complete_rows <- !apply(is.na(point_combined), 1, any)
    if (!all(complete_rows))  {
      point_combined <- point_combined[complete_rows, ]}

    us_states <- ggplot2::map_data("usa")
    point <- sp::coordinates(sp::SpatialPoints(point_combined))
    intersects <- sp::point.in.polygon(point[, 1],
                                       point[, 2],
                                       us_states$long, us_states$lat)
    if (!all(intersects==0)){
      ### in order to plot analysis #2, we return the index for landfall rows
      ### of hurricane data frame
      return (as.data.frame(intersects))
    } else
    ### otherwise return FALSE, which denotes no landfall for specified storm
    return (F)
}
