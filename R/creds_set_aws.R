#' @title Generate Properly Formatted AWS Credentials
#' @description This function simply provides a consistent format for aws
#' credentials. Additionally, it ensures the minimum requirement of either
#' named profile or a set of AWS (key, secret) are provided. Note if named
#' profile is provided key and secret will be ignored.
#' @param profile_name AWS named profile for the bucket housing the data
#' product. This is a name associated with credential within .aws/credentials
#' (See AWS CLI configuring named profiles).
#' @param key aws key associated with your access to the bucket housing the
#' data product
#' @param secret aws secret associated with your access to the bucket housing
#' the data product
#' @return A data.frame aws_creds containing properly formatted AWS credentials
#' @examples
#' \dontrun{
#' aws_creds <- creds_set_aws(
#'   key = Sys.getenv("AWS_KEY"),
#'   secret = Sys.getenv("AWS_SECRET")
#' )
#' }
#' @export
creds_set_aws <- function(profile_name = character(0), key = character(0),
                          secret = character(0)) {
  if (!(length(profile_name) > 0 | length(key) > 0 & length(secret) > 0)) {
    stop(cli::format_error(glue::glue(
      "Either a named profile or both AWS ",
      "secret and key need to be provided"
    )))
  }


  if (length(profile_name) > 0) {
    aws_profiles <- try(aws.signature::read_credentials())
    if (inherits(aws_profiles, "try-error")) {
      stop(cli::format_error(glue::glue(
        "Failed to successfully retrieve AWS ",
        "named profiles. Either use key and ",
        "secret directly or ensure named ",
        "profiles are configured."
      )))
    }

    valid_profile_names <- names(aws_profiles)

    if (!profile_name %in% valid_profile_names) {
      stop(cli::format_error(glue::glue(
        "{profile_name} is not a valid ",
        "crudential name. Valid names are ",
        "{paste(valid_profile_names,collapse = \"\\n \")}"
      )))
    }

    aws_creds <- data.frame(
      profile_name = profile_name,
      key = "",
      secret = ""
    )

    return(aws_creds)
  }

  if (length(key) == 0 | length(secret) == 0) {
    stop(cli::format_error(glue::glue(
      "key has length {length(key)} and secret ",
      "has length {length(secret)}. Either ",
      "valid AWS (key, secret) pair or a valid",
      " AWS profile name is needed."
    )))
  }


  aws_creds <- data.frame(
    profile_name = "",
    key = key,
    secret = secret
  )

  class(aws_creds) <- c("aws_creds", class(aws_creds))

  return(aws_creds)
}
