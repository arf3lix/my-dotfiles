return {
  "SmiteshP/nvim-navic",
  opts = {
    lsp = {
      auto_attach = false, -- Lo manejamos manualmente con autocmd
    },
    highlight = true,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    safe_output = true,
    lazy_update_context = false,
    click = false,
  }
}
