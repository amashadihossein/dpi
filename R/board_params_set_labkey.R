#' @title Create formatted parameters that specify a LabKey board
#' 
#' @description Build a data frame that contains all of the parameters
#'   needed to specify a LabKey pin board.
#' 
#' @param board_alias A short name for the board.
#' @param url The URL of the LabKey server.
#' @param folder The path of the study folder on the LabKey server where the
#'   data product will be stored.
#' 
#' @return A data.frame with class "labkey_board" and a column for each param.
#' 
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
  if (url == ""){
    stop(cli::format_error("Non-empty url must be provided."))
  }

  board_params <- data.frame(
    board_type = "labkey_board",
    board_alias = board_alias,
    folder = folder,
    url = url,
    stringsAsFactors = FALSE
  )

  class(board_params) <- c("labkey_board", class(board_params))
  return(board_params)
}
