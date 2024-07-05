library(testthat)

test_that("board_params_set_labkey sets the correct parameters", {
  # Create a mock object for the LabKey API
  labkey_api <- list(
    setParameters = function(url, params) {
      # Check if the parameters are set correctly
      expect_equal(params$param1, "value1")
      expect_equal(params$param2, "value2")
    }
  )
  
  # Call the function with the mock API
  board_params_set_labkey(labkey_api)
})