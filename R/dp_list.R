#' @title List Data Products on a Board
#' @description  List all data products on a named board you are connected with.
#' It requires connection via `dp_connect` first.
#' @param board_params use `board_params_set_s3`, `board_params_set_labkey`, or
#'`board_params_set_local` for this. It contains the parameters for the board
#' on which the data product is pinned
#' @param creds use `creds_set_aws` or `creds_set_labkey` to set this. When using
#' a local board, creds is ignored and does not need to be specified.
#' @return a tibble containing metadata of all versions of data products on board
#'
#' @examples
#' \dontrun{
#' aws_creds <- creds_set_aws(
#'   key = Sys.getenv("AWS_KEY"),
#'   secret = Sys.getenv("AWS_SECRET")
#' )
#' board_params <- board_params_set_s3(
#'   board_alias = "board_alias",
#'   bucket_name = "bucket_name",
#'   region = "us-east-1"
#' )
#' dp_connect(board_params, aws_creds)
#' dp_list(board_params)
#' }
#'
#' @importFrom dplyr .data
#' @importFrom lubridate as_datetime
#' @importFrom lubridate with_tz
#' @export
dp_list <- function(board_params, creds) {
  board_info <- dp_connect(board_params = board_params, creds = creds)
  # board_info  <- board_object
  use_cache <- board_info$board == "local"

  dpboard_log <- try(pins::pin_read(
    name = "dpboard-log",
    board = board_info
  ))
  if (!"data.frame" %in% class(dpboard_log)) {
    stop(cli::format_error(glue::glue(
      "Could not retrieve dpboard_log! Check",
      "Check spelling, your connection and ",
      "your credentials!"
    )))
  }

  dpls <- dpboard_log %>%
    dplyr::rename(version = .data$pin_version) %>%
    dplyr::mutate(board_alias = board_params$board_alias) %>%
    dplyr::mutate(commit_time = as_datetime(.data$commit_time)) %>%
    dplyr::mutate(last_deployed = as_datetime(.data$last_deployed)) %>%
    dplyr::mutate(commit_time = with_tz(.data$commit_time)) %>%
    dplyr::mutate(last_deployed = with_tz(.data$last_deployed)) %>%
    dplyr::relocate(.data$dp_name, .data$version, .data$board_alias)


  return(dpls)
}
