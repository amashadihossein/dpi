#' @title List data products on a remote pin board
#' 
#' @description List all available data products and their details from a remote
#'   pin board. You must connect to the remote pin board using `dp_connect`
#'   first. Details include data product name, version hashes, branch names,
#'   sha1 hashes for the stored data objects, deployment time, and Git commit
#'   details like author, commit message, and commit hash. The details returned
#'   are read from the `dpboard-log` pin on the remote pin board.
#' 
#' @param board_object A `pins_board` object from `dp_connect`.
#' @return A tibble with one row per version per data product from the remote
#'   pin board. Each row contains metadata for the given version of the given
#'   data product.
#'
#' @examples
#' \dontrun{
#' aws_creds <- creds_set_aws(
#'   key = Sys.getenv("AWS_KEY"),
#'   secret = Sys.getenv("AWS_SECRET")
#' )
#' board_params <- board_params_set_s3(
#'   bucket_name = "bucket_name",
#'   region = "us-east-1"
#' )
#' board_object <- dp_connect(board_params, aws_creds)
#' dp_list(board_object)
#' }
#'
#' @importFrom dplyr .data
#' @importFrom lubridate as_datetime
#' @importFrom lubridate with_tz
#' @export
dp_list <- function(board_object) {

  if (board_object$board == "pins_board_labkey") {
    dpboard_log <- try(pinsLabkey::pin_read(
      name = "dpboard-log",
      board = board_object
    ))
  } else {
    dpboard_log <- try(pins::pin_read(
      name = "dpboard-log",
      board = board_object
    ))
  }
  if (!"data.frame" %in% class(dpboard_log)) {
    stop(cli::format_error(glue::glue(
      "Could not retrieve dpboard_log!",
      "Check spelling, your connection, and ",
      "your credentials!"
    )))
  }

  dpls <- dpboard_log %>%
    dplyr::rename(version = .data$pin_version) %>%
    dplyr::mutate(commit_time = as_datetime(.data$commit_time)) %>%
    dplyr::mutate(last_deployed = as_datetime(.data$last_deployed)) %>%
    dplyr::mutate(commit_time = with_tz(.data$commit_time)) %>%
    dplyr::mutate(last_deployed = with_tz(.data$last_deployed)) %>%
    dplyr::relocate(.data$dp_name, .data$version)

  return(dpls)
}
