test_that("Local board params are built properly", {
  expect_snapshot(
    board_params_set_local(folder = "folder_name")
  )
})
  
test_that("Working dir (empty) as folder raises a warning", {
  expect_warning(
    board_params_set_local(folder = "")
  )
})

test_that("board_alias raises a deprecation error", {
  expect_error(
    board_params_set_local(folder = "folder_name", board_alias = "local-board"),
    regexp="deprecated"
  )
})
