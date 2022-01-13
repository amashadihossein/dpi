test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("multiplication works", {

  board_alias <- "a"
  bucket_name <- "b"
  region <-  "us-east-2"

  board_params <- board_params_set_s3(board_alias, bucket_name, region)

  dpconnect_check(board_params)

  expect_equal(2 * 2, 4)
})
