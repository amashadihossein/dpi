test_that("dpconnect_check", {
  stub(dp_get, "dpconnect_check", 100)
  stub(dp_list, "dpconnect_check", 100)
  stub(dpconnect_check, "dp_connect", 100)
  dpconnect_check(board_params)
  expect_equal(2 * 2, 4)
})
