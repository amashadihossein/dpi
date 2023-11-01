
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dpi

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/amashadihossein/dpi/workflows/R-CMD-check/badge.svg)](https://github.com/amashadihossein/dpi/actions)
<!-- badges: end -->

The goal of `dpi` is to provide a programmatic interface to data
products built within Data-as-a-Product framework

## Installation

For released version

``` r
remotes::install_github("amashadihossein/dpi")
```

For dev version

``` r
remotes::install_github("amashadihossein/dpi", ref = "dev")
```

## Example

``` r
library(dpi)

# Add your AWS profile name. If you don't have a named profile, you can provide your AWS credentials
aws_creds <- creds_set_aws(
  key = Sys.getenv("AWS_KEY"),
  secret = Sys.getenv("AWS_SECRET")
)

# Get the list of board parameters
board_params <- board_params_set_s3(
  bucket_name = "bucket_name",
  region = "specific_region" # e.g. "us-east-1"
)

# Connect to the board
board_object <- dp_connect(board_params = board_params, creds = aws_creds)

# List what's available on the board
dp_list(board_object = board_object)

# Retrieve the latest data. Alternatively retrieve specific version by passing
# the version id to dp_get
dp_get(
  board_object = board_object,
  data_name = "dp-studyid_branchid",
  version = "specific_version" # e.g. "c5a51c3"
)
```

## Related documentation

- `daapr`: <https://amashadihossein.github.io/daapr/>
- `dpbuild`: <https://amashadihossein.github.io/dpbuild/>
- `dpdeploy`: <https://amashadihossein.github.io/dpdeploy/>
