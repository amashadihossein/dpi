#' @title Make dp params to connect to the Data Product Board
#' @description Make dp params to connect to the Data Product Board. This is needed
#' prior to interacting with the content of the board.
#' @param url Repository URL
#' @param repo_token Personal Access Token (PAT) needed to access the contents of
#' the private repository
#' @param branch_name Branch name of the data product repository
#' @return Named list of dp params
#'
#' @examples
#' \dontrun{
#' url <- "https://github.com/<USERNAME>/<REPOSITORY NAME>"
#' dp_params <- dp_make_params(url = url, repo_token = Sys.getenv("GITHUB_PAT"))
#' @export

dp_make_params <- function(url, repo_token=Sys.getenv("GITHUB_PAT"), branch_name=NULL){

  check_http_error <- httr::http_error(url)
  GITHUB_API_URL <- "https://api.github.com"

  if (missing(url)){
    stop(cli::cli_alert_danger("url parameter cannot be missing"))
  }

  domain_components <- httr::parse_url(url)

  hostname <- domain_components$hostname

  is_enterprise_server <- !grepl(pattern = hostname, x=GITHUB_API_URL, fixed = T)

  str_split_hostname <- unlist(stringr::str_split(domain_components$hostname, pattern = "\\."))
  top_level_domain <- paste0(".", str_split_hostname[length(str_split_hostname)])
  split_github_url <- unlist(stringr::str_split(url, pattern = top_level_domain))

  OWNER <- unlist(stringr::str_split(split_github_url[2], pattern = "/"))[2]
  REPO <- unlist(stringr::str_split(split_github_url[2], pattern = "/"))[3]

  if (is_enterprise_server) {
    api_url <- paste0(split_github_url[1], top_level_domain, "/api/v3")
    path_api_url_branches <- file.path(api_url,"repos", OWNER, REPO, "branches")
  } else {
    path_api_url_branches <- file.path(GITHUB_API_URL,"repos", OWNER, REPO, "branches")
  }

  if(check_http_error) {
    retrieve_branch_name <- httr::GET(
      path_api_url_branches,
      httr::add_headers(Authorization = paste("token", repo_token)
      )
    )
  } else {
    retrieve_branch_name <- httr::GET(path_api_url_branches)
  }

  http_status_code <- httr::status_code(retrieve_branch_name)

  if (http_status_code != 200) {
    stop(cli::cli_alert_danger("GITHUB PAT is not found in R environment or not correctly set up.
        Make sure to pass repo_token or set up GITHUB_PAT env var if this is a private repo. For e.g. using Sys.setenv()"))
  }

  if (is.null(branch_name)) {
    all_branches <- httr::content(retrieve_branch_name)

    list_all_branches <- list()
    for (branch in 1:length(all_branches)){
      bn <- all_branches[[branch]]$name
      list_all_branches[[branch]] <- bn
    }

    select_branch_name <- function(list_all_branches) {
      user_input <- utils::menu(
        choices = unlist(list_all_branches),
        title = glue::glue(
          "Multiple branches have been found.\
          Which branch do you want to use?"
        ),
        graphics = F
      )

      final_branch_name <- unlist(list_all_branches)[user_input]
      cli::cli_alert_warning(glue::glue("`{final_branch_name}` branch was selected to be used."))
      return(final_branch_name)
    }

    selected_branch_name <- select_branch_name(list_all_branches = list_all_branches)
  } else {
    selected_branch_name <- branch_name
  }

  raw_string <- "raw"
  yaml_config_tail <- ".daap/daap_config.yaml"
  yaml_log_tail <- ".daap/daap_log.yaml"

  split_github_url_dotcom <- paste0(split_github_url[1], top_level_domain)
  raw_githubusercontent <- paste0(raw_string,".githubusercontent",top_level_domain)

  if (is_enterprise_server) {
    path_repo_config <- file.path(split_github_url_dotcom, raw_string,split_github_url[2], selected_branch_name, yaml_config_tail)
  } else {
    path_repo_config <- file.path("https://", raw_githubusercontent,split_github_url[2], selected_branch_name, yaml_config_tail)
  }

  if(check_http_error) {
    read_config_from_repo <- yaml::yaml.load(httr::GET(
      path_repo_config,
      httr::add_headers(Authorization = paste("token", repo_token))
    )
    )
  } else {
    read_config_from_repo <- yaml::yaml.load(httr::GET(path_repo_config))
  }

  if (is_enterprise_server) {
    path_log <- file.path(split_github_url_dotcom, raw_string,split_github_url[2], selected_branch_name, yaml_log_tail)
  } else {
    path_log <- file.path("https://", raw_githubusercontent,split_github_url[2], selected_branch_name, yaml_log_tail)
  }

  if(check_http_error) {
    read_repo_config_log <- yaml::yaml.load(httr::GET(
      path_log,
      httr::add_headers(Authorization = paste("token", repo_token))
    )
    )
  } else {
    read_repo_config_log <- yaml::yaml.load(httr::GET(path_log))
  }

  data_name <- unlist(unname((read_repo_config_log)[[length(read_repo_config_log)]]['dp_name']))
  latest_pin_version <- unlist(unname(read_repo_config_log[[length(read_repo_config_log)]]["pin_version"]))

  board_params <- read_config_from_repo$board_params_set_dried
  creds <- read_config_from_repo$creds_set_dried

  params_list <- list(
    board_params=fn_hydrate(board_params),
    creds=fn_hydrate(creds),
    data_name=data_name,
    latest_pin_version=latest_pin_version
  )

  check_if_creds_empty <- unname(unlist((params_list$creds))) == ""

  if (all(check_if_creds_empty)) {
    cli::cli_alert_warning(glue::glue("Warning: Creds value is missing. Make sure that you set creds in your R environment as described in daapr vignettes."))
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

