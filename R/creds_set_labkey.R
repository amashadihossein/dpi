#' @title Generate Labkey Credentials
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Get credentials for LabKey board
#' @param api_key Labkey API key for the user
#' @return labkey_creds
#' @examples
#' \dontrun{
#' creds_set_labkey(api_key = Sys.getenv("LABKEY_API_KEY"))
#' }
#' @export
creds_set_labkey <- function(api_key) {
  lifecycle::deprecate_stop("0.1.0", "creds_set_labkey()",
                            details = downgrade_message(labkey = T))

  labkey_creds <- data.frame(api_key = api_key)

  class(labkey_creds) <- c("labkey_cred", class(labkey_creds))

  return(labkey_creds)
}
