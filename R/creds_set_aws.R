#' @title Create formatted credentials for connecting to an s3 bucket board
#'
#' @description Build a data frame that contains all of the credentials
#'   needed to connect to an s3 bucket pin board. Additionally, it ensures the
#'   minimum requirement that either a named profile or a set of AWS key and
#'   secret are provided. If a named profile is provided, the key and secret
#'   will be ignored.
#'
#' @param profile_name The name of an AWS credentials profile for the s3 bucket
#'   where the data product is stored. This is a name associated with a set of
#'   credentials within the .aws/credentials files in your home directory. See
#'   the [AWS CLI credentials file documentation](
#'   https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
#'   for more information.
#' @param key The AWS Access Key ID associated with your access to the s3 bucket
#'   where the data product is stored.
#' @param secret The AWS Secret Access Key associated with your access to the s3
#'   bucket where the data product is stored.
#'
#' @return A data.frame with class "aws_creds" and a column for each param.
#'
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
