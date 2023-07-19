test_that("dp_get with s3 board", {
  board_params <- board_params_set_s3(
    bucket_name = "daapr-test",
    region = "us-east-1"
  )
  creds <- creds_set_aws(
    key = Sys.getenv("AWS_KEY"),
    secret = Sys.getenv("AWS_SECRET")
  )

  # set up board
  board_obj <- dp_connect(board_params = board_params, creds = creds)

  # TODO: Create a test dp before this can be tested.
  data_name <- "dp-test-default"
  # dp_get_output <- dpi::dp_get(board_object = board_obj,
  #   data_name = data_name)
  # testthat::expect_s3_class(dp_get_output, c("dp", "list"))
  # expect_named(dp_list, c("README", "input", "output"))
})

