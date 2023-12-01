# Q7

#' Compute the accumulated cyclone energy of a given storm
#'
#' @param storm_data | the dataframe for the hurricane information
#' @param storm_id | the storm IDs to be plot for its tracks
#'
#' @return energy | accumulated cyclone energy of the storm
#' @export
#'
#' @examples
#' data(processed_hurdat)
#' new = cumE(processed_hurdat,"AL182019")

cumE = function(storm_data, storm_id) {
    storm = subset(storm_data, ID == storm_id)
    speed = storm$Maximum.Wind
    # speed = speed[speed>=35] # with no information to determine from the website
    energy = sum(speed^2,na.rm=TRUE)*10^-4
    return (energy)
}
