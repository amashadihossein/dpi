#' @title Create formatted parameters that specify a LabKey board
#'
#' @description Build a data frame that contains all of the parameters
#'   needed to specify a LabKey pin board.
#'
#' @param board_alias A short name for the board.
#'   `r lifecycle::badge("deprecated")` this argument is deprecated with
#'   pins ≥ 1.0.
#'
#' @param url The URL of the LabKey server.
#' @param folder The path of the study folder on the LabKey server where the
#'   data product will be stored.
#' @param cache_alias A short name for the cache folder (optional).
#'
#' @return A data.frame with class "labkey_board" and a column for each param.
#'
#' @examples
#' \dontrun{
#' board_params_set_labkey(
#'   url = "https://learn.labkey.com/",
#'   folder = "folder_name"
#' )
#' }
#' @export
board_params_set_labkey <- function(board_alias = deprecated(), url, folder = "",
                                    cache_alias = NULL) {
  if (lifecycle::is_present(board_alias)) {
    lifecycle::deprecate_stop("0.3.0", "board_params_set_labkey(board_alias)",
                              details = downgrade_message())
  }

  if (url == ""){
    stop(cli::format_error("Non-empty url must be provided."))
  }

  if (is.null(cache_alias)) {
    board_params <- data.frame(
      board_type = "labkey_board",
      folder = folder,
      url = url,
      stringsAsFactors = FALSE
    )
  } else {
    board_params <- data.frame(
      board_type = "labkey_board",
      cache_alias = cache_alias,
      folder = folder,
      url = url,
      stringsAsFactors = FALSE
    )
  }

  class(board_params) <- c("labkey_board", class(board_params))
  return(board_params)
}
