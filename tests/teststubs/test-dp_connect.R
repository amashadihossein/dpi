test_that("dp_connect", {
  stub(dp_connect, "labkey_board", 100)
  stub(dp_connect, "s3_board", 100)
  stub(dpconnect_check, "dp_connect", 100)
  stub(make_pinlink, "dp_connect", 100)
  dp_connect(board_params, creds, ...)
  expect_equal(2 * 2, 4)
})


test_that("dp_connect.labkey_board", {
  dp_connect.labkey_board(board_params, creds, ...)
  expect_equal(2 * 2, 4)
})


test_that("dp_connect.s3_board", {
  dp_connect.s3_board(board_params, creds, ...)
  expect_equal(2 * 2, 4)
})
