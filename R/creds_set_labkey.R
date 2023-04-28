#' @title Generate LabKey Credentials
#' @param api_key LabKey API key for the user
#' @return A data.frame containing properly formatted LabKey credentials
#' @examples
#' \dontrun{
#' creds_set_labkey(api_key = Sys.getenv("LABKEY_API_KEY"))
#' }
#' @export
creds_set_labkey <- function(api_key) {
  labkey_creds <- data.frame(api_key = api_key)

  class(labkey_creds) <- c("labkey_cred", class(labkey_creds))

  return(labkey_creds)
}
