## Logs

```sh
# Read logs.
$ tail -f ~/.cache/awesome/stdout

# Write logs.
$ awesome-client 'require("gears").debug.dump("hello there")'
```

## Hot Module Replacement

```lua
local _, err = pcall(function()
    package.loaded["modules.notifications"] = nil

    require("modules.notifications").init()
end)
```

## UI Tests

```sh
$ ./awesome/scripts/test-notifications.sh
```

## Icons

**Collection backup**:

```
eyJjb2xJZCI6eyJJRCI6MSwiYWN0aXZlIjoxLCJib29rbWFya19pZCI6IjZmeDE0Z3I3ZDdtMDAwMDAiLCJjb2xvciI6IjAwMDAwMCIsImNyZWF0ZWQiOm51bGwsIm5hbWUiOiJBd2Vzb21lVk0gaWNvbnMiLCJvcmRlciI6MCwic291cmNlIjoibG9jYWwiLCJzdGF0dXMiOjEsInVwZGF0ZWQiOjE2MDg1MDU5ODV9LCJjb2xCb29rbWFya0lkIjpbeyJpZCI6NTk3MjE4LCJ0ZWFtIjowLCJuYW1lIjoiY3B1IiwiY29sb3IiOiIjMDAwMDAwIiwicHJlbWl1bSI6MCwic29ydCI6MX0seyJpZCI6MzQxMTg2NiwidGVhbSI6MCwibmFtZSI6InJhbSIsImNvbG9yIjoiIzAwMDAwMCIsInByZW1pdW0iOjAsInNvcnQiOjJ9LHsiaWQiOjIxMTE3MDgsInRlYW0iOjAsIm5hbWUiOiJ0ZWxlZ3JhbSIsImNvbG9yIjoiIzAwMDAwMCIsInByZW1pdW0iOjAsInNvcnQiOjN9LHsiaWQiOjc4NjI0NSwidGVhbSI6MCwibmFtZSI6InNoaWVsZCIsImNvbG9yIjoiIzAwMDAwMCIsInByZW1pdW0iOjAsInNvcnQiOjR9LHsiaWQiOjc4NjM0NiwidGVhbSI6MCwibmFtZSI6InNoaWVsZCIsImNvbG9yIjoiIzAwMDAwMCIsInByZW1pdW0iOjAsInNvcnQiOjV9XX0=
```

<div>Icons made by <a href="https://www.flaticon.com/authors/prosymbols" title="Prosymbols">Prosymbols</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div><div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div><div>Icons made by <a href="https://www.flaticon.com/authors/pixel-perfect" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
