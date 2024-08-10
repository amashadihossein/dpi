#' @title Connect to the data product pin board
#'
#' @description Connect to the pin board storing the data product. This is
#'   necessary prior to interacting with the content of the pin board. Behind
#'   the scenes, the appropriate `pins::board_*` function is used to connect to
#'   the pin board after any required credentials are set up.
#'
#' @param creds The credentials required to connect to the pin board location.
#'   A `creds_*` data.frame of the format returned by a `creds_set_*` function.
#'   Use `creds_set_aws` or `creds_set_labkey` to set the appropriate
#'   credentials. Can be NULL for a local board, since creds are not required
#'   for local storage.
#' @param board_params The parameters specifying a pin board to connect to. This
#'   pin board is where the data product is stored. A `*_board` data.frame of
#'   the format returned by a `board_params_set_*` function. Use
#'   `board_params_set_s3`, `board_params_set_labkey`, or
#'   `board_params_set_local` to specify board parameters.
#' @param ... other parameters to pass through to the specific `dp_connect.*`
#'   method.
#'
#' @return A `pins_board` object, which will be passed as an argument to other
#'   functions that read and write the data product.
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
#' }
#' @export
dp_connect <- function(board_params, creds, ...) {
  ellipsis::check_dots_used()
  UseMethod("dp_connect")
}


#' @export
dp_connect.s3_board <- function(board_params, creds, ...) {
  args <- list(...)
  board_subdir <- "daap/"
  if (length(args$board_subdir) > 0) {
    board_subdir <- args$board_subdir
  }

  aws_creds <- creds

  if (aws_creds$profile_name != "") {
    key <-
      aws.signature::locate_credentials(profile = aws_creds$profile_name)$key
    secret <-
      aws.signature::locate_credentials(profile = aws_creds$profile_name)$secret
  } else {
    key <- aws_creds$key
    secret <- aws_creds$secret
  }

  # pins only checks for paws.storage in interactive sessions, so checking here
  if (!requireNamespace("paws.storage", quietly = TRUE)) {
    stop(
      "Package \"paws.storage\" must be installed to use s3 boards.",
      call. = FALSE
    )
  }
  # Register the board
  tryCatch({
    board <- pins::board_s3(
      prefix = board_subdir,
      bucket = board_params$bucket_name,
      region = board_params$region,
      access_key = key,
      secret_access_key = secret,
      versioned = T
    )
    return(board)
  },
    error = function(cond) {
      cli::cli_alert_danger("Encountered error in dp_connect.")
      cli::cli_alert_warning("Make sure crendentials passed are correct.")
      cli::cli_alert_warning("Networking constraints (e.g. VPN) may be blocking communication.")
      cli::cli_alert_danger(cond)
    }
  )
}

#' @export
dp_connect.labkey_board <- function(board_params, creds, ...) {
  args <- list(...)
  board_subdir <- "daap"
  if (length(args$board_subdir) > 0) {
    board_subdir <- args$board_subdir
  }

  # Register the board
  tryCatch({
    board <- pinsLabkey::board_labkey(
      cache_alias = board_params$cache_alias,
      api_key = creds$api_key,
      base_url = board_params$url,
      folder = board_params$folder,
      versioned = T,
      subdir = board_subdir
      )
    return(board)
  },
  error = function(cond) {
    cli::cli_alert_danger("Encountered error in dp_connect.")
    cli::cli_alert_warning("Make sure crendentials passed are correct.")
    cli::cli_alert_warning("Networking constraints (e.g. VPN) may be blocking communication.")
    cli::cli_alert_danger(cond)
    }
  )
}


#'@export
dp_connect.local_board <- function(board_params, creds = NULL, ...){
  args <- list(...)
  board_subdir <- "daap"
  if(length(args$board_subdir) >0)
    board_subdir <- args$board_subdir

  # Register the board
  board <- pins::board_folder(path = file.path(board_params$folder, board_subdir),
                              versioned = TRUE)
  return(board)
}
