-- remove later
local old_deprecate = vim.deprecate
vim.deprecate = function(name, alt, ver, plugin, backtrace)
  if name:find("tbl_flatten") then return end
  old_deprecate(name, alt, ver, plugin, backtrace)
end

require("lsps")
require("maps")
require("opts")
require("plgs")
