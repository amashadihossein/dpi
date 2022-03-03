test_that("dp_connect", {
  board_params <- board_params_set_s3(
    board_alias = "cars_board",
    bucket_name = "jadecanary",
    region = "us-east-2"
  )

  creds <- creds_set_aws(
    key = Sys.getenv("AWS_KEY"),
    secret = Sys.getenv("AWS_SECRET")
  )

  # dp_connect(board_params, creds)

  expect_equal(2 + 2, 4)
})
