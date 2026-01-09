# s3 board params are built properly

    Code
      board_params_set_s3(bucket_name = "bucket_name", region = "us-east-1")
    Output
        board_type bucket_name prefix    region
      1   s3_board bucket_name   <NA> us-east-1

# s3 board params are built properly with prefix

    Code
      board_params_set_s3(bucket_name = "bucket_name", prefix = "testPrefix/",
        region = "us-east-1")
    Output
        board_type bucket_name      prefix    region
      1   s3_board bucket_name testPrefix/ us-east-1

