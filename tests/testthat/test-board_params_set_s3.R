test_that("s3 board params are built properly", {
  expect_snapshot(
    board_params_set_s3(bucket_name = "bucket_name", region = "us-east-1")
  )
})

test_that("s3 board params are built properly with prefix", {
  expect_snapshot(
    board_params_set_s3(bucket_name = "bucket_name", prefix = "testPrefix/", region = "us-east-1")
  )
})
  
test_that("board_alias raises a deprecation error", {
  expect_error(
    board_params_set_s3(bucket_name = "bucket_name", region = "us-east-1",
                        board_alias = "s3-board"),
    regexp="deprecated"
  )
})

test_that("Unknown region name raises warning", {
  expect_warning(
    board_params_set_s3(bucket_name = "bucket_name", region = "fake-region"),
    regexp="availability zones"
  )
})

test_that("Empty bucket_name raises error", {
  expect_error(
    board_params_set_s3(bucket_name = "", region = "us-east-1"),
    regexp="bucket_name"
  )
})

test_that("Empty region raises error", {
  expect_error(
    board_params_set_s3(bucket_name = "bucket_name", region = ""),
    regexp="region"
  )
})

test_that("Prefix without trailing slash raises warning", {
  expect_error(
    board_params_set_s3(bucket_name = "bucket_name", prefix = "data-products", region = "us-east-1"),
    regexp = "trailing slash"
  )
  
  # No warning when prefix has trailing slash
  expect_no_error(
    board_params_set_s3(bucket_name = "bucket_name", prefix = "data-products/", region = "us-east-1")
  )
  
  # No warning when prefix is NULL
  expect_no_error(
    board_params_set_s3(bucket_name = "bucket_name", prefix = NULL, region = "us-east-1")
  )
})