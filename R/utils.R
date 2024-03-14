#' helper function to return downgrade messages for lifecycle warnings
#' @param labkey T/F whether to include temporary labkey message
#' @noRd
downgrade_message <- function(labkey = F) {
  if (labkey) {
    return(c(
      " " = "LabKey functionality has been temporarily removed from daapr. To access a legacy
      data product, downgrade pins and dpi packages using:",
      " " = "remotes::install_github(repo = 'amashadihossein/pins')",
      " " = "remotes::install_github(repo = 'amashadihossein/dpi@v0.0.0.9008')",
      " " = "",
      " " = "To continue building a legacy data product, downgrade all daapr packages:",
      " " = "remotes::install_github(repo = 'amashadihossein/dpbuild@v0.0.0.9106')",
      " " = "remotes::install_github(repo = 'amashadihossein/dpdeploy@v0.0.0.9016')",
      " " = "remotes::install_github(repo = 'amashadihossein/daapr@v0.0.0.9006')"
    ))
  } else {
    return(c(
      " " = "This data product was built with a legacy version of pins. To access a legacy
      data product, downgrade pins and dpi packages using:",
      " " = "remotes::install_github(repo = 'amashadihossein/pins')",
      " " = "remotes::install_github(repo = 'amashadihossein/dpi@v0.0.0.9008')",
      " " = "",
      " " = "To continue building a legacy data product, downgrade all daapr packages:",
      " " = "remotes::install_github(repo = 'amashadihossein/dpbuild@v0.0.0.9106')",
      " " = "remotes::install_github(repo = 'amashadihossein/dpdeploy@v0.0.0.9016')",
      " " = "remotes::install_github(repo = 'amashadihossein/daapr@v0.0.0.9006')"
    ))
  }
}


#' @title Hydrate a dried called function
#' @description execute and returns the value of function call given its textual
#'  (dried) representation
#' @param fn_called a function called
#' @return value of the called function given its textual representation
#' @examples \dontrun{
#' fn_hydrate(fn_dry(sum(log(1:10))))
#' }
#' @keywords internal
fn_hydrate <- function(dried_fn) {
  return(eval(rlang::parse_expr(dried_fn)))
}
