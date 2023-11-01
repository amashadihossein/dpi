#' @title  Get the Data Object
#' @description Load into working environment the data product object
#' @param board_object board object from `dp_connect`
#' @param data_name name of the data product on the board, i.e. dp-cars-us001. To
#' get a list of available data products, use `dp_list`
#' @param version data version to retrieve. If not specified, will retrieve the latest
#' version. Use `dp_list` to see available versions.
#' @return data product object
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
#' dp <- dp_get(board_object, data_name = "data-name")
#' }
#' @importFrom dplyr .data
#' @export
dp_get <- function(board_object, data_name, version = NULL) {
  # use_cache <- board_object$board == "local"

  # check for whether we're getting input or data product
  if (board_object$board == "pins_board_folder") {
    is_dpinput <- rev(unlist(strsplit(
      x = board_object$path,
      split = "_|-|/"
    )))[1] == "dpinput"
  } else {
    is_dpinput <- rev(unlist(strsplit(
      x = board_object$prefix,
      split = "_|-|/"
    )))[1] == "dpinput"
  }

  if (is_dpinput) {
    return(pins::pin_read(
      name = data_name, board = board_object,
      hash = version
    ))
  }

  dp_ls <- dp_list(board_object = board_object)
  available_datanames <- dp_ls %>%
    dplyr::filter(!.data$archived) %>%
    dplyr::pull(.data$dp_name)

  if (!data_name %in% available_datanames) {
    stop(cli::format_error(glue::glue(
      "data_name {data_name} is either archived",
      " or not on this board. Check the ",
      "data_name",
      " or cannot read from the board."
    )))
  }

  if (length(version) > 0) {
    if (!version %in% (dp_ls$version)) {
      stop(cli::format_error(glue::glue(
        "version {version} is not on this ",
        "board. Check the version."
      )))
    }
  }
  dp <- pins::pin_read(
    name = data_name, board = board_object,
    hash = version
  )
  return(dp)
}
