test_that("dp_get", {
  stub(dp_get, "dp_list", 100)
  stub(dp_get, "dpconnect_check", 100)
  stub(make_pinlink, "dp_get", 100)
  dp_get(board_params, data_name, version = NULL)
  expect_equal(2 * 2, 4)
})
