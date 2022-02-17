#' @title Generate Local Credentials
#' @param api_key Local API key for the user
#' @return local_creds
#' @examples
#' \dontrun{creds_set_local(api_key = Sys.getenv("LABKEY_API_KEY"))}
#' @export
creds_set_local <- function(api_key){

  local_creds <- data.frame(api_key = api_key)

  class(local_creds) <-  c("local_cred", class(local_creds))

  return(local_creds)
}
