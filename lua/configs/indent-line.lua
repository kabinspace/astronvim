local M = {}

function M.config()
  local status_ok, indent_blankline = pcall(require, "indent_blankline")
  if status_ok then
    indent_blankline.setup(require("core.utils").user_plugin_opts("plugins.indent_blankline", {
      buftype_exclude = {
        "nofile",
        "terminal",
        "lsp-installer",
        "lspinfo",
      },
      filetype_exclude = {
        "help",
        "startify",
        "alpha",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
      },
      context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      },
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      char = "▏",
      show_current_context = true,
    }))
  end
end

return M
