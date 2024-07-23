test_that("LabKey params are built properly", {
  expect_snapshot(
    board_params_set_labkey(
      url = "https://learn.labkey.com/",
      folder = "folder_name"
    )
  )
})

test_that("LabKey params are built properly with cache_alias", {
  expect_snapshot(
    board_params_set_labkey(
      url = "https://learn.labkey.com/",
      folder = "folder_name",
      cache_alias = "labkey-board"
    )
  )
})

test_that("board_alias raises a deprecation error", {
  expect_error(
    board_params_set_labkey(board_alias = "labkey-board",
                            url = "https://learn.labkey.com/",
                            folder = "folder_name"),
    regexp="deprecated"
  )
})

test_that("Empty URL raises an error", {
  expect_error(
    board_params_set_labkey(
      url = "",
      folder = "folder_name"
    )
  )
})

test_that("Empty folder does not raise an error", {
  expect_no_error(
    board_params_set_labkey(
      url = "https://learn.labkey.com/",
      folder = ""
    )
  )
})
