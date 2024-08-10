#' @title Get the data product from the remote pin board
#' 
#' @description Get a data product object from the provided remote pin board,
#'   including input links and output data structure. By default get the latest
#'   version, or get a particular version by specifying the version hash (find
#'   available versions using `dp_list`).
#' 
#' @param board_object A `pins_board` object from `dp_connect`.
#' @param data_name The name of the data product to get from the remote pin
#'   board, i.e. "dp-cars-us001". To get a list of data products available on
#'   the remote pin board, use `dp_list`.
#' @param version The hash specifying the data product version to get from the
#'   remote pin board. If `NULL`, `dp_get` will get the latest version
#'   available. To get a list of versions available for each data product on the
#'   remote pin board, use `dp_list`.
#' 
#' @return A data product object, which is a list with class `dp` and items
#'   `input`, `output`, and `README`.
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
#' dp <- dp_get(board_object, data_name = "data-name")
#' }
#' @importFrom dplyr .data
#' @export
dp_get <- function(board_object, data_name, version = NULL) {

  # check for whether we're getting input or data product
  if (board_object$board == "pins_board_folder") {
    is_dpinput <- rev(unlist(strsplit(
      x = board_object$path,
      split = "_|-|/"
    )))[1] == "dpinput"
  } else if (board_object$board == "pins_board_labkey") {
    is_dpinput <- rev(unlist(strsplit(
      x = board_object$subdir,
      split = "_|-|/"
    )))[1] == "dpinput"
  } else { # s3 board
    is_dpinput <- rev(unlist(strsplit(
      x = board_object$prefix,
      split = "_|-|/"
    )))[1] == "dpinput"
  }

  # only check if pin name exists if it's not an input
  if (!is_dpinput) {
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
  }

  # If we're trying to get a specific version, look up hash
  if (length(version) > 0) {
    if (board_object$board == "pins_board_labkey") {
      pin_versions <- pinsLabkey::pin_versions(
        board = board_object,
        name = data_name
      )
    } else {
      pin_versions <- pins::pin_versions(
        board = board_object,
        name = data_name
      )
    }
    if (!version %in% (pin_versions$hash)) {
      stop(cli::format_error(glue::glue(
        "version {version} is not on this ",
        "board. Check the version."
      )))
    } else {
      specified_version <- version
      version <- pin_versions %>% dplyr::filter(.data$hash == specified_version) %>%
        dplyr::pull(version)
      # Check in case we've manage to pin the same hash more than once
      if (length(version) > 1) {
        version <- version[length(version)]
        message(paste0("More than one pin version found with hash ",
                       specified_version, ". Using latest version: ",
                       version))
      }
    }
  }

  # get pin, specifying version if provided
  if (board_object$board == "pins_board_labkey") {
    dp <- pinsLabkey::pin_read(
      name = data_name, board = board_object,
      version = version
    )
  } else {
    dp <- pins::pin_read(
      name = data_name, board = board_object,
      version = version
    )
  }

  return(dp)
}
