#' @title Generate Properly Formatted Board Parameters
#' @description This function simply provides a consistent format for the board
#' parameters
#' @param bucket_name name of the s3 bucket
#' @param region AWS region for the s3 bucket e.g. "us-east-1" or "us-west-1"
#' @param board_alias `r lifecycle::badge("deprecated")` this argument is deprecated with newer pins
#' @return A data.frame with properly formatted board_params
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

  if (!isTRUE(region %in% aws_availability_zones)) {
    av_zones <- paste0(aws_availability_zones, collapse = ", ")
    warning(cli::format_warning(glue::glue(
      "region {region} is not in recorded ",
      "AWS availibility zones. Check the ",
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
