#' @title Create formatted parameters that specify a local storage board
#'
#' @description Build a data frame that contains all of the parameters
#'   needed to connect to a local storage board.
#'
#' @param folder The path to the local storage folder where the data product
#'   will be stored. NOTE: this folder should be treated as a permanent location
#'   with immutable content. For example, a data product git repo project folder
#'   *is not* an appropriate directory.
#' @param board_alias A short name for the board.
#'   `r lifecycle::badge("deprecated")` this argument is deprecated with
#'   pins ≥ 1.0.
#'
#' @return A data.frame with class "local_board" and a column for each param.
#'
#' @examples
#' \dontrun{
#' board_params_set_local(folder = "xxxx")
#' }
#' @export
board_params_set_local <- function(folder, board_alias = deprecated()){

  if (lifecycle::is_present(board_alias)) {
    lifecycle::deprecate_stop("0.1.0", "board_params_set_local(board_alias)",
                              details = downgrade_message())
  }

  board_params <- data.frame(board_type = "local_board",
                             folder = folder,
                             stringsAsFactors = FALSE)

  class(board_params) <- c("local_board", class(board_params))
  return(board_params)
}
