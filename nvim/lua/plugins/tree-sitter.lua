return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "rust", "python", "javascript", "html", "json" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        matchup = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },
      })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'inner',
        mode = 'topline', -- o prueba 'topline'
        separator = nil,
        zindex = 20,
      })
    end
  }
}
