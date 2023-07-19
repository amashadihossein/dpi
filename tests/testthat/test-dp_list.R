test_that("dp_list with s3 board", {
  board_params <- board_params_set_s3(
    bucket_name = "daapr-test",
    region = "us-east-1"
  )
  creds <- creds_set_aws(
    key = Sys.getenv("AWS_KEY"),
    secret = Sys.getenv("AWS_SECRET")
  )

  # set up board
  board_obj <- dp_connect(board_params = board_params, creds = creds)
  dp_list <- dp_list(board_object = board_obj)

  expect_s3_class(dp_list, "data.frame")
  expect_type(dp_list$version, "character")
  expect_named(dp_list, c("dp_name", "version", "rdsid", "project_name", "project_description",
    "branch_name", "branch_description", "class", "rds_file_sha1",
    "commit_description", "git_sha", "commit_time", "git_author_name",
    "git_author_email", "git_remote", "last_deployed", "archived"
  ))
})

