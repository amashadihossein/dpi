# Create formatted credentials for connecting to a LabKey board

Build a data frame that contains all of the credentials needed to
connect to a LabKey server pin board.

## Usage

``` r
creds_set_labkey(api_key)
```

## Arguments

- api_key:

  A LabKey API key for connecting to the LabKey server where the data
  product is stored. See the [LabKey documentation on API
  keys](https://www.labkey.org/Documentation/wiki-page.view?name=apikey)
  for more information on generating a LabKey API key.

## Value

A data.frame with class "labkey_cred" and a column for each param.

## Examples

``` r
if (FALSE) { # \dontrun{
creds_set_labkey(api_key = Sys.getenv("LABKEY_API_KEY"))
} # }
```
