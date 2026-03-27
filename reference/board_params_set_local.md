# Create formatted parameters that specify a local storage board

Build a data frame that contains all of the parameters needed to specify
a local storage pin board.

## Usage

``` r
board_params_set_local(folder, board_alias = deprecated())
```

## Arguments

- folder:

  The path to the local storage folder where the data product will be
  stored. NOTE: this folder should be treated as a permanent location
  with immutable content. For example, a data product git repo project
  folder *is not* an appropriate directory.

- board_alias:

  A short name for the board. **\[deprecated\]** this argument is
  deprecated with pins ≥ 1.0.

## Value

A data.frame with class "local_board" and a column for each param.

## Examples

``` r
if (FALSE) { # \dontrun{
board_params_set_local(folder = "xxxx")
} # }
```
