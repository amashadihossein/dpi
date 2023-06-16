#' @title Connect to the Data Product Board
#' @description Connect to the board housing the data product. This is needed
#' prior to interacting with the content of the board.
#' @param creds use `creds_set_aws` or `creds_set_labkey` to set this. When using
#' a local board, creds is ignored and does not need to be specified.
#' @param board_params use `board_params_set_s3`, `board_params_set_labkey`, or
#' `board_params_set_local` to specify board parameters. It contains the information
#' for the board on which the data product is pinned.
#' @param ... other parameters
#' @return TRUE
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
#' }
#' @export
dp_connect <- function(board_params, creds, ...) {
  ellipsis::check_dots_used()
  UseMethod("dp_connect")
}



#' @export
dp_connect.s3_board <- function(board_params, creds, ...) {
  args <- list(...)
  board_subdir <- "daap"
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

  # Register the board
  tryCatch({
    board <- pins::board_s3(
      prefix = file.path(board_subdir,"/"),
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
      cli::cli_alert_warning("Networking constraints (e.g. vpn) may be blocking communication.")
      cli::cli_alert_danger(cond)
    }
  )
  # return(TRUE)
}


#' @export
dp_connect.labkey_board <- function(board_params, creds, ...) {
  args <- list(...)
  board_subdir <- "daap"
  if (length(args$board_subdir) > 0) {
    board_subdir <- args$board_subdir
  }

  # Register the board
  pins::board_register(
    board = "labkey",
    name = board_params$board_alias,
    api_key = creds$api_key,
    base_url = board_params$url,
    folder = board_params$folder,
    versions = T,
    path = board_subdir
  )

  return(TRUE)
}


#'@export
dp_connect.local_board <- function(board_params, creds = NULL, ...){

  args <- list(...)
  board_subdir <- "daap"
  if(length(args$board_subdir) >0)
    board_subdir <- args$board_subdir

  # Register the board
  pins::board_register(board = "local",
                       name = board_params$board_alias,
                       cache =  file.path(board_params$folder, board_subdir),
                       versions = T)


  return(TRUE)

}


