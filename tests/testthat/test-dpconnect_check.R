# test_that("dpconnect_check when not connected", {
#   expect_snapshot(dpconnect_check(list(board_alias = "test_board")),
#                   error = T)
# })
#
# test_that("dpconnect_check with local board", {
#   # temporary tempfile, deleted at the end of the test
#   path <- withr::local_tempdir()
#   board_params <- board_params_set_local(
#     board_alias = "local_test_board",
#     folder = path
#   )
#   # make sure we can connect first
#   # this will create daap/ directory under path tempdir
#   expect_true(dp_connect(board_params = board_params))
#
#   # result from dpconnect_check is a list of class local
#   connect_result <- dpconnect_check(board_params)
#   expect_s3_class(connect_result, "local")
#   expect_named(connect_result, c("board", "name", "cache", "versions"))
#   expect_equal(connect_result$name, "local_test_board")
# })
#
# test_that("dpconnect_check with s3 board", {
#   board_params <- board_params_set_s3(
#     bucket_name = "daapr-test",
#     region = "us-east-1"
#   )
#   creds <- creds_set_aws(
#     key = Sys.getenv("AWS_KEY"),
#     secret = Sys.getenv("AWS_SECRET")
#   )
#
#   # result from dpconnect_check is a list of class s3, but need to connect first
#   expect_true(dp_connect(board_params = board_params, creds = creds))
#   connect_result <- dpconnect_check(board_params = board_params)
#   expect_s3_class(connect_result, "datatxt")
#   expect_named(connect_result, c('board', 'name', 'cache', 'versions', 'url',
#                                  'headers', 'needs_index', 'borwse_url', 'bucket',
#                                  'index_randomize', 'subpath', 'key', 'secret',
#                                  'connect', 'host', 'region'))
#   expect_equal(connect_result$name, "s3_test_board")
# })
