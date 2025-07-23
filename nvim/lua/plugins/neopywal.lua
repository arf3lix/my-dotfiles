return {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("neopywal").setup({

          use_wallust = true,
          transparent_background = true,
          plugins = {
            neotree = true,
            lualine = true,
          },
          default_fileformats = true,
          fileformats = {
              python = false,
          },

          vim.cmd.colorscheme("neopywal"),
      })

      require("neopywal.theme.plugins.lualine").setup({
          -- Any of the color values can either be:
          --   - A color exported by "get_colors()" (e.g.: `color8`)
          --   - A hexadecimal color (e.g.: "#ff0000").
          --   - A function with an optional "C" parameter that returns one of the two options above.
          --     e.g: function(C) return C.color1 end
          mode_colors = {
              normal = "color4",
              visual = "color5",
              insert = "color6",
              command = "color1",
              replace = "color2",
              terminal = "color3",
          },
          styles = {
              a = { "bold" },
              b = { "bold" },
              c = { "bold" },
              x = { "bold" },
              y = { "bold" },
              z = { "bold" },
          },
      })
    end,
}
