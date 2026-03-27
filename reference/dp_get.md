# Get the data product from the remote pin board

Get a data product object from the provided remote pin board, including
input links and output data structure. By default get the latest
version, or get a particular version by specifying the version hash
(find available versions using `dp_list`).

## Usage

``` r
dp_get(board_object, data_name, version = NULL)
```

## Arguments

- board_object:

  A `pins_board` object from `dp_connect`.

- data_name:

  The name of the data product to get from the remote pin board, i.e.
  "dp-cars-us001". To get a list of data products available on the
  remote pin board, use `dp_list`.

- version:

  The hash specifying the data product version to get from the remote
  pin board. If `NULL`, `dp_get` will get the latest version available.
  To get a list of versions available for each data product on the
  remote pin board, use `dp_list`.

## Value

A data product object, which is a list with class `dp` and items
`input`, `output`, and `README`.

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
dp <- dp_get(board_object, data_name = "data-name")
} # }
```
