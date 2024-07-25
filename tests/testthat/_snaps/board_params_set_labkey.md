# LabKey params are built properly

    Code
      board_params_set_labkey(url = "https://learn.labkey.com/", folder = "folder_name")
    Output
          board_type      folder                       url
      1 labkey_board folder_name https://learn.labkey.com/

# LabKey params are built properly with cache_alias

    Code
      board_params_set_labkey(url = "https://learn.labkey.com/", folder = "folder_name",
        cache_alias = "labkey-board")
    Output
          board_type  cache_alias      folder                       url
      1 labkey_board labkey-board folder_name https://learn.labkey.com/

