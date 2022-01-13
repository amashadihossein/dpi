test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("dp_list", {

  board_params <- board_params_set_s3(board_alias = "cars_board",
                                      bucket_name = "jadecanary",
                                      region = "us-east-2")

  dp_list(board_params)
})
