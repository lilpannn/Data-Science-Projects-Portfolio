# Q3
#' A function for interpolating a storm track to 30 min increments.
#'
#' @param storm_data | the dataframe for the hurricane information
#' @param storm_id | the storm IDs to be plot for its tracks
#'
#' @return new | interpolated data.frame
#' @export
#'
#' @examples
#' data(processed_hurdat)
#' new = interpolate(processed_hurdat,"AL021857")

interpolate = function(storm_data, storm_id) {
    hurdat2 = subset(storm_data, ID == storm_id)
    hurdat2$datetime <- as.POSIXct(paste(hurdat2$Date,
                                         hurdat2$Time),
                                   format="%Y%m%d %H%M", tz="UTC")
    newtimes <- seq.POSIXt(from=min(hurdat2$datetime),
                           to=max(hurdat2$datetime), by="30 min")
    inter = function(hurdat2,column,newtimes) {
      stats::approx(hurdat2$datetime, column, newtimes)$y
    }
    #create new  to save new interpolated data frame
    nrow = length(newtimes)
    # minus 4 columns bc remove landfall status, radius, and combined date-time
    mat = matrix(nrow=nrow,ncol = ncol(hurdat2)-4)
    new = as.data.frame(mat) # the returned dataframe after interpolation

    colname = colnames(storm_data)
    colname = colname[-3]
    colname = colname[-3]
    colname = colname[1:21]
    temp = hurdat2[,colname] # subset of hurdat2
    for (i in 1:(ncol(temp)-1)){
      # the latter logic condition is because stats::approx
      # requires more than 2 non-NAs values to interpolate
      if (is.numeric(temp[,i]) && sum(!is.na(temp[,i]))>=2 ){
        new[,i+1] = inter(hurdat2,temp[,i],newtimes)}
      else
      {new[,i+1] = rep(temp[1,i],nrow(new))}
    }
    new[,1] = newtimes
    names(new)[1] = "Time"
    names(new)[2:ncol(new)] = colnames(temp)[1:(ncol(new)-1)]
    return (new)
}
