#' Helper function to help with plot_storm_size function to get the
#' row and track of a specified storm year and name
#'
#' @param storm_data | processed hur data, dataframe
#' @param storm_name | a stirng with specified storm name
#' @param storm_year | a stirng with specified storm year
#'
#' @return df | dataframe that contains the strongest landfall row
#' @export
#'
#' @examples
#' data(processed_hurdat)
#' katrina = plot_storm_size_helper(processed_hurdat, "katrina", "2005")
plot_storm_size_helper = function(storm_data, storm_name, storm_year) {
    df = storm_data
    storm = subset(df, grepl(storm_name, Name, ignore.case = T) == T)
    storm = subset(storm, grepl(storm_year, Date) == T)
    storm_int = interpolate(storm, storm$ID[1])

    ind = which(landfall(storm_int, storm_int$ID[1])==1)
    storm_l = storm_int[ind,]
    max_in = which(storm_l$Maximum.Wind == max(storm_l$Maximum.Wind))[1]
    storm_max_l = storm_l[max_in,]
    df = rbind(storm_max_l,storm_int)
    return(df)
}
