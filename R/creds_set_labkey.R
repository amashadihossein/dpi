#' @title Create formatted credentials for connecting to a LabKey board
#'
#' @description Build a data frame that contains all of the credentials
#'   needed to connect to a LabKey server pin board.
#'
#' @param api_key A LabKey API key for connecting to the LabKey server where the
#'   data product is stored. See the [LabKey documentation on API keys](
#'   https://www.labkey.org/Documentation/wiki-page.view?name=apikey) for more
#'   information on generating a LabKey API key.
#'
#' @return A data.frame with class "labkey_cred" and a column for each param.
#'
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
