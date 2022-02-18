#' @title Generate Properly Formatted Board Parameters
#' @description This function simply provides a consistent format for the board
#' parameters
#' @param board_alias name of the board
#' @param url url of the local directory
#' @param folder path of the study folder where the data product will be stored
#' @return A data.frame board_params
#' @examples
#' \dontrun{
#' board_params_set_labkey(board_alias = "xxxx",
#'   folder = "xxxx")
#' }
#' @export
board_params_set_local <- function(board_alias, cache){

  board_params <- data.frame(board_type = "local_board",
                             board_alias = board_alias,
                             cache = cache,
                             stringsAsFactors = FALSE)

  class(board_params) <- c("local_board",class(board_params))
  return(board_params)
}
