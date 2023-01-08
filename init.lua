for _, source in ipairs {
  "core.utils",
  "core.options",
  "core.lazy",
  "core.diagnostics",
  "core.autocmds",
  "core.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

local colorscheme = astronvim.user_plugin_opts("colorscheme", false, false)
if colorscheme then colorscheme = pcall(vim.cmd.colorscheme, colorscheme) end
if not colorscheme then vim.cmd.colorscheme "astronvim" end

astronvim.conditional_func(astronvim.user_plugin_opts("polish", nil, false), true)

-- TODO v3: SWITCH THESE CONDITIONS
-- if vim.fn.has "nvim-0.9" ~= 1 or vim.version().prerelease then
if vim.fn.has "nvim-0.8" ~= 1 then
  vim.schedule(function() astronvim.notify("Unsupported Neovim Version! Please check the requirements", "error") end)
end
