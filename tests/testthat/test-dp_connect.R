test_that("dp_connect with s3 board", {
  board_params <- board_params_set_s3(
    bucket_name = "daapr-test",
    region = "us-east-1"
  )
  creds <- creds_set_aws(
    key = Sys.getenv("AWS_KEY"),
    secret = Sys.getenv("AWS_SECRET")
  )

  # check board object is structured as expected
  board_obj <- dp_connect(board_params = board_params, creds = creds)
  expect_s3_class(board_obj, "pins_board_s3")
  expect_named(board_obj, c('board', 'api', 'cache', 'versioned', 'name',
                                 'bucket', 'prefix', 'svc'))
  expect_equal(board_obj$bucket, "daapr-test")
  expect_equal(board_obj$prefix, "daap/")
})

# Need to generate snapshot first before adding this test
test_that("dp_connect with s3 board with bad creds", {
  board_params <- board_params_set_s3(
    bucket_name = "daapr-test",
    region = "us-east-1"
  )

  # invalid key/secret
  withr::local_envvar(c("AWS_KEY" = "12345678",
                        "AWS_SECRET" = "1234567890"))
  creds <- creds_set_aws(
    key = Sys.getenv("AWS_KEY"),
    secret = Sys.getenv("AWS_SECRET")
  )

  # Should get an error message here, but not an actual error
  expect_snapshot(dp_connect(board_params = board_params, creds = creds))
})
