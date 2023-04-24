#' @title Make dp params to connect to the Data Product Board
#' @description Make dp params to connect to the Data Product Board. This is needed
#' prior to interacting with the content of the board.
#' @param url Repository URL
#' @param repo_token Personal Access Token (PAT) needed to access the contents of
#' the private repository
#' @return Named list of dp params
#'
#' @examples
#' \dontrun{
#' url <- "https://github.com/<USERNAME>/<REPOSITORY NAME>"
#' dp_params <- dp_make_params(url = url, repo_token = Sys.getenv("GITHUB_PAT"))
#' @export

dp_make_params <- function(url, repo_token){

  check_http_error <- httr::http_error(url)

  if (missing(url)){
    stop(cli::cli_alert_danger("url parameter cannot be missing"))
  }

  if(missing(repo_token) & check_http_error) {
    stop(cli::cli_alert_danger("This dp repo may be a private repo. Please supply a token parameter."))
  }

  domain_components <- urltools::suffix_extract(urltools::domain(x = url))

  top_level_domain <- paste0(".", domain_components$suffix)
  split_github_url <- unlist(stringr::str_split(url, pattern = top_level_domain))

  api_url <- paste0(split_github_url[1], top_level_domain, "/api/v3")
  OWNER <- unlist(stringr::str_split(split_github_url[2], pattern = "/"))[2]
  REPO <- unlist(stringr::str_split(split_github_url[2], pattern = "/"))[3]
  path_api_url_branches <- file.path(api_url,"repos", OWNER, REPO, "branches")

  if(!missing(repo_token)) {
    if (repo_token == "") {
      warning("The `repo_token` parameter is empty.")
    }
    retrieve_branch_name <- httr::GET(
      path_api_url_branches,
      httr::add_headers(Authorization = paste("token", repo_token)
      )
    )
  } else {
    retrieve_branch_name <- httr::GET(path_api_url_branches)
  }

  branches_found <- httr::content(retrieve_branch_name)[[1]]['name']

  branch_name <- as.character(branches_found[[1]])
  print(unlist(unname(branches_found)))
  cli::cli_alert_warning(glue::glue("{length(branches_found)} branch/es found (see above). The `{branch_name}` is fetched."))

  if (length(branches_found) > 1) {
    print(unlist(unname(branches_found)))
    cli::cli_alert_danger(glue::glue("{length(branches_found)} branches found (see above).  The `{branch_name}` is fetched."))
  }

  raw_string <- "raw"
  yaml_config_tail <- ".daap/daap_config.yaml"
  yaml_log_tail <- ".daap/daap_log.yaml"

  split_github_url_dotcom <- paste0(split_github_url[1], top_level_domain)

  path_config <- file.path(split_github_url_dotcom, raw_string,split_github_url[2], branch_name, yaml_config_tail)

  if(!missing(repo_token)) {
    config_read <- yaml::yaml.load(httr::GET(
      path_config,
      httr::add_headers(Authorization = paste("token", repo_token))
    )
    )
  } else {
    config_read <- yaml::yaml.load(httr::GET(path_config))
  }

  path_log <- file.path(split_github_url_dotcom, raw_string,split_github_url[2], branch_name, yaml_log_tail)

  if(!missing(repo_token)) {
    config_log <- yaml::yaml.load(httr::GET(
      path_log,
      httr::add_headers(Authorization = paste("token", repo_token))
    )
    )
  } else {
    config_log <- yaml::yaml.load(httr::GET(path_log))
  }

  data_name <- unlist(unname((config_log)[[length(config_log)]]['dp_name']))
  latest_pin_version <- unlist(unname(config_log[[length(config_log)]]["pin_version"]))

  board_params <- config_read$board_params_set_dried
  creds <- config_read$creds_set_dried

  params_list <- list(
    board_params=fn_hydrate(board_params),
    creds=fn_hydrate(creds),
    data_name=data_name,
    latest_pin_version=latest_pin_version
  )

  check_if_creds_empty <- unname(unlist((params_list$creds))) == ""

  if (check_if_creds_empty) {
    warning("Creds not found. Make sure that you set creds in your R environment as described daapr vignettes.")
  }
  return(params_list)
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

