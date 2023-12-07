# This won't work if test bucket creds are not set up

test_that("creds_set_aws with s3 board", {
  creds <- creds_set_aws(
    key = Sys.getenv("AWS_KEY"),
    secret = Sys.getenv("AWS_SECRET")
  )

  expect_s3_class(creds, "data.frame")
  expect_s3_class(creds, "aws.creds")
  expect_named(creds, c("profile_name", "key", "secret"))
})

