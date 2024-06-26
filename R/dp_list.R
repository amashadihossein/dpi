#' @title List Data Products on a Board
#' @description  List all data products on a named board you are connected with.
#' It requires connection via `dp_connect` first.
#' @param board_object board object from `dp_connect`
#' @return a tibble containing metadata of all versions of data products on board
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
      "Check spelling, your connection and ",
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
