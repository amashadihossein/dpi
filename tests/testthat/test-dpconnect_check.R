test_that("dpconnect_check when not connected", {
  expect_snapshot(dpconnect_check(list(board_alias = "test_board")),
                  error = T)
})
