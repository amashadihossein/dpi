#' @title Create formatted parameters that specify an s3 bucket board
#'
#' @description Build a data frame that contains all of the parameters
#'   needed to specify an s3 bucket pin board. The function validates the
#'   provided parameters and returns a standardized data frame for use with
#'   other daapr functions.
#'
#' @param bucket_name The name of the s3 bucket where the data product will be
#'   stored. Must be a non-empty string.
#' @param prefix The prefix within this bucket where the data product will be 
#'   stored. Typically ends with `/` for S3 directory handling. Optional, defaults
#'   to NULL.
#' @param region The AWS region where the s3 bucket was created, e.g.
#'   "us-east-1" or "us-west-1". Must be a non-empty string. The function will
#'   check if the provided region is in the list of known AWS availability zones
#'   and issue a warning if it's not.
#' @param board_alias A short name for the board.
#'   `r lifecycle::badge("deprecated")` This argument is deprecated with
#'   pins ≥ 1.0 and will be removed in a future version. Using this parameter
#'   will result in an error.
#'
#' @return A data.frame with class "s3_board" and columns for:
#'   \itemize{
#'     \item board_type: Always set to "s3_board"
#'     \item bucket_name: The provided S3 bucket name
#'     \item prefix: The provided prefix (or NULL if not specified)
#'     \item region: The provided AWS region
#'   }
#'
#' @examples
#' \dontrun{
#' # Basic usage with required parameters
#' board_params_set_s3(
#'   bucket_name = "my-bucket-name",
#'   region = "us-east-1"
#' )
#' 
#' # With optional prefix parameter
#' board_params_set_s3(
#'   bucket_name = "my-bucket-name",
#'   prefix = "data-products/",
#'   region = "us-east-1"
#' )
#' }
#' @export
board_params_set_s3 <- function(bucket_name, prefix = NULL, region, board_alias = deprecated()) {
  if (lifecycle::is_present(board_alias)) {
    lifecycle::deprecate_stop("0.1.0", "board_params_set_s3(board_alias)",
                              details = downgrade_message())
  }

  if (bucket_name == ""){
    stop(cli::format_error("Non-empty bucket_name must be provided."))
  }

  if (region == ""){
    stop(cli::format_error("Non-empty region must be provided."))
  }

  if (!isTRUE(region %in% aws_availability_zones)) {
    av_zones <- paste0(aws_availability_zones, collapse = ", ")
    warning(cli::format_warning(glue::glue(
      "region '{region}' is not in recorded ",
      "AWS availability zones. Check the ",
      "region! Recorded regions are:\n
      {av_zones}"
    )))
  }

  # If prefix is provided, check that it ends with a trailing slash
  if (!is.null(prefix) && nchar(prefix) > 0 && !endsWith(prefix, "/")) {
    stop(cli::format_warning(glue::glue(
      "prefix '{prefix}' must end with a trailing slash ",
      "to avoid issues with S3 directory handling."
    )), call. = FALSE)
  }

  # Create the data frame with explicit lengths to avoid row count issues
  board_params <- data.frame(
    board_type = "s3_board",
    bucket_name = bucket_name,
    prefix = if (is.null(prefix)) NA_character_ else prefix,
    region = region,
    stringsAsFactors = FALSE
  )

  class(board_params) <- c("s3_board", class(board_params))
  return(board_params)
}
