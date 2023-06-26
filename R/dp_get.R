#' @title  Get the Data Object
#' @description Load into working environment the data product object
#' @param board_params use `board_params_set_s3`, `board_params_set_labkey`, or
#' `board_params_set_local` for this. It contains the parameters for the board
#' on which the data product is pinned
#' @param creds creds
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
#' dp_connect(board_params, aws_creds)
#' dp <- dp_get("dp-study-branch", board_params = board_params)
#' }
#' @importFrom dplyr .data
#' @export
dp_get <- function(board_params, creds = creds, data_name, version = NULL) {
  # board_info <- dp_connect(board_params = board_params, creds = creds)
  board_info <- dpi::dp_connect(
    board_params = board_params, creds = creds,
    board_subdir = file.path("dpinput/")
  )

  use_cache <- board_info$board == "local"

  is_dpinput <- rev(unlist(strsplit(
    x = board_info$prefix,
    split = "_|-|/"
  )))[1] == "dpinput"

  if (is_dpinput) {
    return(pins::pin_read(
      name = data_name, board = board_info,
      version = version
    ))
  }

  # dp_ls <- dp_list(board_params = board_params, board_object = board_info)
  # available_datanames <- dp_ls %>%
  #   dplyr::filter(!.data$archived) %>%
  #   dplyr::pull(.data$dp_name)

  else {
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
    version = version
  )
  return(dp)
}
