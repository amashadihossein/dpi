test_that("dp_list", {
	stub(dp_get, 'dp_list', 100)
	stub(dp_list, 'dpconnect_check', 100)
	dp_list(board_params) 
	expect_equal(2 * 2, 4)
})


