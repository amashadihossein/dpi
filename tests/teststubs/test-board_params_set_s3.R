test_that("board_params_set_s3", {
  board_params_set_s3(board_alias, bucket_name, region)
  expect_equal(2 * 2, 4)
})
