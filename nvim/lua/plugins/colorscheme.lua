return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night",  -- Estilo del tema ("night", "storm", "day", "moon")
    transparent = true,  -- Habilita fondo transparente
    terminal_colors = true,  -- Aplica colores a terminales integrados
    styles = {
      sidebars = "transparent",  -- Transparencia en paneles (NvimTree, etc.)
      floats = "transparent",    -- Transparencia en ventanas flotantes
    },
  },
  config = function(_, opts)

    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight") -- Aplicar el tema al cargar
  end,
}
