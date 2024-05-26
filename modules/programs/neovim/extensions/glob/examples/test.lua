package.cpath = table.concat({
  "./target/debug/lib?.so",
  package.cpath,
}, ";")

local glob = require("glob")
print(glob.matches("*.go", "main.go"))
