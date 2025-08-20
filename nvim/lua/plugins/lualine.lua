return {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'tokyonight'
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {
          {
            function()
              local filepath = vim.fn.expand('%:p')  -- Ruta absoluta del archivo
              local root = vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
              return filepath:sub(#root + 2) or vim.fn.expand('%:t')  -- Ruta relativa o nombre del archivo
            end,
          },
          {
            "navic",
            color_correction = nil,
            navic_opts = nil
          }
        },
      }
    })
  end
}
