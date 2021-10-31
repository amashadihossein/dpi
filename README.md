
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dpi

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of dpi is to provide a programmatic interface to data object
built within Data-as-a-Product framework

## Installation

For released version

``` r
remotes::install_git(url = "https://github.com/amashadihossein/dpi.git")
```

For released version

``` r
remotes::install_git(url = "https://github.com/amashadihossein/dpi.git", ref = "dev")
```

## Example

``` r
library(dpi)

#Add your AWS profile name. If you don't have a named profile, you can provide your AWS credentials
aws_creds <- creds_set_aws(key = Sys.getenv("AWS_KEY"),
                                secret = Sys.getenv("AWS_SECRET"))

# Get the list of board parameters
board_params_s3 <- board_params_set_s3(board_alias = "an_alias_for_data_board",
                                 bucket_name = "bucket_name",
                                 region = "specific_region") # e.g. "us-east-1"

# Connect to the board
dp_connect(board_params = board_params,creds = aws_creds)

# List what's available
dp_list(board_params = board_params)

# Retrieve the latest data. Alternatively retrieve specific version by passing 
# the version id to dp_get
dp_get(data_name = "dp-studyid_branchid", 
            board_params = board_params_s3, 
            version = "specific_version") # e.g. "c5a51c3"
```
