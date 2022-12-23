#' @title  Get the data object
#' @description Load into working environment the data data object
#' @param board_params use `board_params_set_s3` or `board_params_set_labkey`
#' for this. It contains the parameters for the board on which the data product
#' is pinned
#' @param data_name data name on the board
#' @param version data version pinned, default gets you the latest. Executed
#' dp_list to see what's available
#' @return dp pinned data
#'
#' @examples
#' \dontrun{
#' aws_creds <- creds_set_aws(
#'   key = Sys.getenv("AWS_KEY"),
#'   secret = Sys.getenv("AWS_SECRET")
#' )
#' board_params <- board_params_set_s3(
#'   board_alias = "board_alias",
#'   bucket_name = "bucket_name", region = "us-east-1"
#' )
#' dp_connect(board_params, aws_creds)
#' dp <- dp_get("dp-study-branch", board_params = board_params)
#' }
#' @importFrom dplyr .data
#' @export
dp_get <- function(board_params, data_name, version = NULL) {
  dpconnect_check(board_params = board_params)

  is_dpinput <- rev(unlist(strsplit(
    x = board_params$board_alias,
    split = "_|-"
  )))[1] == "dpinput"

  if (is_dpinput) {
    return(pins::pin_get(
      name = data_name, board = board_params$board_alias,
      version = version
    ))
  }

  dp_ls <- dp_list(board_params = board_params)
  available_datanames <- dp_ls %>%
    dplyr::filter(!.data$archived) %>%
    dplyr::pull(.data$dp_name)

  if (!data_name %in% available_datanames) {
    stop(cli::format_error(glue::glue(
      "data_name {data_name} is either archived",
      " or not on this board. Check the ",
      "data_name and board_alias"
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
  dp <- pins::pin_get(
    name = data_name, board = board_params$board_alias,
    version = version
  )
  return(dp)
}
