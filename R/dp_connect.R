#' @title Connect to the data product board
#' @description Connect to the board housing the data product. This is needed 
#' prior to interacting with the content of the board.
#' @param creds When `local_board`, creds is ignored and need to be specified. 
#' Otherwise, use creds_set_aws() or creds_set_labkey() to set this. It should
#' contain credentials needed to access the remote where the dp is pinned.
#' @param board_params use `board_params_set_s3` or `board_params_set_labkey` 
#' for this. It contains the parameters for the board on which the data product 
#' is pinned
#' @param ... other parameters
#' @return TRUE
#'
#' @examples
#' \dontrun{
#' aws_creds <- creds_set_aws(key = Sys.getenv("AWS_KEY"),
#' secret = Sys.getenv("AWS_SECRET"))
#' board_params <- board_params_set_s3(board_alias = "board_alias",
#'   bucket_name = "bucket_name", region = "us-east-1")
#' dp_connect(board_params, aws_creds)
#' }
#' @export

dp_connect <- function(board_params, creds, ...){
  ellipsis::check_dots_used()
  UseMethod("dp_connect")
}



#'@export
dp_connect.s3_board <- function(board_params, creds, ...){
  
  args <- list(...)
  board_subdir <- "daap"
  if(length(args$board_subdir) >0)
    board_subdir <- args$board_subdir
  
  aws_creds <- creds


  if(aws_creds$profile_name != ""){
    key <- 
      aws.signature::locate_credentials(profile = aws_creds$profile_name)$key
    secret <-
      aws.signature::locate_credentials(profile = aws_creds$profile_name)$secret
  }else{
    key <- aws_creds$key
    secret <- aws_creds$secret
  }

  # Register the board
  pins::board_register(board = "s3",
                       name = board_params$board_alias,
                       bucket = board_params$bucket_name,
                       versions = T,
                       key = key,
                       secret = secret,
                       path = board_subdir,
                       region = board_params$region)


  return(TRUE)

}



#'@export
dp_connect.labkey_board <- function(board_params, creds, ...){

  args <- list(...)
  board_subdir <- "daap"
  if(length(args$board_subdir) >0)
    board_subdir <- args$board_subdir
  
  # Register the board
  pins::board_register(board = "labkey",
                       name = board_params$board_alias,
                       api_key = creds$api_key,
                       base_url = board_params$url,
                       folder =  board_params$folder,
                       versions = T,
                       path = board_subdir)


  return(TRUE)

}


#'@export
dp_connect.local_board <- function(board_params, creds = character(0), ...){
  
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


