#' Hurricane data Hurdat2 for Atlantic Basin
#'
#' A subset of data from the Hurricane Research Division
#' Report ...
#'
#' @format ## `hurdat2`
#' A data frame with 55, 959 rows and 21 columns:
#' \describe{
#'   \item{Date}{date yearmonthday}
#'   \item{Time}{hourminute, hours in UTC}
#'   \item{Landfall}{Identifier for where it land}
#'   \item{Status}{Status of the system}
#'   \item{Latitude}{latitude of the hurricane}
#'   \item{Longitude}{Longitude of the hurricane}
#'   \item{Maximum.Wind}{Maximum sustained wind (in knots) }
#'   \item{Minimum.Pressure}{Minimum Pressure (in millibars) }
#'   \item{NE34}{34 kt wind radii maximum extent in northeastern quadrant (in nautical miles) }
#'   \item{SE34}{similar above}
#'   \item{Max.Radius}{Radius of Maximum Wind (in nautical miles)}
#'   ...
#'
#' }
#' @source <https://www.aoml.noaa.gov/hrd/hurdat/Data_Storm.html>
"processed_hurdat"
