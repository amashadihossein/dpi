#' @title Generate properly formatted board parameters for local board
#' @description This function simply provides a consistent format for the board 
#' parameters
#' @param board_alias name of the board
#' @param folder path to data product storage folder. NOTE: as a general 
#' guidance this folder should be treated as a permanent location with immutable
#' content. For example, a data product project folder *is not* an appropriate 
#' directory. 
#' 
#' @return A data.frame board_params
#' @examples
#' \dontrun{
#' board_params_set_loca(board_alias = "xxxx",
#'   folder = "xxxx")
#' }
#' @export

board_params_set_local <- function(board_alias, folder){
  
  board_params <- data.frame(board_type = "local_board", 
                             board_alias = board_alias, folder = folder,
                             stringsAsFactors = FALSE)
  
  class(board_params) <- c("local_board",class(board_params))
  return(board_params)
}
