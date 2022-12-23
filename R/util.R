#' @title  Check dpconnect executed
#' @description This checks state whether dpconnect is already executed
#' @param board_params board_params (only the alias needed)
#' @keywords internal
dpconnect_check <- function(board_params) {
  board_info <- try(pins::board_get(name = board_params$board_alias), silent = T)
  if ("try-error" %in% class(board_info)) {
    stop(cli::format_error(glue::glue(
      "You are not currently connected to ",
      "{board_params$board_alias}. Use ",
      "dp_connect to connect first!"
    )))
  }
  invisible(board_info)
}
