#' @name getLinkLayer
#' @title Create a Links Layer from a Data Frame of Links.
#' @description Create a links layer from a data frame of links.
#' @param x an sf object, a simple feature collection (or a Spatial*DataFrame).
#' @param df a data frame that contains identifiers of starting and ending points.
#' @param xid identifier field in x, default to the first column (optional)
#' @param dfid identifier fields in df, character vector of length 2, default to 
#' the two first columns. (optional)
#' @param spdf defunct.
#' @param spdf2 defunct. 
#' @param spdfid defunct.
#' @param spdf2id defunct.
#' @param dfids defunct.
#' @param dfide defunct.
#' @return An sf LINESTRING is returned, it contains two fields (origins and destinations).
#' @examples 
#' library(sf)
#' mtq <- st_read(system.file("gpkg/mtq.gpkg", package="cartography"))
#' mob <- read.csv(system.file("csv/mob.csv", package="cartography"))
#' # Select links from Fort-de-France (97209))
#' mob_97209 <- mob[mob$i == 97209, ]
#' # Create a link layer
#' mob.sf <- getLinkLayer(x = mtq, df = mob_97209, dfid = c("i", "j"))
#' # Plot the links1
#' plot(st_geometry(mtq), col = "grey")
#' plot(st_geometry(mob.sf), col = "red4", lwd = 2, add = TRUE)
#' @seealso \link{gradLinkLayer}, \link{propLinkLayer}
#' @export
getLinkLayer <- function(x, xid = NULL, df, dfid = NULL, spdf, spdf2 = NULL, 
                         spdfid = NULL, spdf2id = NULL,
                         dfids = NULL, dfide = NULL){
if(sum(missing(spdf), is.null(spdf2), is.null(spdfid), 
       is.null(spdf2id), is.null(dfids), is.null(dfide)) != 6){
  stop("spdf, spdf2, spdfid, spdf2id, dfids and dfide are defunct arguments; last used in version 1.4.2.",
       call. = FALSE)
}
  
  if(methods::is(x, "Spatial")){x <- sf::st_as_sf(x)}
  if(is.null(xid)){xid <- names(x)[1]}
  if (is.null(dfid)){dfid <- names(df)[1:2]}
  x2 <- data.frame(id = x[[xid]], 
                   sf::st_coordinates(sf::st_centroid(x = sf::st_geometry(x), of_largest_polygon = max(sf::st_is(sf::st_as_sf(x), "MULTIPOLYGON")))), 
                   stringsAsFactors = FALSE)
  # names(x2)[2:3] <- c('X', 'Y')
  df <- df[,dfid]
  link <- merge(df, x2, by.x = dfid[2], by.y = "id", all.x = TRUE)
  link <- merge(link, x2, by.x =  dfid[1], by.y = "id", all.x = TRUE)
  names(link)[3:6] <- c('xj', 'yj', 'xi', 'yi')

  # watch for NAs
  d1 <- nrow(link)
  link <- link[!is.na(link$xj) & !is.na(link$xi),]
  d2 <- nrow(link)
  if(d2 == 0){
    stop("No links were created. dfid and xid do not match", call. = FALSE)
  }
  if((d1 - d2) > 0){
    warning(paste0((d1 - d2), 
                   " links were not created. Some dfid were not found in xid"), 
            call. = FALSE)
  }
  
  stringo <- paste0('LINESTRING(', link$xi, " ",link$yi, ", ", 
                    link$xj, " ", link$yj, ")")
  link <- sf::st_sf(link[, dfid], 
                geometry = sf::st_as_sfc(stringo, crs = sf::st_crs(x)))
  return(link)
}

