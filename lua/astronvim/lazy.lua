local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local result
  local lazy_cmd =
    { "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", lazypath }
  if vim.system then
    result = vim.system(lazy_cmd, { text = true }):wait()
  else -- TODO: remove vim.fn.system usage after dropping support for Neovim v0.9
    local output = vim.fn.system(lazy_cmd)
    result = { code = vim.api.nvim_get_vvar "shell_error", signal = 0, stdout = output, stderr = output }
  end
  if result.code ~= 0 then vim.api.nvim_err_writeln("Error cloning lazy.nvim repository...\n\n" .. result.stderr) end
  local oldcmdheight = vim.opt.cmdheight:get()
  vim.opt.cmdheight = 1
  vim.notify "Please wait while plugins are installed..."
  vim.api.nvim_create_autocmd("User", {
    desc = "Load Mason and Treesitter after Lazy installs plugins",
    once = true,
    pattern = "LazyInstall",
    callback = function()
      vim.cmd.bw()
      vim.opt.cmdheight = oldcmdheight
      vim.tbl_map(function(module) pcall(require, module) end, { "nvim-treesitter", "mason" })
      require("astronvim.utils").notify "Mason is installing packages if configured, check status with :Mason"
    end,
  })
end
vim.opt.rtp:prepend(lazypath)

local user_plugins = astronvim.user_opts "plugins"
for _, config_dir in ipairs(astronvim.supported_configs) do
  if vim.fn.isdirectory(config_dir .. "/lua/user/plugins") == 1 then user_plugins = { import = "user.plugins" } end
end

local spec = astronvim.updater.options.pin_plugins and { { import = astronvim.updater.snapshot.module } } or {}
vim.list_extend(spec, { { import = "plugins" }, user_plugins })

local colorscheme = astronvim.default_colorscheme and { astronvim.default_colorscheme } or nil

require("lazy").setup(astronvim.user_opts("lazy", {
  spec = spec,
  defaults = { lazy = true },
  install = { colorscheme = colorscheme },
  performance = {
    rtp = {
      paths = astronvim.supported_configs,
      disabled_plugins = { "tohtml", "gzip", "zipPlugin", "netrwPlugin", "tarPlugin" },
    },
  },
  lockfile = vim.fn.stdpath "data" .. "/lazy-lock.json",
}))
