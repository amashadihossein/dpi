#' @title Generate Properly Formatted Board Parameters
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function simply provides a consistent format for the board
#' parameters
#' @param board_alias name of the board
#' @param url url of the labkey server
#' @param folder path of the study folder where the data product will be stored
#' @return A data.frame board_params
#' @examples
#' \dontrun{
#' board_params_set_labkey(
#'   board_alias = "xxxx",
#'   folder = "xxxx"
#' )
#' }
#' @export
board_params_set_labkey <- function(board_alias, url, folder = "") {
  lifecycle::deprecate_stop("0.1.0", "board_params_set_labkey()",
                            details = c(
                              " " = "LabKey functionality has been temporarily removed from dpi. Please downgrade pins and dpi packages using:",
                              " " = "remotes::install_github(repo = 'amashadihossein/pins')",
                              " " = "remotes::install_github(repo = 'amashadihossein/dpi@0.0.0.9008')"
                            )
  )


  board_params <- data.frame(
    board_type = "labkey_board",
    board_alias = board_alias, folder = folder,
    url = url, stringsAsFactors = FALSE
  )

  class(board_params) <- c("labkey_board", class(board_params))
  return(board_params)
}
