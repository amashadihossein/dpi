test_that("dpconnect_check when not connected", {
  expect_snapshot(dpconnect_check(list(board_alias = "test_board")),
                  error = T)
})

test_that("dpconnect_check with local board", {
  # temporary tempfile, deleted at the end of the test
  path <- withr::local_tempfile()
  board_params <- board_params_set_local(
    board_alias = "local_test_board",
    folder = path
  )
  # make sure we can connect first
  # this will create daap/ directory under path tempdir
  expect_true(dp_connect(board_params = board_params))

  # result from dpconnect_check is a list of class local
  connect_result <- dpconnect_check(board_params)
  expect_s3_class(connect_result, "local")
  expect_named(connect_result, c("board", "name", "cache", "versions"))
  expect_equal(connect_result$name, "local_test_board")
})
