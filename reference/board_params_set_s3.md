# Create formatted parameters that specify an s3 bucket board

Build a data frame that contains all of the parameters needed to specify
an s3 bucket pin board. The function validates the provided parameters
and returns a standardized data frame for use with other daapr
functions.

## Usage

``` r
board_params_set_s3(
  bucket_name,
  prefix = NULL,
  region,
  board_alias = deprecated()
)
```

## Arguments

- bucket_name:

  The name of the s3 bucket where the data product will be stored. Must
  be a non-empty string.

- prefix:

  The prefix within this bucket where the data product will be stored.
  Typically ends with `/` for S3 directory handling. Optional, defaults
  to NULL.

- region:

  The AWS region where the s3 bucket was created, e.g. "us-east-1" or
  "us-west-1". Must be a non-empty string. The function will check if
  the provided region is in the list of known AWS availability zones and
  issue a warning if it's not.

- board_alias:

  A short name for the board. **\[deprecated\]** This argument is
  deprecated with pins ≥ 1.0 and will be removed in a future version.
  Using this parameter will result in an error.

## Value

A data.frame with class "s3_board" and columns for:

- board_type: Always set to "s3_board"

- bucket_name: The provided S3 bucket name

- prefix: The provided prefix (or NULL if not specified)

- region: The provided AWS region

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage with required parameters
board_params_set_s3(
  bucket_name = "my-bucket-name",
  region = "us-east-1"
)

# With optional prefix parameter
board_params_set_s3(
  bucket_name = "my-bucket-name",
  prefix = "data-products/",
  region = "us-east-1"
)
} # }
```
