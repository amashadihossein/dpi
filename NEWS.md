# dpi 0.1.1

* Fixed issue #29 where `dp_get()` could not pull old pin versions by hash. Now using hash to look up version number to pass to `pin_read()`
* Fixed typos in downgrade messages

# dpi 0.1.0

## Breaking changes

* dpbuild now requires pins >= v1.2.0. This means that data products will now use the v1 api and older data products are incompatible with dpbuild >= 0.1.0. Quite a few changes under the hood, but users will see minimal changes to the workflow.
* LabKey functionality has been temporarily removed until pins v1 can be extended to support LabKey boards
* data products are now retrieved by pin hash, rather than version. Since pins v1 pin version has included both hash and datetime stamp, but `dp_get` retrieves data products using hash only. 

## Other improvments

* Added a `NEWS.md` file to track changes to the package.
* `board_params_set_s3` no longer requires a board_alias
* `dp_connect` returns a board object that can be passed to `dp_get`, `dp_list`
* `dpconnect_check` removed to streamline workflow
