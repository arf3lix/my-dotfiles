return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",

  },
  keys = {
    { "<leader>ep", "<Cmd>Neotree toggle<CR>", desc = "Toggle Neo-tree" },
    { "<leader>e", "<Cmd>Neotree<CR>", desc = "Open Neo-tree" },
  },
  lazy = false, -- neo-tree will lazily load itself

  config = function()
    -- vim.keymap.set("n", "<leader>e", "<Cmd>Neotree<CR>")
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          }
        }
      }
    })
  end,
}
