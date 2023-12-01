## code to prepare `processed_hurdat` dataset goes here

#' Prepare datasets from raw hurricane data for Atlantic Basin
#'
#' @param path | path for input hurdat2.txt
#' @param pathout | path for output csv file
#'
#' @return dat3 | a dataframe to be saved as csv
#' @export

prep_dataset <- function(path,pathout){
    # path /Users/zijianleowang/Downloads/StatComp/hurdata2.txt
    # pathout /Users/zijianleowang/Downloads/StatComp/hurdata2.formatted.csv
    dat = read.csv(path, header= FALSE)#"./hurdata2.txt"
    # since some data has wrong nextline at the middle of one row like
    # 19880924, 0000,  , HU, 15.9N,  46.9W, 120,  940, -999, -999, -999, -999, -999, -999, -999, -999,
    # -999, -999, -999, -999, -999
    # 18710822, 1800,  , TS, 31.1N,  80.4W,  60, -999, -999, -999, -999, -999, -
    #   999, -999, -999, -999, -999, -999, -999, -999, -999
    # 19761003, 1200,  , TS, 36.2N,
    # 46.9W,  40,  999, -999, -999, -999, -999, -999, -999, -999, -999, -999, -999, -999, -999, -999

    # The first column should has 8 characters
    # I cleaned it using by find the row or below
    V1 = dat$V1
    dat = dat[-which(nchar(V1) != 8),]

    # now to reformat dataframe
    ## get the storm id, and name
    ind = grep("AL", dat$V1) # id of storm info
    stormid.name = dat[ind,c("V1","V2")] # get the storm ID and paired name
    ind2 = c(ind,nrow(dat)+1) # storm id row and last row

    ## add two columns to the beginning columns of dat
    dat2 = dat
    dat2[c('ID','Name')] = ''
    dat2 = dat2[c('ID','Name',colnames(dat))]
    ## get the storm date and pair it with storm id
    for (i in seq_along(ind)){
      lower = ind2[i]+1
      higher = ind2[i+1]-1
      dat2[lower:higher,"ID"] = dat2[ind2[i],"V1"] # put storm id to each row
      dat2[lower:higher,"Name"] = dat2[ind2[i],"V2"] # put storm name to each row
    }
    dat2 = dat2[-ind,]

    # change colname
    colnames(dat2) =c("ID", "Name", "Date", "Time", "Landfall",
                      "Status", "Latitude", "Longitude",
                      "Maximum.Wind", "Minimum.Pressure",
                      "NE34", "SE34", "SW34", "NW34",
                      "NE50", "SE50", "SW50", "NW50",
                      "NE64", "SE64", "SW64", "NW64","Max.Radius")
    # change data type

    # set -999 to NA
    dat2[dat2==-999] = NA
    dat2[dat2==" -999"] = NA
    dat2[dat2=="-999"] = NA
    dat2[dat2=="999"] = NA

    # numeric latitude/longitude
    # if north & east, positive, and negative otherwise
    convert_lat_lon <- function(longi,letterlist) {
      idx = which(grepl(letterlist$pos,longi)==T)
      longi[-idx] = as.numeric(gsub(letterlist$neg,"",longi[-idx])) * -1  # W
      longi[idx] = as.numeric(gsub(letterlist$pos,"",longi[idx])) # E
      longi = as.numeric(longi)
      return(longi)
    }
    dat3 = dat2
    dat3$Longitude = convert_lat_lon(dat3$Longitude,list(neg="W",pos="E"))
    dat3$Latitude = convert_lat_lon(dat3$Latitude,list(neg="S",pos="N"))
    rownames(dat3) = 1:(dim(dat3)[1])

    # impose class for all columns
    for (coli in c("ID", "Name", "Date", "Time", "Landfall",
                   "Status"))
    {dat3[,coli] = as.character(dat3[,coli])}

    for (coli in c("Latitude", "Longitude",
            "Maximum.Wind", "Minimum.Pressure",
            "NE34", "SE34", "SW34", "NW34",
            "NE50", "SE50", "SW50", "NW50",
            "NE64", "SE64", "SW64", "NW64","Max.Radius"))
      {dat3[,coli] = as.numeric(dat3[,coli])}

    write.csv(dat3,pathout,row.names=FALSE)
    return (dat3)
}
usethis::use_data(processed_hurdat, overwrite = TRUE)
