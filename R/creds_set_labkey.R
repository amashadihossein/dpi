#' @title Generate Labkey Credentials
#' @param api_key Labkey API key for the user
#' @return labkey_creds
#' @examples
#' \dontrun{creds_set_labkey (api_key = Sys.getenv("LABKEY_API_KEY"))}
#' @export
creds_set_labkey <- function(api_key){

  labkey_creds <- data.frame(api_key = api_key)

  class(labkey_creds) <-  c("labkey_cred", class(labkey_creds))

  return(labkey_creds)
}
