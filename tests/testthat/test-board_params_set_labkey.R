test_that("LabKey params are built properly", {
  expect_snapshot(
    board_params_set_labkey(
      board_alias = "labkey-board",
      url = "https://learn.labkey.com/",
      folder = "folder_name"
    )
  )
})

test_that("Empty URL raises an error", {
  expect_error(
    board_params_set_labkey(
      board_alias = "labkey-board",
      url = "",
      folder = "folder_name"
    )
  )
})

test_that("Empty folder does not raise an error", {
  expect_no_error(
    board_params_set_labkey(
      board_alias = "labkey-board",
      url = "https://learn.labkey.com/",
      folder = ""
    )
  )
})
