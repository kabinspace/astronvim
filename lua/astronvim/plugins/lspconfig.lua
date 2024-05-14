return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>li"] =
          { "<Cmd>LspInfo<CR>", desc = "LSP information", cond = function() return vim.fn.exists ":LspInfo" > 0 end }
      end,
    },
    { "folke/neoconf.nvim", lazy = true, opts = {} },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "williamboman/mason.nvim" },
      cmd = { "LspInstall", "LspUninstall" },
      opts = {
        ensure_installed = {},
        handlers = { function(server) require("astrolsp").lsp_setup(server) end },
      },
      config = function(...) require "astronvim.plugins.configs.mason-lspconfig" end,
    },
  },
  cmd = function(_, cmds) -- HACK: lazy load lspconfig on `:Neoconf` if neoconf is available
    if require("astrocore").is_available "neoconf.nvim" then table.insert(cmds, "Neoconf") end
    vim.list_extend(cmds, { "LspInfo", "LspLog", "LspStart" }) -- add normal `nvim-lspconfig` commands
  end,
  event = "User AstroFile",
  config = function(...) require "astronvim.plugins.configs.lspconfig"(...) end,
}
