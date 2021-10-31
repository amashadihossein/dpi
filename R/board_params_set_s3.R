#' @title Generate Properly Formatted Board Parameters
#' @description This function simply provides a consistent format for the board 
#' parameters
#' @param board_alias name of the board
#' @param bucket_name name of the s3 bucket
#' @param region AWS region for the s3 bucket e.g. "us-east-1" or "us-west-1"
#' @return A data.frame board_params
#' @examples
#' \dontrun{
#' board_params_set_s3(board_alias = "board_alias",
#'   bucket_name = "bucket_name", region = "us-east-1")
#' }
#' @export
board_params_set_s3 <- function(board_alias, bucket_name, 
                                region = c("us-east-1", "us-west-1")){

  region <- match.arg(region, several.ok = F)

  board_params <- data.frame(board_type = "s3_board", board_alias = board_alias,
                             bucket_name = bucket_name, region = region, 
                             stringsAsFactors = FALSE)
  
  class(board_params) <- c("s3_board",class(board_params))
  return(board_params)
}

