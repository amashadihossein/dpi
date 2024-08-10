#' @title Create formatted parameters that specify an s3 bucket board
#'
#' @description Build a data frame that contains all of the parameters
#'   needed to specify an s3 bucket pin board.
#'
#' @param bucket_name The name of the s3 bucket where the data product will be
#'   stored.
#' @param region The AWS region where the s3 bucket was created, e.g.
#'   "us-east-1" or "us-west-1".
#' @param board_alias A short name for the board.
#'   `r lifecycle::badge("deprecated")` this argument is deprecated with
#'   pins ≥ 1.0.
#'
#' @return A data.frame with class "s3_board" and a column for each param.
#'
#' @examples
#' \dontrun{
#' board_params_set_s3(
#'   bucket_name = "bucket_name",
#'   region = "us-east-1"
#' )
#' }
#' @export
board_params_set_s3 <- function(bucket_name, region, board_alias = deprecated()) {
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

  board_params <- data.frame(
    board_type = "s3_board",
    bucket_name = bucket_name, region = region,
    stringsAsFactors = FALSE
  )

  class(board_params) <- c("s3_board", class(board_params))
  return(board_params)
}
