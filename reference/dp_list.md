# List data products on a remote pin board

List all available data products and their details from a remote pin
board. You must connect to the remote pin board using `dp_connect`
first. Details include data product name, version hashes, branch names,
sha1 hashes for the stored data objects, deployment time, and Git commit
details like author, commit message, and commit hash. The details
returned are read from the `dpboard-log` pin on the remote pin board.

## Usage

``` r
dp_list(board_object)
```

## Arguments

- board_object:

  A `pins_board` object from `dp_connect`.

## Value

A tibble with one row per version per data product from the remote pin
board. Each row contains metadata for the given version of the given
data product.

## Examples

``` r
if (FALSE) { # \dontrun{
aws_creds <- creds_set_aws(
  key = Sys.getenv("AWS_KEY"),
  secret = Sys.getenv("AWS_SECRET")
)
board_params <- board_params_set_s3(
  bucket_name = "bucket_name",
  region = "us-east-1"
)
board_object <- dp_connect(board_params, aws_creds)
dp_list(board_object)
} # }
```
