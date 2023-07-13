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
#'   board_alias = "board_alias",
#'   bucket_name = "bucket_name",
#'   region = "us-east-1"
#' )
#' board_object <- dp_connect(board_params, aws_creds)
#' dp <- dp_get(board_object, "dp-study-branch", data_name = "data-name")
#' }
#' @importFrom dplyr .data
#' @export
dp_get <- function(board_object, data_name, version = NULL) {
  board_info <- board_object
  use_cache <- board_info$board == "local"

  is_dpinput <- rev(unlist(strsplit(
    x = board_info$prefix,
    split = "_|-|/"
  )))[1] == "dpinput"

  if (is_dpinput) {
    return(pins::pin_read(
      name = data_name, board = board_info,
      hash = version
    ))
  }

  dp_ls <- dp_list(board_object = board_info)
  available_datanames <- dp_ls %>%
    dplyr::filter(!.data$archived) %>%
    dplyr::pull(.data$dp_name)

  if (!data_name %in% available_datanames) {
    stop(cli::format_error(glue::glue(
      "data_name {data_name} is either archived",
      " or not on this board. Check the ",
      "data_name and board_alias",
      " or cannot read from the board."
    )))
  }

  if (length(version) > 0) {
    if (!version %in% (dp_ls$version)) {
      stop(cli::format_error(glue::glue(
        "version {version} is not on this ",
        "board. Check the version and ",
        "board_alias"
      )))
    }
  }
  dp <- pins::pin_read(
    name = data_name, board = board_info,
    # version = version
    hash = version
  )
  return(dp)
}
