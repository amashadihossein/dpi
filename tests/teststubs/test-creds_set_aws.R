test_that("creds_set_aws", {
  creds_set_aws(profile_name = character(0), key = character(0), secret = character(0))
  expect_equal(2 * 2, 4)
})
