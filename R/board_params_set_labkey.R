#' @title Generate Properly Formatted Board Parameters
#' @description This function simply provides a consistent format for the board
#' parameters
#' @param board_alias name of the board
#' @param url url of the LabKey server
#' @param folder path of the study folder where the data product will be stored
#' @return A data.frame board_params
#' @examples
#' \dontrun{
#' board_params_set_labkey(
#'   board_alias = "labkey-board",
#'   url = "https://learn.labkey.com/",
#'   folder = "folder_name"
#' )
#' }
#' @export
board_params_set_labkey <- function(board_alias, url, folder = "") {

  board_params <- data.frame(
    board_type = "labkey_board",
    board_alias = board_alias, folder = folder,
    url = url, stringsAsFactors = FALSE
  )

  class(board_params) <- c("labkey_board", class(board_params))
  return(board_params)
}
