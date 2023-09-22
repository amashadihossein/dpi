#' @title Generate properly formatted board parameters for local board
#' @description This function simply provides a consistent format for the board
#' parameters
#' @param folder path to data product storage folder. NOTE: as a general
#' guidance this folder should be treated as a permanent location with immutable
#' content. For example, a data product project folder *is not* an appropriate
#' directory.
#' @param board_alias `r lifecycle::badge("deprecated")` this argument is deprecated with newer pins
#'
#' @return A data.frame with properly formatted board_params
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
