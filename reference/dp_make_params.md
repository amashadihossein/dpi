# Make dp params to connect to the Data Product Board

Make dp params to connect to the Data Product Board. This is needed
prior to interacting with the content of the board.

## Usage

``` r
dp_make_params(
  github_repo_url,
  repo_token = Sys.getenv("GITHUB_PAT"),
  branch_name = NULL
)
```

## Arguments

- github_repo_url:

  Repository URL

- repo_token:

  Personal Access Token (PAT) needed to access the contents of the
  private repository

- branch_name:

  Branch name of the data product repository

## Value

Named list of dp params

## Examples

``` r
if (FALSE) { # \dontrun{
github_repo_url <- "https://github.com/<USERNAME>/<REPOSITORY NAME>"
dp_params <- dp_make_params(github_repo_url = github_repo_url, 
                            repo_token = Sys.getenv("GITHUB_PAT"))
} # }
```
