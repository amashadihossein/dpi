# This won't work if test bucket board params are not set up

test_that("board_params_set_s3 with s3 board", {
    board_params <- board_params_set_s3(
      bucket_name = "daapr-test",
      region = "us-east-1"
    )

  expect_s3_class(board_params, "data.frame")
  expect_s3_class(board_params, "s3_board")
  expect_named(board_params, c("board_type", "bucket_name", "region"))
})



