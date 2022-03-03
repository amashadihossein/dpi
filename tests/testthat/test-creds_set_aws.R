test_that("creds_set_aws", {
  expect_equal(length(
    creds_set_aws(
      key = Sys.getenv("AWS_KEY"),
      secret = Sys.getenv("AWS_SECRET")
    )
  ), 3)
})
