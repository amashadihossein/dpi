# Connect to the data product pin board

Connect to the pin board storing the data product. This is necessary
prior to interacting with the content of the pin board. Behind the
scenes, the appropriate `pins::board_*` function is used to connect to
the pin board after any required credentials are set up.

## Usage

``` r
dp_connect(board_params, creds, ...)
```

## Arguments

- board_params:

  The parameters specifying a pin board to connect to. This pin board is
  where the data product is stored. A `*_board` data.frame of the format
  returned by a `board_params_set_*` function. Use
  `board_params_set_s3`, `board_params_set_labkey`, or
  `board_params_set_local` to specify board parameters.

- creds:

  The credentials required to connect to the pin board location. A
  `creds_*` data.frame of the format returned by a `creds_set_*`
  function. Use `creds_set_aws` or `creds_set_labkey` to set the
  appropriate credentials. Can be NULL for a local board, since creds
  are not required for local storage.

- ...:

  other parameters to pass through to the specific `dp_connect.*`
  method.

## Value

A `pins_board` object, which will be passed as an argument to other
functions that read and write the data product.

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
} # }
```
