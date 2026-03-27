# Create formatted credentials for connecting to an s3 bucket board

Build a data frame that contains all of the credentials needed to
connect to an s3 bucket pin board. Additionally, it ensures the minimum
requirement that either a named profile or a set of AWS key and secret
are provided. If a named profile is provided, the key and secret will be
ignored.

## Usage

``` r
creds_set_aws(
  profile_name = character(0),
  key = character(0),
  secret = character(0)
)
```

## Arguments

- profile_name:

  The name of an AWS credentials profile for the s3 bucket where the
  data product is stored. This is a name associated with a set of
  credentials within the .aws/credentials files in your home directory.
  See the [AWS CLI credentials file
  documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
  for more information.

- key:

  The AWS Access Key ID associated with your access to the s3 bucket
  where the data product is stored.

- secret:

  The AWS Secret Access Key associated with your access to the s3 bucket
  where the data product is stored.

## Value

A data.frame with class "aws_creds" and a column for each param.

## Examples

``` r
if (FALSE) { # \dontrun{
aws_creds <- creds_set_aws(
  key = Sys.getenv("AWS_KEY"),
  secret = Sys.getenv("AWS_SECRET")
)
} # }
```
